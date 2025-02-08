import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teraflow/pages/home_page.dart';
import 'package:teraflow/pages/auth/login_page.dart';
import 'package:teraflow/pages/auth/signup_page.dart';
import 'package:teraflow/therapist/home_therapist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    print("Pass .env Loaded Successfully!");
  } catch (e) {
    print("Error loading .env: $e");
  }

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(MyApp());
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
                    return CircularProgressIndicator();
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
                    return CircularProgressIndicator();
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
