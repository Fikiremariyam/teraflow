import 'package:flutter/material.dart';
import 'package:teraflow/pages/category_page.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Welcome to the Calendar Page!',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to CategoryPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage()),
                );
              },
              child: Text("Book a Session"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


