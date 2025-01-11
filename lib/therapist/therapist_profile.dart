import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class TherapistProfile extends StatefulWidget {
  final Function(File, String, String) onProfileInfoChanged;

  TherapistProfile({required this.onProfileInfoChanged});

  @override
  _TherapistProfileState createState() => _TherapistProfileState();
}

class _TherapistProfileState extends State<TherapistProfile> {
  File? _profileImage;
  File? _cvFile;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Example initial values
    _nameController.text = "Dr. Aman Moges";
    _emailController.text = "Amanmo@gmail.com";
    _phoneController.text = "+251 912 345 678";
    _addressController.text = "Addis Ababa, Ethiopia";
  }

  // Method to pick an image for the profile
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Method to pick a CV file
  Future<void> _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _cvFile = File(result.files.single.path!);
      });
    }
  }

  // Save Profile Information
  void _saveProfile() {
    widget.onProfileInfoChanged(
      _profileImage ?? File(''), // Ensure no null value
      _nameController.text,
      _emailController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('lib/images/doctor1.jpg') as ImageProvider,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Change Profile Picture'),
                ),
              ),
              SizedBox(height: 20),

              // Editable Fields
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // CV Upload Section
              Text(
                'Upload Your CV:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickCV,
                icon: Icon(Icons.upload_file),
                label: Text('Upload CV'),
              ),
              if (_cvFile != null) ...[
                SizedBox(height: 10),
                Text(
                  'CV Uploaded: ${_cvFile!.path.split('/').last}',
                  style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 3, 28, 99)),
                ),
              ],

              SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'Save Profile',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
