import 'package:flutter/material.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  _AccountInformationScreenState createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  bool isEditing = false;
  final Map<String, TextEditingController> controllers = {
    'TeraFlow ID': TextEditingController(text: 'ETPT002376'),
    'Gender': TextEditingController(text: 'Female'),
    'First Name': TextEditingController(text: 'Meron'),
    'Last Name': TextEditingController(text: 'Bahru'),
    'Date of Birth': TextEditingController(text: 'Nov 23, 2000'),
    'Phone Number': TextEditingController(text: '+251984153951'),
    'Email': TextEditingController(text: '-'),
    'Country': TextEditingController(text: '-'),
    'Address': TextEditingController(text: '-'),
  };

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
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
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit,
                color: Colors.deepPurple),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Personal Info.', [
              _buildTwoColumnInfoRow('TeraFlow ID', 'Gender',
                  isEditable: false),
              _buildTwoColumnInfoRow('First Name', 'Last Name'),
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
        Expanded(child: _buildInfoRow(label1, isEditable: isEditable)),
        if (label2.isNotEmpty) const SizedBox(width: 16),
        if (label2.isNotEmpty)
          Expanded(child: _buildInfoRow(label2, isEditable: isEditable)),
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
