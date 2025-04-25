import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FinancePage extends StatefulWidget {
 FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {

    List<Map<String, dynamic>> paymentrequests= [];

    void fetchUsers() async {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('paymentrequest')
              .where('doctoremail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .get();

          List<Map<String, dynamic>> paumentrequestlist = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();


          setState(() {
            paymentrequests = paumentrequestlist;
          });
  }
 
  

  final mockData = [
          {
            'name': 'Dr. Sarah Wilson',
            'username': '@drsarah',
            'id': '#TH-2245',
            'sessions': '4 sessions',
            'schedule': 'Feb 15, 2:00 PM',
            'amount': '\$400.00',
            'status': 'pending'
          },
        ];

  @override
  void initState() {
    
    super.initState();
    fetchUsers();
    print(paymentrequests);
  }
  @override
  Widget build(BuildContext context) {
    print(paymentrequests);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _buildPaymentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsList() {
    
    if (paymentrequests.length <=0){
      return Center(
        child: Text("no payment history"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: paymentrequests.length , 
      itemBuilder: (context, index) {

        final payment = paymentrequests[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment['client'] ?? "Name not found " ,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Sessions', payment['sessions'].length.toString() ?? "sessions"),
                _buildInfoRowContainer ('Schedule', payment['sessions'] ?? [] ),
                _buildInfoRow('Amount', payment['amount'] ?? "scedule "),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(payment['status'] ?? "status"),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        payment['status'] ?? "status ".toUpperCase(),
                        style: TextStyle(
                          color: _getStatusTextColor(payment['status'] ?? "status"),
                          fontSize: 12,
                        ),
                      ),
                    ),
          
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowContainer(String label, List  sessions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
            Container(
              //color: const Color.fromARGB(111, 117, 113, 113), // Set the background color here
              padding: const EdgeInsets.all(8), // Optional: Add padding
              alignment: Alignment.center, // Center the child text
              width: double.infinity, // Take the available width
              child: Text(
                      label,
                      style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      ),
              ),
            ),
            SizedBox(
            height: 120,
            child: ListView.builder(
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.horizontal,
            itemCount: sessions.length,
            itemBuilder: (context, index) {
                return DecoratedBox(
                        decoration: BoxDecoration(
                        color: Colors.blue[50], // Background color
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                sessions[index]['date'],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                sessions[index]['time'],
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      );
                },
            ),
          )

       ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow[50]!;
      case 'paid':
        return Colors.green[50]!;
      case 'cancelled':
        return Colors.red[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow[700]!;
      case 'paid':
        return Colors.green[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
