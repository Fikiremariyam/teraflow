import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teraflow/util/bookschedule_popup.dart';

class TherapistPortfolioPage extends StatelessWidget {
  List<dynamic> _department = [];
  Map<String, dynamic> therapist = {};

  // Fetching user data
  Future<Map<String, String>> getuserdata(email) async {
    String? userEmail = email;

    if (userEmail == null) {
      print("No logged-in user");
      return {};
    }

    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    if (user.exists && user.data() != null) {
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value.toString()));
    }
    return {};
  }

  final String therapistEmail;

  // List of categories for services
  final List<Map<String, String>> categories = [
    {"icon": "lib/images/person.png", "name": "Personal Therapy"},
    {"icon": "lib/images/family.png", "name": "Family Therapy"},
    {"icon": "lib/images/workers.png", "name": "Workplace Therapy"},
    {"icon": "lib/images/group.png", "name": "Group Therapy"},
    {"icon": "lib/images/couples.png", "name": "Couples Therapy"},
    {"icon": "lib/images/doctors.png", "name": "Specialized Therapy"},
  ];

  TherapistPortfolioPage({required this.therapistEmail, Key? key})
      : super(key: key);

  void populateuserData() async {
    therapist = await getuserdata(therapistEmail);
  }

  @override
  Widget build(BuildContext context) {
    populateuserData();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search and Notification Bar
             
              SizedBox(height: 50.0),

              // Profile Section (with minimized profile pic and rearranged details)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 221, 182, 138),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    // Stack for overlapping profile picture on top-left of the white container
                    Stack(
                      children: [
                        // White Container with Name, Rating, and Note
                        Container(
                          margin: EdgeInsets.only(
                              left:
                                  20), // Shift the white container to the left by 20
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Name and Rating
                              Text(
                                therapist['name'] ?? 'No Name Available',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              // Rating (Centered)
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      color: index < (therapist['rating'] ?? 0)
                                          ? Colors.amber
                                          : Colors.grey[300],
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              // Therapist Note
                              Text(
                                therapist['note'] ??
                                    'No note available for this therapist',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        // Profile Picture overlapping on top-left of the white container
                        Positioned(
                          left:
                              10, // Negative value to make the profile picture overlap on the left side
                          top: -2, // Negative value for overlap effect
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                therapist['image'] ?? 'assets/profile.jpg'),
                            radius: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    // Book a Schedule Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          String therapistName =
                              therapist['name'] ?? 'Therapist Name';
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BookschedulePopup(
                                  therapistName: therapistName, doctorsemail: therapistEmail,);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        child: Text('Book a Schedule',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.0),

              // Testimonials Section
              Text(
                'Testimonials',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    testimonialCard('Client 1', 'Excellent service!', 5,
                        'assets/client1.jpg'),
                    testimonialCard('Client 2', 'Great experience!', 4,
                        'assets/client2.jpg'),
                    testimonialCard(
                        'Client 3', 'Very helpful!', 5, 'assets/client3.jpg'),
                    testimonialCard('Client 4', 'Life-changing support!', 5,
                        'assets/client4.jpg'),
                  ],
                ),
              ),
              SizedBox(height: 30.0),

              // Services Section (Square tiles)
              Text(
                'Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return serviceIcon(categories[index]['icon'] ?? '',
                      categories[index]['name'] ?? '');
                },
              ),
              SizedBox(height: 24.0),

              // Send Request Button
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Send Request',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 25.0),

              // Recent Blogs Section
              Text(
                'Recent Blogs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),

              // Fetch and display blogs using FutureBuilder
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchBlogs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('This therapist hasn\'t written anything yet.');
                  }

                  // If data is available, display blogs
                  List<Map<String, dynamic>> blogs = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blogs.map((blog) {
                        return blogCard(
                          blog['title'] ?? 'No Title',
                          blog['timestamp'] ?? 'No Date',
                          blog['content'] ?? 'No Content',
                          blog['author'] ?? 'Unknown Author',
                          blog['category'] ?? 'No Category',
                          blog['likes'] ?? 0,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch blogs from Firestore
  Future<List<Map<String, dynamic>>> fetchBlogs() async {
    try {
      QuerySnapshot blogSnapshot = await FirebaseFirestore.instance
          .collection('blogs') // Replace with your collection name
          .where('authorId',
              isEqualTo:
                  therapistEmail) // Fetch blogs written by this therapist
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> blogs = blogSnapshot.docs.map((doc) {
        return {
          'author': doc['author'],
          'authorId': doc['authorId'],
          'category': doc['category'],
          'content': doc['content'],
          'likes': doc['likes'],
          'timestamp': doc['timestamp'].toDate().toString(),
          'title': doc['title'],
        };
      }).toList();
      return blogs;
    } catch (e) {
      print("Error fetching blogs: $e");
      return [];
    }
  }

  // Helper widget for blog cards
  Widget blogCard(String title, String date, String description, String author,
      String category, int likes) {
    return Container(
      width: 230,
      height: 180,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(color: Colors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'By $author',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    '$category | $likes Likes',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  date,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for testimonial cards
  Widget testimonialCard(
      String clientName, String testimonial, int rating, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: 8.0),
            Text(
              clientName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(testimonial),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                rating,
                (index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for service icons
  Widget serviceIcon(String iconPath, String serviceName) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: 50.0,
              height: 50.0,
            ),
            SizedBox(height: 8.0),
            Text(
              serviceName,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
