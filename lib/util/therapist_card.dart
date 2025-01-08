import 'package:flutter/material.dart';

class TherapistCard extends StatelessWidget {
  final String therapistImagePath;
  final String rating;
  final String therapistName;
  final String therapistProfession;

  TherapistCard({
    required this.therapistImagePath,
    required this.rating,
    required this.therapistName,
    required this.therapistProfession,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                therapistImagePath,
                height: 50,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: const Color.fromARGB(255, 252, 214, 46),
                ),
                Text(
                  rating,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              therapistName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text('$therapistProfession  5 y.e.'),
          ],
        ),
      ),
    );
  }
}
