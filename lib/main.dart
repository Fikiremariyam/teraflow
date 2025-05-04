import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teraflow/pages/adminPages/admindashboard.dart';
import 'package:teraflow/pages/clientpages/home_page.dart';
import 'package:teraflow/features/auth/login_page.dart';
import 'package:teraflow/features/auth/signup_page.dart';
import 'package:teraflow/pages/clientpages/OnboardingScreen.dart';
import 'package:teraflow/pages/clientpages/splashPage/WellcomeScreen.dart';
import 'package:teraflow/provider/provider.dart';
import 'package:teraflow/pages/therapistPages/home_therapist.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:teraflow/responsive_widget.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase/supabase.dart';


void main() async {

  
// intializing supabase
  await Supabase.initialize(
    url: "https://elkpeemuxtpxfwubiphv.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVsa3BlZW11eHRweGZ3dWJpcGh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYzNjgzMTQsImV4cCI6MjA2MTk0NDMxNH0.gjEFIj-fs3hv8-jpByu6UwJoIf5s4XDneQB03sXleHQ",

  );
// intialzing flutter widget 
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    print("Pass .env Loaded Successfully!");
  } catch (e) {
    print("Error loading .env: $e");
  }
// intilazing fire base 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  

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

    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (kIsWeb ) {
              initialRoute = '/AdminDashboard';
              return;
      }

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
