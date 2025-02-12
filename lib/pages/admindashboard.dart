import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Logout Button as Text on the right side of the app bar
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Column for Main Content
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    // Customer List Section
                    _buildSectionHeader('Customer List', Icons.person),
                    _buildScrollableContainer(
                      [
                        {'name': 'Customer 1', 'status': 'Active'},
                        {'name': 'Customer 2', 'status': 'Inactive'},
                        {'name': 'Customer 3', 'status': 'Active'},
                        {'name': 'Customer 4', 'status': 'Active'},
                        {'name': 'Customer 5', 'status': 'Inactive'},
                      ], // Sample list data
                      showVerifyButton: false, // No Verify button for customers
                    ),
                    const SizedBox(height: 80),
                    // Therapist Verification Section
                    _buildSectionHeader(
                        'Therapist Verification', Icons.check_circle),
                    _buildScrollableContainer(
                      [
                        {'name': 'Therapist 1', 'status': 'Under Review'},
                        {'name': 'Therapist 2', 'status': 'Verified'},
                        {'name': 'Therapist 3', 'status': 'Verified'},
                        {'name': 'Therapist 4', 'status': 'Under Review'},
                        {'name': 'Therapist 5', 'status': 'Verified'},
                      ], // Sample list data
                      showVerifyButton:
                          true, // Show Verify button for therapists
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Right Column for Pending Payments
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: [
                      _buildSectionHeader('Pending Payments', Icons.payment),
                      _buildScrollableContainer(
                        [
                          {
                            'name': 'Customer 1',
                            'amount': '50', // Amount in ETB
                            'status': 'Pending'
                          },
                          {
                            'name': 'Customer 2',
                            'amount': '30', // Amount in ETB
                            'status': 'Pending'
                          },
                          {
                            'name': 'Customer 3',
                            'amount': '75', // Amount in ETB
                            'status': 'Pending'
                          },
                          {
                            'name': 'Customer 4',
                            'amount': '20', // Amount in ETB
                            'status': 'Pending'
                          },
                          {
                            'name': 'Customer 5',
                            'amount': '40', // Amount in ETB
                            'status': 'Pending'
                          },
                        ], // Sample list data
                        showVerifyButton:
                            true, // Show Verify button for pending payments
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 30),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContainer(
    List<Map<String, String>> items, {
    required bool showVerifyButton,
  }) {
    return Container(
      height: 300, // Fixed height for the container to enable scrolling
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1), // Grey border
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5), // Shadow effect
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: items.map((item) {
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title:
                    Text(item['name']!, style: const TextStyle(fontSize: 18)),
                subtitle: Text(
                  item.containsKey('amount')
                      ? 'Amount: ${item['amount']} ETB' // Amount in ETB
                      : 'Status: ${item['status']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                trailing: showVerifyButton
                    ? ElevatedButton(
                        onPressed: () {
                          // TODO: Add logic to verify payments or therapists
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple),
                        child: const Text('Verify',
                            style: TextStyle(color: Colors.white)),
                      )
                    : null, // Verify button for pending payments
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
