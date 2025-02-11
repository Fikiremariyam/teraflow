import 'dart:io';

import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teraflow/chatbot/chatbot_screen.dart';
import 'package:teraflow/pages/SELFHELP/breathing_exercise.dart';
import 'package:teraflow/pages/SELFHELP/meditation_list.dart';
import 'package:teraflow/pages/searchpage.dart';
import 'package:teraflow/pages/splashPage/ProfilePage.dart';
import 'package:teraflow/pages/splashPage/calendar_page.dart';
import 'package:teraflow/util/category_card.dart';
import 'package:teraflow/util/therapist_card.dart';
import 'package:teraflow/pages/calendar_page.dart';
import 'package:teraflow/pages/utils/chats/chatlist_page.dart';
import 'package:teraflow/pages/utils/chats/chatpage_main.dart';
import 'package:teraflow/pages/SELFHELP/selfhelp_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';

class WebHomePage extends StatefulWidget {
  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Create a GlobalKey for Scaffold
  var username = TextEditingController();
  var phonenumber = TextEditingController();

  // List of widgets to change on body
  final List<Widget> _pages = [
    ChatPage(),
    CalendarPage(),
    SelfHelpPage(),
    ProfileScreen(),
  ];

  // image uploading function
  Future<File?> uploadnewImage(File imageFile) async {
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

  //getting  profule  pic
  Widget _profilePic() {
    // Initialize Cloudinary properly
    final cloudinary = Cloudinary.fromCloudName(cloudName: "dd8qfpth2");

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey,
      child: CldImageWidget(
        cloudinary: cloudinary, // Pass Cloudinary instance
        publicId: "cld-sample-4",
      ),
    );
  }

  //getting user name
  void getusercred() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    String usernameholder =
        docSnapshot.data()?['username'] ?? 'enter yourname ';
    String phoneno =
        docSnapshot.data()?['phonenumber'] ?? 'enter your  phone  no';
    setState(() {
      username.text = usernameholder;
      phonenumber.text = phoneno;
    });
  }

  // showing edit dialog
  void showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Username"),
          content: TextField(
            controller: username,
            decoration: InputDecoration(hintText: "Enter new username"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String newName = username.text.trim();
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .update({'username': newName});

                  setState(() {
                    username.text = newName; // Update the UI
                  });
                }
                Navigator.pop(context); // Close dialog
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    //function to run then ever the page is loaded
    super.initState();
    getusercred();
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
                print("=====================================================");
                print("button clicked"); // debug code
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: _profilePic(),
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
                        Icon(Icons.search, color: Colors.deepPurple[200]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.deepPurple[400]),
              onPressed: () {},
            ),
          ],
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF8F8FF),
      // /*
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
                      controller: username,
                      decoration: InputDecoration(
                        hintText: username.text.isNotEmpty
                            ? username.text
                            : "Enter username",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showEditDialog();
                      },
                    ),
                  ),
                ],
              ),
              accountEmail: null,
            ),

            // Phone Number Section
            ListTile(
              leading: Icon(Icons.phone),
              title: Expanded(
                child: TextField(
                  controller: phonenumber,
                  decoration: InputDecoration(
                    hintText: phonenumber.text.isNotEmpty
                        ? phonenumber.text
                        : "Enter username",
                    border: InputBorder.none,
                  ),
                ),
              ),
              trailing: Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Edit phone no "),
                      content: TextField(
                        controller: phonenumber,
                        decoration:
                            InputDecoration(hintText: "Enter new number"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context), // Close dialog
                          child: Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String newnumber = phonenumber.text.trim();
                            if (newnumber.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .update({'phone_number': newnumber});

                              setState(() {
                                phonenumber.text = newnumber; // Update the UI
                              });
                            }
                            Navigator.pop(context); // Close dialog
                          },
                          child: Text("Submit"),
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
      // */
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
                                username.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                          onTap: () {},
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
                          experience: '15 years of experience',
                          onTap: () {},
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor2.jpg',
                          rating: '4.8',
                          therapistName: 'Dr. John Smith',
                          therapistProfession: 'Psychologist',
                          experience: '5 years of experience',
                          onTap: () {},
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor2.jpg',
                          rating: '4.8',
                          therapistName: 'Dr. John Smith',
                          therapistProfession: 'Psychologist',
                          experience: '10 years of experience',
                          onTap: () {},
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor2.jpg',
                          rating: '4.8',
                          therapistName: 'Dr. John Smith',
                          therapistProfession: 'Psychologist',
                          experience: '',
                          onTap: () {},
                        ),
                        SizedBox(width: 10),
                        TherapistCard(
                          therapistImagePath: 'lib/images/doctor1.jpg',
                          rating: '4.7',
                          therapistName: 'Dr. Jane Doe',
                          therapistProfession: 'Counselor',
                          experience: '',
                          onTap: () {},
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
            ChatbotScreen(),
            BreathingExerciseDetailPage(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
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
