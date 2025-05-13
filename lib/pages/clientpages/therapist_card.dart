
import 'package:flutter/material.dart';
import 'package:teraflow/pages/clientpages/therapistprofile_page.dart';

class TherapistCard extends StatelessWidget {
  final String therapistImagePublicId;
  final String rating;
  final String therapistName;
  final String therapistProfession;
  final String experience;
  final VoidCallback onTap;

  const TherapistCard({
    Key? key,
    required this.therapistImagePublicId,
    required this.rating,
    required this.therapistName,
    required this.therapistProfession,
    required this.experience,
    required this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TherapistPortfolioPage(therapistEmail: 'therapist'),
                        ),
                      );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset('lib/resources/images/doctor1.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 120),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    therapistName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    therapistProfession,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        experience,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

