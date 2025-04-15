import 'package:flutter/material.dart';
import 'package:teraflow/resources/components/My_button.dart';
import 'package:teraflow/resources/components/my_textfield.dart';
import 'package:teraflow/resources/components/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_validator/form_validator.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String _role = 'Customer';
  String _selectedLanguage = 'English';
  String _selectedGender = '';
  DateTime? _selectedDate;
  bool _acceptedTerms = false;
  bool _isPasswordVisible = false;

  List<String> _roles = ['Customer', 'Therapist'];
  List<String> _languages = ['English', 'አማርኛ'];

  void showAuthResult(BuildContext context, String? errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorMessage == null ? 'Success' : 'Error'),
          content: Text(errorMessage ?? 'Authentication Successful'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void registerUser(BuildContext context) async {
    if (!_acceptedTerms) {
      showAuthResult(context, 'Please accept the Terms of Service');
      return;
    }

    try {
      UserCredential userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCred.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(emailController.text)
            .set({
          'email': emailController.text,
          'fullName': nameController.text,
          'phone': phoneController.text,
          'role': _role,
          'gender': _selectedGender,
          'dateOfBirth': _selectedDate?.toIso8601String(),
          'created_at': DateTime.now()
        });

        if (mounted) {
          Navigator.pushReplacementNamed(context, "/login");
        }
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email is already in use.';
          print("+++++++++++++++++++++++++++++++++++++++++=");
          break;
        default:
          errorMessage = 'An unexpected error occurred.';
      }
      showAuthResult(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: _languages.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(value),
                    if (value == _selectedLanguage) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check, color: Colors.deepPurple),
                    ],
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _selectedLanguage = newValue);
              }
            },
            underline: Container(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400), // Maximum width for web
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Create account ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SquareTile(imagePath: 'lib/images/google.png'),
                    const SizedBox(width: 16),
                    SquareTile(imagePath: 'lib/images/apple.png'),
                  ],
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: const InputDecoration(
                    labelText: 'I am a',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: _roles
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => _role = value!),
                ),
                const SizedBox(height: 16),
                MyTextfield(
                  controller: nameController,
                  hintText: 'Full Name',
                  obscureText: false,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                const SizedBox(height: 16),
                const Text('Gender', style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (value) =>
                            setState(() => _selectedGender = value!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (value) =>
                            setState(() => _selectedGender = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 13)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text:
                        _selectedDate?.toLocal().toString().split(' ')[0] ?? '',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You must be 13 or older to create an account',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 16),
                MyTextfield(
                    controller: phoneController,
                    hintText: 'Phone Number',
                    obscureText: false,
                    prefixIcon: Icon(Icons.phone_outlined)),
                const SizedBox(height: 16),
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) =>
                          setState(() => _acceptedTerms = value!),
                      activeColor: Colors.deepPurple,
                    ),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: 'I agree to TeraFlow '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                MyButton(
                  onTab: () => registerUser(context),
                  label: 'Sign Up',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account? ',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Login',
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
