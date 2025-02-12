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
    // TODO: implement initState
    super.initState();
    fetchUsers();
    print(paymentrequests);
  }
  @override
  Widget build(BuildContext context) {
    
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
      itemCount: paymentrequests.length , // Replace with actual data length
      itemBuilder: (context, index) {
        // This is mock data. Replace with your actual data source
        

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
                          payment['doctoremail'] ?? "payment" ,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          payment['client:'] ?? "username",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "id",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Sessions', payment['sessions'].length.toString() ?? "sessions"),
                _buildInfoRow('Schedule', payment['sessions'][0].toString() ?? "scedule" ),
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
                    //if (payment['status'] == 'pending')
                    //  ElevatedButton(
                    //// onPressed: () {
                    // Handle payment
                    // },
                    // child: const Text('Pay Now'),
                    //  ),
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
