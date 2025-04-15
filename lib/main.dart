import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teraflow/pages/adminPages/admindashboard.dart';
import 'package:teraflow/pages/clientpages/home_page.dart';
import 'package:teraflow/features/auth/login_page.dart';
import 'package:teraflow/features/auth/signup_page.dart';
import 'package:teraflow/pages/splashPage/OnboardingScreen.dart';
import 'package:teraflow/pages/splashPage/WellcomeScreen.dart';
import 'package:teraflow/provider/provider.dart';
import 'package:teraflow/pages/therapistPages/home_therapist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:teraflow/responsive_widget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    print("Pass .env Loaded Successfully!");
  } catch (e) {
    print("Error loading .env: $e");
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: "dd8qfpth2");
  final cloudinary = CloudinaryObject.fromCloudName(cloudName: "dd8qfpth2");

  runApp(ChangeNotifierProvider(
    create: (context) => MessageProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialRoute = "none";
  
  Future<void> determineInitialRoute() async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userEmail = user.email!;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      if (userDoc.exists) {
        
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        
        if (userData != null && userData.containsKey('role')) {
          String role = userData['role'];
          print("User Role Retrieved from Firestore: $role");

          setState(() {
            if (role == "Customer") {
              initialRoute = '/Customer';
            } else if (role == "Therapist") {
              initialRoute = '/Therapist';
            } else if (role == "Admin") {
              initialRoute = '/AdminDashboard';
            } else {
              initialRoute = '/login';
            }
          });
        } else {
          print("Role not found in Firestore document.");
          setState(() {
            initialRoute = '/login';
          });
        }
      } else {
        print("User document not found for email: $userEmail");
        setState(() {
          initialRoute = '/login';
        });
      }
    } else {
    print("==============================================it is null ======================");
      setState(() {
        initialRoute = '/Onboarding';
      });
    }
  }


  @override
  void initState() {
    super.initState();
    determineInitialRoute();
  }
  @override
  Widget build(BuildContext context) {
      if (initialRoute == "none") {
      
      return const Center(child: CircularProgressIndicator());
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/Onboarding': (context) => OnboardingScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/Customer': (context) => WillPopScope(
              onWillPop: () async {
                return false; // Prevent back button from logging out
              },
              child: ResponsiveWidget(
                mobile: HomePage(),
                // desktop: WebHomePage(), // Web version for customer
              ),
            ),
        '/Therapist': (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: ResponsiveWidget(
                mobile: HomePaget(
                  selectedindex: 0,
                ),
                // desktop: WebHomePaget(), // Web version for therapist
              ),
            ),
        '/AdminDashboard': (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AdminDashboard(), // Admin dashboard
            ),
// Admin dashboard
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('404 - Page not found')),
        ),
      ),
    );
  }
}
