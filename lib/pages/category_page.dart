import 'package:flutter/material.dart';
import 'package:teraflow/util/category_card.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"icon": "lib/images/person.png", "name": "Personal Therapy"},
    {"icon": "lib/images/family.png", "name": "Family Therapy"},
    {"icon": "lib/images/workers.png", "name": "Workplace Therapy"},
    {"icon": "lib/images/group.png", "name": "Group Therapy"},
    {"icon": "lib/images/couples.png", "name": "Couples Therapy"},
    {"icon": "lib/images/doctors.png", "name": "Specialized Therapy"},
  ]; // Replace with your actual icon paths and category names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/profile.jpg'), // Profile image
              radius: 20,
            ),
            SizedBox(width: 8.0),

            // Search Bar with User-Friendly Design
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Colors.grey[200], // Light background for the search bar
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0, 2),
                    ),
                  ], // Add shadow for a slight elevation effect
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'search ...',
                    hintStyle:
                        TextStyle(color: Colors.grey[600]), // Grey hint text
                    prefixIcon: Icon(
                      Icons.search,
                      color:
                          Colors.deepPurple[200], // Match icon color with theme
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    border: InputBorder.none, // Remove default border
                    focusedBorder: InputBorder.none, // Remove focus border
                    enabledBorder: InputBorder.none, // Remove enabled border
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),

            // Notification Icon
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.deepPurple[200],
              ),
              onPressed: () {
                // Handle notifications click
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Full-width Rectangular Image Container
            GestureDetector(
              onTap: () {
                // Handle image addition
              },
              child: Container(
                height: 200, // Height remains the same
                width: MediaQuery.of(context).size.width, // Full screen width
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'lib/images/category.png'), // Replace with your image path
                    fit: BoxFit.cover, // Ensures the image covers the container
                  ),
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 8),

            // "Book a Session" Text with Deep Blue Background
            Container(
              width: MediaQuery.of(context).size.width, // Full width
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple[200], // Deep blue shade 200
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Center(
                child: Text(
                  'Book a Session',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white, // White text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width, // Full screen width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/sample_image.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Category Cards in Grid Format
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:
                      1.2, // Decrease the height of category cards
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    iconImagePath: category["icon"]!,
                    categoryName: category["name"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
