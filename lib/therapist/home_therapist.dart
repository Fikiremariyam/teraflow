import 'package:flutter/material.dart';
import 'package:teraflow/therapist/blog_page.dart';
import 'package:teraflow/therapist/calendar_therapist.dart';
import 'package:teraflow/therapist/chat_therapist.dart';
import 'package:teraflow/therapist/finance_page.dart';
import 'package:teraflow/therapist/client_page.dart';
import 'package:teraflow/therapist/therapist_profile.dart';

class HomePaget extends StatefulWidget {
  @override
  _HomePagetState createState() => _HomePagetState();
}

class _HomePagetState extends State<HomePaget> {
  int _selectedIndex = 0;

  // Pages to navigate
  final List<Widget> _pages = [
    TherapistProfile(), // Profile page first
    ClientPage(), // Client page second
    CalendarTherapist(), // Calendar page third
    ChatTherapist(), // Chat page fourth
    BlogPage(), // Blog page fifth
    FinancePage(), // Finance page sixth
  ];

  // Titles for each page
  final List<String> _titles = [
    'Profile',
    'Client',
    'Calendar',
    'Chat',
    'Blog',
    'Finance',
  ];

  // Background colors for AppBar
  final List<Color> _backgroundColors = [
    Colors.deepPurple[200]!,
    Colors.deepPurple[200]!,
    Colors.deepPurple[200]!,
    Colors.deepPurple[200]!,
    Colors.deepPurple[200]!,
    Colors.deepPurple[200]!,
  ];

  // Handle Drawer item tap
  void _onDrawerItemTapped(int index) {
    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      print("Page not implemented yet");
    }
    Navigator.of(context).pop(); // Close drawer after selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Background color for the whole page
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Dynamically change title
        backgroundColor:
            _backgroundColors[_selectedIndex], // Dynamic AppBar color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Dr. Amla Douge"),
              accountEmail: Text("therapist@theraflow.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('lib/images/doctor1.jpg'),
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
          ],
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}
