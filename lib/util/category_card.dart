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
        width: 100, // Adjust width to ensure circular shape
        height: 100, // Adjust height to ensure circular shape
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          borderRadius: BorderRadius.circular(
              12), // Half of the width/height for circular shape
        ),
        child: Center(
          // Center the content inside the container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                iconImagePath,
                height: 40,
                fit: BoxFit
                    .contain, // Ensure the icon is contained inside the circle
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                categoryName,
                style: TextStyle(fontSize: 12), // Adjust font size as needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
