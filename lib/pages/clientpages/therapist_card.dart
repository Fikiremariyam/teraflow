import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:teraflow/pages/therapistPages/therapistprofile_page.dart';

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

  Widget _profilePic() {
    final cloudinary = Cloudinary.fromCloudName(cloudName: "dd8qfpth2");

    return CldImageWidget(
      cloudinary: cloudinary,
      publicId: therapistImagePublicId,
      width: 100,
      height: 150,
      fit: BoxFit.cover,
    );
  }

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
              child: _profilePic(),
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

