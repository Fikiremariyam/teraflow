import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teraflow/chatbot/chatbot_screen.dart';
import 'package:teraflow/pages/SELFHELP/breathing_exercise.dart';
import 'package:teraflow/pages/SELFHELP/meditation_list.dart';
import 'package:teraflow/pages/searchpage.dart';
import 'package:teraflow/util/category_card.dart';
import 'package:teraflow/util/therapist_card.dart';
import 'package:teraflow/pages/calendar_page.dart';
import 'package:teraflow/pages/utils/chats/chatlist_page.dart';
import 'package:teraflow/pages/utils/chats/chatpage_main.dart';
import 'package:teraflow/pages/SELFHELP/selfhelp_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Create a GlobalKey for Scaffold

  // ignore: unused_field
  final List<Widget> _pages = [
    ChatPage(),
    CalendarPage(),
    SelfHelpPage(),
  ];
  Future<File?> uploadnewImage(File imageFile) async {
    //for external directory dynamically

    if (await Permission.storage.request().isGranted) {
      // Ask for permission
      Directory? externalDir =
          await getExternalStorageDirectory(); // Get external storage

      String currentUser = FirebaseAuth.instance.currentUser!.uid;

      String customPath =
          '${externalDir?.path}/images/profile/${currentUser}'; // Define your custom path

      await Directory(customPath)
          .create(recursive: true); // Create folder if not exists

      File newImage = File('$customPath/profile.jpg'); // Create file path
      return await imageFile
          .copy(newImage.path); // Copy file to custom directory
    } else {
      print("Storage permission denied.");
      return null;
    }
  }

  Widget _profilePic() {
    // to get the adrees of the image-fore firebase firestore
    /*Future<String?> getUserProfileImage() async {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc['profileImage'];
      }*/
    Future<File?> getSavedImage() async {
      final directory = await getApplicationDocumentsDirectory();
      String currentUser = FirebaseAuth.instance.currentUser!.uid;

      final localPath =
          '${directory.path}/images/profile/${currentUser}/profile.jpg';

      File file = File(localPath);
      if (await file.exists()) {
        return file;
      }
      return null;
    }

    return FutureBuilder<File?>(
      future: getSavedImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(snapshot.data!),
          );
        } else {
          return CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          );
        }
      },
    );
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F8FF),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.person),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.deepPurple[250]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.deepPurple[500]),
              onPressed: () {},
            ),
          ],
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        //a drawer which  contains the user prfile and some of navications
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
              ),
              currentAccountPicture: GestureDetector(
                onTap: () async {
                  // to change the profile Image

                  // Simplified logic to pick a local image without Firebase
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    // Optionally update a local state or show the image temporarily
                    setState(() {}); // Trigger UI update if necessary
                  }
                },
                child: _profilePic(),
              ),
              accountName: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(
                        text: FirebaseAuth.instance.currentUser?.displayName ??
                            '',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (newName) async {
                        // You can update the name locally if needed
                        setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Optional: Open another dialog for editing
                    },
                  ),
                ],
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ??
                    'No email available',
              ),
            ),

            // Phone Number Section
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone Number'),
              subtitle: Text(
                FirebaseAuth.instance.currentUser?.phoneNumber ??
                    'No phone number added',
              ),
              trailing: Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController phoneController =
                        TextEditingController();
                    return AlertDialog(
                      title: Text('Update Phone Number'),
                      content: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            String phoneNumber = phoneController.text.trim();
                            // Save phone number to the database (or other logic)
                            // Note: FirebaseAuth does not directly support phone updates
                            // You can save this in your database
                            Navigator.pop(context);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Dark Mode Toggle
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Mode'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  // Implement dark mode toggle logic
                  if (value) {
                    // Switch to dark theme
                    setState(() {
                      // Update app theme to dark mode
                      // Example: ThemeData.dark() or custom theme
                    });
                  } else {
                    // Switch to light theme
                    setState(() {
                      // Update app theme to light mode
                      // Example: ThemeData.light() or custom theme
                    });
                  }
                },
              ),
            ),

            // Sign Out
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
          children: [
            // Home Screen content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello,',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Kalkidan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[100],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.person),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),

                  // Questionnaire Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 182, 138),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('lib/images/home_page.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'How do you feel?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Fill out your questionnaire card right now',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Get Started',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Search Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, size: 18),
                          border: InputBorder.none,
                          hintText: 'How can we help you?',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Categories Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,

                      //backgroundColor: Colors.deepPurple[50],
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CategoryCard(
                            categoryName: 'Meditation',
                            iconImagePath: 'lib/icons/meditation.png',
                          ),
                          CategoryCard(
                            categoryName: 'Community',
                            iconImagePath: 'lib/icons/community.png',
                          ),
                          CategoryCard(
                            categoryName: 'Exercise',
                            iconImagePath: 'lib/icons/exercise.png',
                          ),
                          CategoryCard(
                            categoryName: 'Journaling',
                            iconImagePath: 'lib/icons/journaling.png',
                          ),
                          CategoryCard(
                            categoryName: 'Time',
                            iconImagePath: 'lib/icons/time.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Therapist Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Therapist list',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Searchpage()),
                            ); //navigator
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor1.jpg',
                          rating: '4.9',
                          therapistName: 'Dr. Amla Douge',
                          therapistProfession: 'Therapist',
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor2.jpg',
                          rating: '4.8',
                          therapistName: 'Dr. John Smith',
                          therapistProfession: 'Psychologist',
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor2.jpg',
                          rating: '4.8',
                          therapistName: 'Dr. John Smith',
                          therapistProfession: 'Psychologist',
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor2.jpg',
                          rating: '4.8',
                          therapistName: 'Dr. John Smith',
                          therapistProfession: 'Psychologist',
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor1.jpg',
                          rating: '4.7',
                          therapistName: 'Dr. Jane Doe',
                          therapistProfession: 'Counselor',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Other Pages
            ChatPage(),
            CalendarPage(),
            SelfHelpPage(),
            ChatScreen(),
            BreathingExerciseDetailPage(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: Colors.deepPurple[200],
        child: const Icon(
          Icons.support,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: GNav(
          backgroundColor: Colors.white,
          color: const Color.fromARGB(255, 97, 97, 97),
          activeColor: Colors.deepPurple.shade500,
          tabBackgroundColor: Colors.deepPurple.shade100,
          duration: Duration(milliseconds: 900),
          gap: 8,
          padding: EdgeInsets.all(16),
          selectedIndex: _selectedIndex,
          onTabChange: _onNavBarTap,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.chat,
              text: 'Chat',
            ),
            GButton(
              icon: Icons.calendar_month,
              text: 'Calendar',
            ),
            GButton(
              icon: Icons.book,
              text: 'Self-help',
            ),
          ],
        ),
      ),
    );
  }
}
