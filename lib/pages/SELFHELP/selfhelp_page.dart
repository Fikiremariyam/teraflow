import 'package:flutter/material.dart';
import 'package:teraflow/util/selfhelp_card.dart';

class SelfHelpPage extends StatelessWidget {
  const SelfHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: Colors.white,
        scaffoldBackgroundColor: Colors.deepPurple[50],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
