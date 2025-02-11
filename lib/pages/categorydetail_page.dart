import 'package:flutter/material.dart';
import 'package:teraflow/pages/therapistprofile_page.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;
  final String iconPath;

  const CategoryDetailPage({
    required this.categoryName,
    required this.iconPath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          // Profile, search, and notification bar

          // Icon and category name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  iconPath,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 16.0),
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ListView
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 10, // Number of therapists
              itemBuilder: (context, index) {
                Map<String, dynamic> therapist = {
                  'name': 'Therapist ${index + 1}',
                  'image':
                      'assets/profile.jpg', // Replace with actual therapist images
                  'rating': 4.5,
                  'note':
                      'Therapist ${index + 1} has over 10 years of experience in family and personal therapy.',
                  'services': [
                    'Personal Counseling',
                    'Family Therapy',
                    'Group Therapy',
                    'Couples Therapy'
                  ],
                  'contact': 'therapist${index + 1}@email.com',
                };

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(therapist['image']!),
                      radius: 30,
                    ),
                    title: Text(
                      therapist['name']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              Icons.star,
                              color: starIndex < therapist['rating']!.toInt()
                                  ? Colors.amber
                                  : Colors.grey[300],
                              size: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "A Note from Therapist",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          therapist['note']!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepPurple[200],
                    ),
                    onTap: () {
                      // Pass the therapist data when navigating
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TherapistPortfolioPage(therapistEmail: 'therapist'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
