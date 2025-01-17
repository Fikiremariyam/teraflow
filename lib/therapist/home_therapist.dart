import 'dart:io';
import 'package:flutter/material.dart';
import 'package:teraflow/therapist/blog_page.dart';
import 'package:teraflow/therapist/calendar_therapist.dart';
import 'package:teraflow/therapist/chat_therapist.dart';
import 'package:teraflow/therapist/finance_page.dart';
import 'package:teraflow/therapist/client_page.dart';
import 'package:teraflow/therapist/therapist_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePaget extends StatefulWidget {
  @override
  _HomePagetState createState() => _HomePagetState();
}

class _HomePagetState extends State<HomePaget> {
  int _selectedIndex = 0;
  File? _profileImage;
  String _name = "Dr. Amla Douge";
  String _email = "therapist@theraflow.com";

  // Callback to update profile image, name, and email
  void _updateProfileInfo(File newImage, String newName, String newEmail) {
    setState(() {
      _profileImage = newImage;
      _name = newName;
      _email = newEmail;
    });
  }

  final List<Widget> _pages = [
    TherapistProfile(
      onProfileInfoChanged: (File newImage, String newName, String newEmail) {},
    ), // Profile page first
    ClientPage(),
    CalendarTherapist(),
    ChatTherapist(),
    BlogPage(),
    FinancePage(),
  ];

  final List<String> _titles = [
    'Profile',
    'Client',
    'Calendar',
    'Chat',
    'Blog',
    'Finance',
  ];

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
            ListTile(
              title: Text('Profile'),
              onTap: () => _onDrawerItemTapped(0),
            ),
            ListTile(
              title: Text('Client'),
              onTap: () => _onDrawerItemTapped(1),
            ),
            ListTile(
              title: Text('Calendar'),
              onTap: () => _onDrawerItemTapped(2),
            ),
            ListTile(
              title: Text('Chat'),
              onTap: () => _onDrawerItemTapped(3),
            ),
            ListTile(
              title: Text('Blog'),
              onTap: () => _onDrawerItemTapped(4),
            ),
            ListTile(
              title: Text('Finance'),
              onTap: () => _onDrawerItemTapped(5),
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
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages.map((page) {
            if (page is TherapistProfile) {
              return TherapistProfile(
                  onProfileInfoChanged: _updateProfileInfo); // Corrected
            }
            return page;
          }).toList(),
        ),
      ),
    );
  }
}
