import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class TherapistProfile extends StatefulWidget {
  @override
  _TherapistProfileState createState() => _TherapistProfileState();
}

class _TherapistProfileState extends State<TherapistProfile> {
  XFile? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurple.shade50,
                      backgroundImage: _profileImage != null
                          ? FileImage(File(_profileImage!.path))
                          : AssetImage('assets/profile_placeholder.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: -6,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ProfileField(
                label: "Name",
                hint: "Enter your name",
                icon: Icons.person,
                controller: _nameController,
              ),
              ProfileField(
                label: "Email",
                hint: "Enter your email",
                icon: Icons.email,
                controller: _emailController,
              ),
              SizedBox(height: 10),
              Text(
                "Upload CV",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Add functionality to upload CV
                },
                icon: Icon(Icons.upload_file),
                label: Text("Upload"),
              ),
              SizedBox(height: 20),
              Text(
                "Experience",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              ProfileField(
                label: "Years of Experience",
                hint: "Enter your experience",
                icon: Icons.timeline,
                controller: _experienceController,
              ),
              ProfileField(
                label: "Specialization",
                hint: "Enter your specialization",
                icon: Icons.star,
                controller: _specializationController,
              ),
              SizedBox(height: 20),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  // Navigate to settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.support_agent),
                title: Text("Contact Support"),
                onTap: () {
                  // Navigate to contact support page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller; // Make it nullable

  const ProfileField({
    required this.label,
    required this.hint,
    required this.icon,
    this.controller, // Make this nullable so we can pass null
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.deepPurple[700],
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller, // Use the controller here
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
