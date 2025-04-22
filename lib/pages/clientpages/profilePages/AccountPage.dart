import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:firebase_auth/firebase_auth.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  _AccountInformationScreenState createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  bool isEditing = false;
  final Map<String, TextEditingController> controllers = {
    'Email': TextEditingController(text: 'Fikerbsu@gmai.com'),
    'Gender': TextEditingController(text: 'Female'),
    'First Name': TextEditingController(text: 'Meroncvcvcvvc'),
    'Last Name': TextEditingController(text: 'Bahru'),
    'Date of Birth': TextEditingController(text: 'Nov 23, 2000'),
    'Phone Number': TextEditingController(text: '+251984153951'),
    
    'Country': TextEditingController(text: '-'),
    'Address': TextEditingController(text: '-'),
  };
  // to get user data
  void getusercred() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    var userData= docSnapshot.data();
    print(userData);
    
    setState(() {
      controllers['Email']!.text=userData?['email'] ??"  email unavalible ";
      controllers['Gender']!.text=userData?['Gender'] ??" gender unavalible";
      controllers['First Name']!.text=userData?['First Name'] ??"full name unavalible ";
      controllers['Last Name']!.text=userData?['Last Name'] ??"Last Name unavalible";
      controllers['Date of Birth']!.text=userData?['Date of Birth'].toString().split("T")[0] ??" unavalible date of birth ";
      controllers['Phone Number']!.text=userData?['Phone Number'] ??"phone unavalible ";
      controllers['Country']!.text=userData?['Country'] ??"country ";
      controllers['Address']!.text=userData?['Address'] ??"address ";
    
    });
  }
 // to set user Data 
 void setUsercred() async{
    try {
    await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .update({
          'email': controllers['Email']!.text,
          'Gender':controllers['Gender']!.text,
          'First Name': controllers['First Name']!.text,
          'Last Name': controllers['Last Name']!.text,
          'Date of Birth': controllers['Date of Birth']!.text,
          'Phone Number':controllers['Phone Number']!.text,
          'Country':controllers['Country']!.text,
          'Address':controllers['Address']!.text
        });
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );}catch(e){
          print(e);
        }
          setState(() {
                        isEditing = !isEditing;
                                getusercred();
                      });
  
 }
  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
@override 
void initState(){
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Information',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          isEditing ?  
          IconButton(
            icon: Icon( Icons.save,
                color: Colors.deepPurple),
                onPressed: () =>{
                          setUsercred()
            },
          ):IconButton(
            icon: Icon( Icons.edit,
                color: Colors.deepPurple),
            onPressed: () =>{
            setState(() {
                          isEditing = !isEditing;
                        })
            },),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Personal Info.', [
              _buildTwoColumnInfoRow('First Name', 'Last Name'),
              _buildTwoColumnInfoRow('Email', 'Gender',),
              _buildTwoColumnInfoRow('Date of Birth', ''),
            ]),
            const SizedBox(height: 24),
            _buildSection('Contact Info.', [
              _buildTwoColumnInfoRow('Phone Number', 'Email'),
              _buildTwoColumnInfoRow('Country', 'Address'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTwoColumnInfoRow(String label1, String label2,
      {bool isEditable = true}) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoRow(label1, isEditable: isEditable)),
              if (label2.isNotEmpty) const SizedBox(width: 16),
              if (label2.isNotEmpty)
        Expanded(
          child: _buildInfoRow(label2, isEditable: isEditable)),
      ],
    );
  }

  Widget _buildInfoRow(String label, {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          isEditing && isEditable
              ? TextField(
                  controller: controllers[label],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                )
              : Text(
                  controllers[label]!.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }
}
