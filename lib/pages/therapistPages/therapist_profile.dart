import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:teraflow/resources/components/ListButton.dart';
import 'package:teraflow/resources/components/my_button.dart';

class TherapistProfile extends StatefulWidget {
  final Function(File, String) onProfileInfoChanged;

  TherapistProfile({required this.onProfileInfoChanged});

  @override
  _TherapistProfileState createState() => _TherapistProfileState();
}

class _TherapistProfileState extends State<TherapistProfile> {
  bool background_bool =false;
  final FocusNode _backgroundFocusNode = FocusNode();
  File? _profileImage;
  File? _cvFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _backgroundController = TextEditingController();

  
  List<dynamic> _department = [];
  Map<String, dynamic> userdata = {};

  // Fetch user credentials
  Future<Map<String, String>> getuserdata() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) {
      print("No logged-in user");
      return {};
    }

    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    if (user.exists && user.data() != null) {
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value.toString()));
    }
    return {};
  }
  //rounded button widgets 
   Widget _buildTag(String label, {bool isSelected = false}) {
    return ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 200),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 124, 53, 217),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ],
    ),
  ),
);
   
   }


  void populateuserDAta() async {
    userdata = await getuserdata();
    setState(() {
      _nameController.text = userdata['fullName'] ?? "no name";
      _phoneController.text = userdata['phone'] ?? "no phone";
      _addressController.text = userdata['address'] ?? "no address"; 
      _titleController.text = userdata['title'] ?? "no title";
      _backgroundController.text=userdata['background'] ??  " no background"; 
      _department= userdata['department'].replaceAll(RegExp(r'[\[\]]'), '')  // Remove brackets
      .split(',')                        // Split by comma
      .map((item) => item.trim())        // Remove extra spaces
      .toList();
    });
    print( userdata['department']);
  }


  @override
  void initState() {

    super.initState();
    populateuserDAta();
  }
   Widget itemTextField(controller, label){

       return TextField(
                  controller: controller,
                  //onChanged: (){},
                  decoration: InputDecoration(
                    
                    labelText:label ,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    
                    suffixIcon:IconButton(
                            icon: Icon(Icons.edit, color: const Color.fromARGB(255, 124, 53, 217)),
                            onPressed: (){}),
        
                       
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color.fromARGB(255, 124, 53, 217), width: 2.0),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                );
              
   }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

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

  void _saveProfile()async {
    
    
    await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .update({
          'fullName': _nameController.text,
          'title':_titleController.text,
          'phone': _phoneController.text,
          'gendear': "F",
          'address': _addressController.text,
          'background':_backgroundController.text,
          'department': ["Personal Therapy", "Family Therapy", "Workplace Therapy", "Group Therapy", "Couples Therapy", "Specialized Therapy"],
          'check':'check'
        });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) { 

    


    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        //profile pic 
                       CircleAvatar(
                        radius: 50,
                        child: ClipOval( // Ensure the image is clipped to a circle
                          child: Image.file(
                            _profileImage ?? File(""),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),	
                       
                          
                        ),
                      ),
                        // editing profile pic
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 124, 53, 217),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    //name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _nameController.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        //verification icon
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ],
                    ),
                    //adress
                    Text(
                      _addressController.text,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 124, 53, 217),
                      ),
                    ),
                 
                    // Profile description
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title 
                          TextField(
                            decoration: InputDecoration(
                              
                            border: InputBorder.none
                            ),
                           controller: _titleController,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          //background
                          TextField(
                            focusNode: _backgroundFocusNode,
                            enabled: background_bool,
                            controller: _backgroundController,
                            style: TextStyle(color: Colors.grey[600]),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),

                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                background_bool=true;
                              });
                                  Future.delayed(Duration(milliseconds: 100), () {
                                    _backgroundFocusNode.requestFocus();
                        });
                            },
                            child: Icon(Icons.edit,color: const Color.fromARGB(255, 124, 53, 217),),

                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Play video button
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.play_circle_outline),
                      label: Text('Play Video',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 124, 53, 217),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                        ],
                      ),
                    ),
           SizedBox(height: 20),
           itemTextField(_nameController,"user name"),
            SizedBox(height: 10,),
            itemTextField(_phoneController, "phone number"),
            SizedBox(height: 10),
            itemTextField(_addressController, "Address"),
            SizedBox(height: 20),
            Text("skills"),
            SizedBox(
              height: 100,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  mainAxisExtent: 40,
                ),
                itemCount: _department.length,
                itemBuilder: (rcontext, index) {
                  return _buildTag(_department[index],isSelected: true);
                },
              ),
            ),

              SizedBox(height: 20),
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
                    color: Color.fromARGB(255, 3, 28, 99),
                  ),
                ),
              ],
              SizedBox(height: 20),
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