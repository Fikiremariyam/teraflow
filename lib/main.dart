import 'package:flutter/material.dart';
import 'package:teraflow/pages/home_page.dart';
import 'package:teraflow/pages/login_page.dart';
import 'package:teraflow/pages/signup_page.dart';
import 'package:teraflow/therapist/home_therapist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home_therapist': (context) =>
            HomePaget(), // Route for therapist homepage
        '/home_customer': (context) =>
            HomePage(), // Route for customer homepage
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
