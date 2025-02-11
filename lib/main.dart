import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email) // Using email of the logged-in user
          .get();
      if (userDoc.exists) {
        String role = userDoc.get('role');
        setState(() {
          initialRoute = (role == "Customer") ? '/Customer' : '/Therapist';
        });
      } else {
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
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('404 - Page not found')),
        ),
      ),
    );
  }
}
