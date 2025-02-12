import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teraflow/pages/admindashboard.dart';
import 'package:teraflow/pages/home_page.dart';
import 'package:teraflow/pages/auth/login_page.dart';
import 'package:teraflow/pages/auth/signup_page.dart';
import 'package:teraflow/pages/splashPage/OnboardingScreen.dart';
import 'package:teraflow/pages/splashPage/WellcomeScreen.dart';
import 'package:teraflow/provider/provider.dart';
import 'package:teraflow/therapist/home_therapist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:teraflow/webbodies/web_homepage.dart';
import 'package:teraflow/webbodies/web_homepaget.dart';
import 'package:teraflow/widget/responsive_widget.dart';
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

  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: "dd8qfpth2");
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
  String initialRoute = '/Onboarding';

  @override
  void initState() {
    super.initState();
    determineInitialRoute();
  }

  Future<void> determineInitialRoute() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userEmail = user.email!;
      print("Current Logged-in Email: $userEmail");

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      if (userDoc.exists) {
        print("User document found in Firestore!");

        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
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
      print("No user is logged in.");
      setState(() {
        initialRoute = '/Onboarding';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        '/Customer': (context) => ResponsiveWidget(
              mobile: HomePage(),
              desktop: WebHomePage(), // Web version for customer
            ),
        '/Therapist': (context) => ResponsiveWidget(
              mobile: HomePaget(),
              desktop: WebHomePaget(), // Web version for therapist
            ),
        '/AdminDashboard': (context) => AdminDashboard(), // Admin dashboard
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('404 - Page not found')),
        ),
      ),
    );
  }
}
