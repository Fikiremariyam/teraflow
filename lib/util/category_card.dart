import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String iconImagePath;
  final String categoryName;

  CategoryCard({
    required this.iconImagePath,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Container(
        width: 120, // Increase width for a larger circular container
        height: 120, // Increase height to maintain the circular shape
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          borderRadius: BorderRadius.circular(12), // Keep rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400, // Shadow color
              offset: Offset(2, 4), // Shadow position (X, Y)
              blurRadius: 6, // Blur intensity
              spreadRadius: 1, // Spread of the shadow
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Increased icon size
              Image.asset(
                iconImagePath,
                height: 60, // Increase icon size to 60
                fit: BoxFit.contain, // Ensure the icon fits well
              ),
              SizedBox(
                height: 8,
              ),
              // Increased font size
              Text(
                categoryName,
                style: TextStyle(
                  fontSize: 14, // Adjust font size for better readability
                ),
                textAlign: TextAlign.center, // Center align text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
