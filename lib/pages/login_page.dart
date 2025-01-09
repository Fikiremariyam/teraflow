import 'package:flutter/material.dart';
import 'package:teraflow/components/my_button.dart';
import 'package:teraflow/components/my_textfield.dart';
import 'package:teraflow/components/square_tile.dart';
import 'package:form_validator/form_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

bool showAuthResult(BuildContext context, String? errorMessage)  {
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
    return true;
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
  
  return false;
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});


  @override
  State <LoginPage> createState() => _LogInPageState();
}
class _LogInPageState extends State <LoginPage>{
  
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
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
                Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.deepPurple[500],
                ),
                const SizedBox(height: 50),
                // Welcome message
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // Username text field
                MyTextfield(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Password text field
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle forgot password action
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Sign in button
                MyButton(
                  onTab: ()  
                        async {
                    try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: usernameController!.toString(), password: passwordController!.toString());
                        
                        showAuthResult(context, null);
                        if (mounted){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Homepage()));
                    
                          }

                        } on FirebaseAuthException catch (
                          error) {
                          // Authentication failed
                          if (error is FirebaseAuthException) {
                            if (error.code == 'wrong-password') 
                            {
                              showAuthResult(context, 'wrong password.');
                            } else if (error.code == 'invalid-email') 
                            {
                              showAuthResult(context, 'there is no account registerd with this email ');
                            } else if (error.code == 'invalid-credential')
                            {
                              showAuthResult(context, 'wrong emai or password .');

                            }else
                             {
                            
                              showAuthResult(context, 'An unexpected error occurred.');
                            }
                          } 
                          else {
                            showAuthResult(context, 'An unexpected exeption  occurred.');
                          }
                        };
                        }
  
                ),
                const SizedBox(height: 50),
                // Or continue with section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'lib/images/google.png'),
                    const SizedBox(width: 25),
                    SquareTile(imagePath: 'lib/images/apple.png'),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Navigate to a registration page
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
