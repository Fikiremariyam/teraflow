import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teraflow/pages/home_page.dart';
import 'package:teraflow/pages/payment_and_orders.dart';
import 'package:teraflow/pages/splashPage/SettingPage.dart';
import '../splashPage/AccountPage.dart';

class ProfileScreen extends StatefulWidget {
  
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

    var username = TextEditingController();
    var phonenumber = TextEditingController();

    // getting profile pic 
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
  

    // to get user data
    void getusercred() async {

    var docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    String usernameholder = docSnapshot.data()?['username'] ?? 'Meron ';
    String phoneno =
        docSnapshot.data()?['phonenumber'] ?? 'enter your  phone  no';
    setState(() {
      username.text = usernameholder;
      phonenumber.text = phoneno;
    });
  }


  @override
  void initState() {
    //function to run then ever the page is loaded
    super.initState();
    getusercred();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage())),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                   CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child:  _profilePic() ?? Icon(Icons.person_outline,
                        color: Colors.grey, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    username.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'General',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildMenuItem(
              icon: Icons.person_outline,
              iconColor: Colors.blue,
              title: 'Account Information',
              subtitle: 'Change your account information',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountInformationScreen()),
              ),
            ),
            /*     _buildMenuItem(
              icon: Icons.favorite_outline,
              iconColor: Colors.orange,
              title: 'My Medical Records',
              subtitle: 'History about your medical records',
            ),*/
            _buildMenuItem(
              icon: Icons.bookmark_outline,
              iconColor: Colors.red,
              title: 'Bookmarks',
              subtitle: 'Your bookmarked article and product',
             
            ),
            _buildMenuItem(
              icon: Icons.payment_outlined,
              iconColor: Colors.purple,
              title: 'Order & Payment History',
              subtitle: 'See your payment info',
               onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  PaymentAndOrders()),
              ),
            ),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              iconColor: Colors.blue[900]!,
              title: 'Settings',
              subtitle: 'Manage account settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
