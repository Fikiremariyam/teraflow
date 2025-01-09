import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teraflow/pages/login_page.dart';
import 'package:teraflow/pages/home_page.dart'; // Add your HomePage widget here.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => FirebaseAuth.instance.currentUser == null ?  LoginPage():  HomePage(),
        '/home': (context) =>  FirebaseAuth.instance.currentUser == null ?  LoginPage():  HomePage(),
      },
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
