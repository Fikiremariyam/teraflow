import 'package:flutter/material.dart';

import 'package:teraflow/pages/login_page.dart';
import 'package:teraflow/pages/home_page.dart'; // Add your HomePage widget here.


void main() {
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
        '/login': (context) => LoginPage(),
        '/home': (context) =>  HomePage(),
      },
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
