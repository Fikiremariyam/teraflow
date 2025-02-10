import 'package:flutter/material.dart';
import 'package:teraflow/pages/home_page.dart';
import 'package:teraflow/util/selfhelp_card.dart';
import 'package:teraflow/pages/searchpage.dart';

class SelfHelpPage extends StatelessWidget {
  const SelfHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage())),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      // appBar: AppBar(
      // backgroundColor: Colors.white,
      //elevation: 0,
      /* title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ), 
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const Searchpage()),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon:
                  Icon(Icons.notifications_none_outlined, color: Colors.black),
              onPressed: () {
                ////  Navigator.pushReplacement(
                // context,
                // MaterialPageRoute(builder: (context) => ProfileScreen()),
                //);
              },
            ),
          ], */

      body: SafeArea(
        child: Column(
          children: [
            // Popular Courses Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SelfHelp Catagories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See More'),
                  ),
                ],
              ),
            ),

            // Course List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  SelfhelpCard(
                    title: 'Stress Managment',
                    SelfhelpImagePath: 'lib/images/anger_control.png',
                    rating: 0,
                    iconColor: Colors.blue,
                  ),
                  SelfhelpCard(
                    title: 'Mindfulness & Meditation',
                    SelfhelpImagePath: 'lib/images/anger_control.png',
                    rating: 4,
                    iconColor: Colors.orange,
                  ),
                  SelfhelpCard(
                    title: 'Sleep Improvement',
                    SelfhelpImagePath: 'lib/images/meditation.png',
                    rating: 0,
                    iconColor: Colors.purple,
                  ),
                  SelfhelpCard(
                    title: 'Mood Boosting',
                    SelfhelpImagePath: 'lib/images/meditation.png',
                    rating: 0,
                    iconColor: Colors.green,
                  ),
                  SelfhelpCard(
                    title: 'Mood Boosting',
                    SelfhelpImagePath: 'lib/images/meditation.png',
                    rating: 0,
                    iconColor: Colors.brown,
                  ),
                  SelfhelpCard(
                    title: 'Mood Boosting',
                    SelfhelpImagePath: 'lib/images/midnfullcatagory.png',
                    rating: 0,
                    iconColor: Colors.indigo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
