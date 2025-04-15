// web_homepaget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:teraflow/pages/clientpages/splashPage/ProfilePage.dart';
import 'package:teraflow/features/chats/chatlist_page.dart';
import 'package:teraflow/pages/therapistPages/blog_page.dart';
import 'package:teraflow/features/Calander/calendar_therapist.dart';
import 'package:teraflow/pages/therapistPages/finance_page.dart';
import 'package:teraflow/pages/therapistPages/client_page.dart';
import 'package:teraflow/pages/therapistPages/payment_page.dart';
import 'package:teraflow/pages/therapistPages/therapist_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WebHomePaget extends StatefulWidget {
  @override
  _WebHomePagetState createState() => _WebHomePagetState();
}

class _WebHomePagetState extends State<WebHomePaget> {
  int _selectedIndex = 0;
  File? _profileImage;
  String _name = "Dr. Amla Douge";
  String _email = "therapist@theraflow.com";

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
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
      TherapistProfile(onProfileInfoChanged: _updateProfileInfo),
      ClientPage(),
      CalendarTherapist(),
      ChatPage(),
      //BlogPage(),
      FinancePage(),
      ProfileScreen()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SafeArea(
        child: Row(
          children: [
            // Side navigation panel for web
            Container(
              width: 250,
              color: Colors.deepPurple[50],
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(_name),
                    accountEmail: Text(_email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage('lib/images/doctor1.jpg')
                              as ImageProvider,
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
                      },
                    );
                  }).toList(),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalendarTherapist()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[200], // Button color
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
            // Main content area for web
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
