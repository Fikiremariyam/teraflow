import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:teraflow/components/My_button.dart';
import 'package:teraflow/components/my_textfield.dart';
import 'package:teraflow/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_validator/form_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LoginPage> {
  final emailController = TextEditingController(); // Change to email controller
  final passwordController = TextEditingController();
// a funciton to show the status of the message after we clicked it

  void showSuccessMessage(BuildContext context, String? successMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('You have logged in successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

// to show error message

  void showAuthResult(BuildContext context, String? errorMessage) {
    if (errorMessage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Authentication Successful'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

// a funciton which  wich do the log in funcnality

  void logUserIn(BuildContext content) async {
    String email = emailController.text; // Change to email
    String password = passwordController.text;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      showAuthResult(context, null);
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('email')
          .get();
      print(userDoc);
      if (mounted) {
        var role = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        print(role);
        Navigator.pushReplacementNamed(context, "/login");
      }
    } on FirebaseAuthException catch (error) {
      // Authentication failed
      if (error is FirebaseAuthException) {
        if (error.code == 'wrong-password') {
          showAuthResult(context, 'wrong password.');
        } else if (error.code == 'invalid-email') {
          showAuthResult(
              context, 'there is no account registerd with this email ');
        } else if (error.code == 'invalid-credential') {
          showAuthResult(context, 'wrong emai or password .');
        } else {
          showAuthResult(context, 'An unexpected error occurred.');
        }
      } else {
        showAuthResult(context, 'An unexpected exeption  occurred.');
      }
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(Icons.lock, size: 100, color: Colors.deepPurple[500]),
                const SizedBox(height: 50),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  controller: emailController, // Use email controller
                  hintText: 'Email', // Change hint text to Email
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTab: () => logUserIn(context),
                  label: 'Sign In',
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'or continue with',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                // Social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'lib/images/google.png'),
                    const SizedBox(width: 25),
                    SquareTile(imagePath: 'lib/images/apple.png'),
                  ],
                ),
                const SizedBox(height: 20),
                // Register option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Register now?',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
