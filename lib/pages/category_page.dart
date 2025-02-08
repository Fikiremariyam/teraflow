import 'package:flutter/material.dart';
import 'package:teraflow/pages/categorydetail_page.dart';
import 'package:teraflow/util/category_card.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"icon": "lib/images/person.png", "name": "Personal Therapy"},
    {"icon": "lib/images/family.png", "name": "Family Therapy"},
    {"icon": "lib/images/workers.png", "name": "Workplace Therapy"},
    {"icon": "lib/images/group.png", "name": "Group Therapy"},
    {"icon": "lib/images/couples.png", "name": "Couples Therapy"},
    {"icon": "lib/images/doctors.png", "name": "Specialized Therapy"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        
        title: Center (
          child: Text("Booking page "))
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/category.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Book a Session',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailPage(
                            categoryName: category["name"]!,
                            iconPath: category["icon"]!,
                          ),
                        ),
                      );
                    },
                    child: CategoryCard(
                      iconImagePath: category["icon"]!,
                      categoryName: category["name"]!,
                    ),
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
