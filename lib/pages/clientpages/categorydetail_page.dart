import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:teraflow/pages/therapistPages/therapistprofile_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final String iconPath;

  const CategoryDetailPage({
    required this.categoryName,
    required this.iconPath,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  List<Map<String, dynamic>>? users;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    print("+++++++++++++++++++++++++++++");
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: "Therapist")
        .get();

    List<Map<String, dynamic>> usersData = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    print(usersData);
    print(widget.categoryName);

    setState(() {
      users = usersData;
    });
  }
 
  Widget _profilePic() {
    final cloudinary = Cloudinary.fromCloudName(cloudName: "dd8qfpth2");

    return ClipOval(
      child: CldImageWidget(
        cloudinary: cloudinary,
        publicId: "cld-sample-4",
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }
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
                  widget.iconPath,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.categoryName,
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
            child: users == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: users!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> therapist = users![index];
                      print(therapist);
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading:_profilePic(),

                          title: Text(
                            therapist['fullName'] ?? 'name ',
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
                                    color: starIndex < (double.tryParse(therapist['rating'].toString())?.toInt() ?? 0)
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
                                therapist['note'] ?? 'note abcd',
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
                                builder: (context) => TherapistPortfolioPage(
                                  therapistEmail: therapist['email'] ?? 'email',
                                ),
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

