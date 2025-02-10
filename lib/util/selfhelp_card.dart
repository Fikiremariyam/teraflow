import 'package:flutter/material.dart';
import 'package:teraflow/pages/SELFHELP/ResourceListPage.dart';

class SelfhelpCard extends StatelessWidget {
  final String SelfhelpImagePath;
  final String title;
  final int rating;
  final Color iconColor;

  const SelfhelpCard({
    super.key,
    required this.title,
    required this.SelfhelpImagePath,
    required this.rating,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Course Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                SelfhelpImagePath,
                height: 40,
              ),
            ),
            const SizedBox(width: 16),

            // Course Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Join Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResourceListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple[300],
              ),
            ),
          ],
        ),
      ),
    );
    ResourceListPage();
  }
}
