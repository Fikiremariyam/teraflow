import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/message_format.dart';
import 'package:provider/provider.dart';
import 'package:teraflow/pages/home_page.dart';
import 'package:teraflow/pages/auth/login_page.dart';
import 'package:teraflow/pages/auth/signup_page.dart';
import 'package:teraflow/provider/provider.dart';
import 'package:teraflow/therapist/home_therapist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

void main() async {
  //flutter widget binding
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    print("Pass .env Loaded Successfully!");
  } catch (e) {
    print("Error loading .env: $e");
  }
  // firebase intialazing
  await Firebase.initializeApp();
  //cloudinary inilazing
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: "dd8qfpth2");
  final cloudinary = CloudinaryObject.fromCloudName(cloudName: "dd8qfpth2");
  runApp(ChangeNotifierProvider(
      create: (context) => MessageProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/login': (context) => FirebaseAuth.instance.currentUser == null
            ? LoginPage()
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var role = snapshot.data!.get('role');
                  print("+++++++++++++++++++++++++");
                  print(role);

                  if (role == "Customer") {
                    return HomePage();
                  } else {
                    return HomePaget();
                  }
                }),
        '/signup': (context) => FirebaseAuth.instance.currentUser == null
            ? SignupPage()
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var role = snapshot.data!.get('role');
                  if (role == "custmer") {
                    return HomePage();
                  } else {
                    return HomePaget();
                  }
                }),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('404 - Page not found'),
          ),
        ),
      ),
    );
  }
}
