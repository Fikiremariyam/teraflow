// home_pagete.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:teraflow/pages/splashPage/ProfilePage.dart';
import 'package:teraflow/pages/utils/chats/chatlist_page.dart';
import 'package:teraflow/therapist/blog_page.dart';
import 'package:teraflow/therapist/calendar_therapist.dart';
import 'package:teraflow/therapist/finance_page.dart';
import 'package:teraflow/therapist/client_page.dart';
import 'package:teraflow/therapist/payment_page.dart';
import 'package:teraflow/therapist/therapist_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePaget extends StatefulWidget {
  int? selectedindex;
  

  HomePaget({this.selectedindex,});

  @override
  _HomePagetState createState() => _HomePagetState();
}

class _HomePagetState extends State<HomePaget> {
  late int _selectedIndex = 0;
  File? _profileImage;
  String _name = "Dr. Amla Douge";
  String _email = "therapist@theraflow.com";

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
    _selectedIndex = widget.selectedindex ?? 0 ; 
  }

  void _fetchUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? "No email found";
      });
    }
  }

  void _updateProfileInfo(File newImage, String newName) {
    setState(() {
      _profileImage = newImage;
      _name = newName;
    });
  }

  final List<String> _titles = [
    'Profile',
    'Client',
    'Calendar',
    'Chat',
    'Blog',
    'Finance',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      TherapistProfile(
        onProfileInfoChanged: _updateProfileInfo,
      ),
      ClientPage(),
      CalendarTherapist(),
      ChatPage(),
      BlogPage(),
      FinancePage(),
      //ProfileScreen()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.deepPurple[200],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_name),
              accountEmail: Text(_email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage('lib/images/doctor1.jpg') as ImageProvider,
              ),
            ),
            ..._titles.asMap().entries.map((entry) {
              int index = entry.key;
              String title = entry.value;
              return ListTile(
                title: Text(title),
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  // Navigate to PaymentPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarTherapist()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[200], // Button color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text('Request Payment'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
    );
  }
}
