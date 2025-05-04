import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teraflow/pages/clientpages/home_page.dart';
import 'package:teraflow/pages/clientpages/profilePages/ProfilePage.dart';

class CustomerPaymentPage extends StatefulWidget {
  const CustomerPaymentPage({Key? key}) : super(key: key);

  @override
  State<CustomerPaymentPage> createState() => _CustomerPaymentPageState();
}

class _CustomerPaymentPageState extends State<CustomerPaymentPage> {

    List<Map<String, dynamic>> paymentrequests= [];
    File? attachedImage;

     void fetchPayment() async {
      
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('paymentrequest')
              .where('client', isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .get();

          List<Map<String, dynamic>> filteredRequests = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
         //     .where((payment) => payment['status'] != "pending")
              .toList();


          setState(() { 
            paymentrequests = filteredRequests;
          });
          const abebe = 0;
  }

// the list of payment requests 
  Widget _buildPaymentsList(BuildContext context) {
    // This is mock data. Replace with your actual data source
    if (paymentrequests.length <1){
      return Center(
        child: Text(
          "this account has not payment history"
        ),
        
      );
    }
    return 
    ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: paymentrequests.length,
      itemBuilder: (context, index) {
        final payment = paymentrequests[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.grey[100],
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
                          payment['doctoremail'] ?? "doctor",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          payment['client']?? "client ",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(payment['status']),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        payment['status'] ?? " none",
                        style: TextStyle(
                          color: _getStatusTextColor(payment['status']?? "none"),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('ID', payment['id'] ?? "id"),
                _buildInfoRow('Sessions', payment['sessions'].length.toString() ?? "0"),
                 _buildInfoRowContainer ('Schedule', payment['sessions'] ?? [] ),
                 _buildInfoRow('Amount', payment['amount'] ?? "amount"),
                const SizedBox(height: 8),
                Text(
                  'Description:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  payment['description'] ?? "for sessions ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                if (payment['status'] == 'created')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>_showPaymentLinkDialog(context, payment),
                        child: const Text('Pay Now'),
                      ),
                      ElevatedButton(
                        onPressed: () { 
                          _showCompletePaymentDialog(context, payment);
                        
                        },
                        child: const Text('Complete Payment'),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow[50]!;
      case 'completed':
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
      case 'completed':
        return Colors.green[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

void _submitandstore(payment) async {
  print('Submit button pressed');

    try {
      String time = payment['scedule'].text.trim();
      String email = payment[''].text.trim();

      firebase_auth.User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FormatException("No user is logged in.");
      }
      String therapistEmail = user.email!;

      String dateTimeString ="${payment['dateandtime']!.toIso8601String().split("T")[0]} ${payment['time'].text.trim()}";
      DateTime appointmentDateTime =DateFormat("yyyy-MM-dd hh:mm a").parse(dateTimeString, true).toUtc();

      Map<String, dynamic> appointmentData = {
        "customerEmail": payment['custmor'],
        "appointmentDateTime": appointmentDateTime,
        "therapistEmail": payment['appointmentDateTime'],
      };

      await FirebaseFirestore.instance
          .collection('verfiedappointments')
          .add(appointmentData);


      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointment added successfully!")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showPaymentLinkDialog(BuildContext context, Map<String, dynamic> payment) {
    final paymentLink = 'https://example.com/pay/${payment['id'] ?? "none"}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: const Text('Payment Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            _buildInfoRow('ID', payment['id'] ?? "id"),
                _buildInfoRow('Sessions', payment['sessions'].length.toString() ?? "sitejennan"),
                _buildInfoRow('Schedule', payment['sessions'].toString() ?? "dscsdcsdvvs"),
                 _buildInfoRow('Amount', payment['amount'] ?? "asdvfsdvd"),
                const SizedBox(height: 16),
                const Text('Payment Link:'),
                const SizedBox(height: 8),
                Text(paymentLink,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: paymentLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Payment link copied to clipboard')),
                    );
                  },
                  child: const Text('Copy Link'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// complete payment pop up dialog
  void _showCompletePaymentDialog(
      BuildContext context, Map<String, dynamic> payment) {
        print("payment id is ${payment}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return  AlertDialog(
              backgroundColor: Colors.grey[100],
              title: const Text('Complete Payment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('ID', payment['id'] ?? "id"),
                    _buildInfoRow('Sessions', payment['sessions'].length.toString() ?? "sitejennan"),
                    _buildInfoRow('Schedule', payment['sessions'].toString() ?? "dscsdcsdvvs"),
                     _buildInfoRow('Amount', payment['amount'] ?? "asdvfsdvd"),
                    const SizedBox(height: 16),
                    
                    attachedImage == null  ? 
                      const Text('Please attach a screenshot of your payment:'):
                      const Text("file selected successfully ") ,
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image =
                            await _picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                         
                          // Handle the selected image
                          setDialogState(() {
                            attachedImage = File(image.path);
                          });
                          
                        }
                      },
                      child: const Text('Attach Screenshot'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () async{
                    if (attachedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please attach a screenshot')),
                      );
                      return;
                    }
                    // create an attachment picture link to the payment request INSTANCE 
                    await Supabase.instance.client.storage
                        .from('teraflowrecipts')
                        .upload(payment['paymentLink'] ?? "id" , attachedImage!).then((onValue) async {
                    
                     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('paymentrequest')
                      .where('paymentLink', isEqualTo: payment['paymentLink'])
                      .limit(1) // Limit to one document
                      .get();

                     if (querySnapshot.docs.isNotEmpty) {
                     await querySnapshot.docs.first.reference.update({
                       'status': 'pending',
                     });
                     }

                        });
                    // and update the payment request status to 'PENDING '
                    
                    Navigator.of(context).pop();
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                  },
                ),
              ],
            );
          },
        );
      },
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPayment();
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
          'Payment',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildPaymentsList(context),
          ),
        ],
      ),
    );
  }
}
