import 'package:flutter/material.dart';
import 'package:teraflow/util/bookschedule_popup.dart';

class TherapistPortfolioPage extends StatelessWidget {
  final Map<String, dynamic> therapist;

  // List of categories for services
  final List<Map<String, String>> categories = [
    {"icon": "lib/images/person.png", "name": "Personal Therapy"},
    {"icon": "lib/images/family.png", "name": "Family Therapy"},
    {"icon": "lib/images/workers.png", "name": "Workplace Therapy"},
    {"icon": "lib/images/group.png", "name": "Group Therapy"},
    {"icon": "lib/images/couples.png", "name": "Couples Therapy"},
    {"icon": "lib/images/doctors.png", "name": "Specialized Therapy"},
  ];

  TherapistPortfolioPage({required this.therapist, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search and Notification Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.jpg'),
                      radius: 20,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search ...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.search,
                                color: Colors.deepPurple[200]),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.notifications,
                          color: Colors.deepPurple[200]),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.0),

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
                              therapist['image'] ?? 'assets/profile.jpg',
                            ),
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
                                therapistName: therapistName,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        child: Text(
                          'Book a Schedule',
                          style: TextStyle(color: Colors.white),
                        ),
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
              // SizedBox(height: 4),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:
                      1, // Square aspect ratio for each service tile
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
                  child: Text(
                    'Send Request',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 25.0),

              // Recent Blogs Section
              Text(
                'Recent Blogs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    blogCard('How to Manage Stress and Anxiety', 'Jan 1, 2025',
                        'Stress is a natural response to challenges, but when it becomes chronic, it can affect your physical and mental health. Learn techniques to manage stress effectively...'),
                    blogCard(
                        'Overcoming Fear: Tips for Personal Growth',
                        'Feb 15, 2025',
                        'Fear can hold us back, but it doesn’t have to. Discover strategies to face your fears and grow stronger from them...'),
                    blogCard(
                        'The Power of Therapy for Mental Health',
                        'Mar 10, 2025',
                        'Therapy is a powerful tool for managing mental health. It can help you work through difficult emotions and improve your overall well-being...'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to create testimonial cards with images
  Widget testimonialCard(
      String client, String comment, int rating, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Rating at the top
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: index < rating ? Colors.amber : Colors.grey[300],
                  size: 16.0,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Comment in the middle with max two sentences
            Text(
              comment,
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 2, // Limit the comment to two lines
              overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
            ),
            SizedBox(height: 10.0),
            // Profile picture and name at the bottom right
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(imagePath),
                    radius: 20, // Adjust the size of the profile picture
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    client,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to create service icons (square tiles with backgrounds)
  Widget serviceIcon(String iconPath, String title) {
    return Card(
      color: Colors.deepPurple[200], // Updated background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 60, height: 60),
            SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for blog cards
  Widget blogCard(String title, String date, String description) {
    return Container(
      width: 230, // Fixed width
      height: 150, // Set a fixed height
      child: Card(
        color: Colors.white, // Add a background color to the card
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Distribute space
            children: [
              // Title at the top
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              // Body description below the title
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                      color: Colors.black), // Lighten the text for description
                  maxLines: 3, // Limit the number of lines for description
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis if text overflows
                ),
              ),
              // Date aligned at the bottom right
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
}
