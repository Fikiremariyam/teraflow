import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:teraflow/pages/clientpages/home_page.dart';
import 'package:teraflow/features/services/api_service.dart';

import 'package:teraflow/pages/therapistPages/finance_page.dart';
import 'package:teraflow/pages/therapistPages/home_therapist.dart';

class PaymentPage extends StatefulWidget {
  List<Map<String, dynamic>> appointmentlist;
  final String? email;
  final String? totalAmount;

  PaymentPage({this.email, this.totalAmount, required this.appointmentlist});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String? paymentLink;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the email and total amount with default values if null
    emailController.text = widget.email ?? "";
    amountController.text = widget.totalAmount ?? "";
    
  }
  void createpaymentrequest(doctoremail,clientemail,amount,sessions,paymentLink) async{
   
    List<Map<String, dynamic>> formattedSessions = widget.appointmentlist.map((appointment) {
  return {
    'date': DateFormat('yyyy-MM-dd').format(appointment['date']), // Convert DateTime to String
    'time': appointment['timeController'].text // Extract text from TextEditingController
  };
}).toList();

    var data ={
          'client': clientemail,
          'doctoremail':doctoremail,
          'amount':amount,
          'sessions':formattedSessions,
         'paymentLink': paymentLink,
          'status':'created'
        };
        try{
      DocumentReference newchat = await FirebaseFirestore.instance.collection('paymentrequest').add(data);
        
            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePaget(selectedindex:  5,)),
                  );}
        catch(e){
          print("the error is "); 
          print(e.toString());
        }
   


  }

  // Function to generate payment link
  Future<void> generatePaymentLink() async {
    setState(() {
      isLoading = true; // Set loading state to true when the process starts
    });

    print("Starting Payment Initialization...");
    final String email = emailController.text.trim();
    final String amount = amountController.text.trim();
    final String reason = reasonController.text.trim();

    if (email.isEmpty || amount.isEmpty || reason.isEmpty) {
      print("ERROR: Missing email, amount, or reason.");
      setState(() {
        isLoading = false; // Reset loading state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email, amount, and reason.")),
      );
      return;
    }

    try {
      final link = await ApiService.initiatePayment(
        customerEmail: email,
        amount: amount,
        reason: reason,
        txRef: "TX-${DateTime.now().millisecondsSinceEpoch}",
      );

      if (link != null) {
        print("Payment Link Received: $link");
        setState(() {
          paymentLink = link;
          isLoading = false; // Reset loading state;
          var sessions =widget.appointmentlist;
          
          createpaymentrequest( FirebaseAuth.instance.currentUser!.email, email, amount, sessions, paymentLink);

        });
      } else {
        print("ERROR: Failed to generate payment link.");
        setState(() {
          isLoading = false; // Reset loading state
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to generate payment link.")),
        );
      }
    } catch (e) {
      print("Exception during payment initialization: $e");
      setState(() {
        isLoading = false; // Reset loading state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("An error occurred during payment initialization.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Request Form",
            style: TextStyle(color: Colors.white)), // AppBar text in white
        backgroundColor: Color(0xFF6A0DAD), // Deep purple shade
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter payment details below:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildTextField(emailController, "Customer Email", Icons.email),
            SizedBox(height: 10),
            _buildTextField(
                amountController, "Amount (ETB)", Icons.monetization_on),
            SizedBox(height: 10),
            _buildTextField(
                reasonController, "Reason for Payment", Icons.description),
            SizedBox(height: 20),
                                Column(
                      children:
                          widget.appointmentlist.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${DateFormat('yyyy-MM-dd').format(entry.value['date'])}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: entry.value['timeController'],
                                decoration: InputDecoration(
                                  labelText: 'Time (10:30 AM)',
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),

            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : generatePaymentLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9B4D96), // Lighter deep purple
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for the button
                  ),
                ), // Disable button while loading
                child: isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : Text("send a request",
                    style: TextStyle(

                      
                      color: Color.fromARGB(233, 90, 185, 241)
                    ),),
              ),
            ),
            SizedBox(height: 20),
            if (paymentLink != null) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFE1BEE7), // Light purple background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Color(0xFF9B4D96), width: 1), // Dark purple border
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(
                        paymentLink!,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6A0DAD)), // Dark purple text
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy,
                          color: Color(0xFF9B4D96)), // Lighter purple icon
                      onPressed: () {
                        if (paymentLink != null) {
                          Clipboard.setData(ClipboardData(text: paymentLink!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Payment link copied!")),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Reusable TextField widget with an icon and label
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType:
          label == "Amount (ETB)" ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF6A0DAD)), // Dark purple icon
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
