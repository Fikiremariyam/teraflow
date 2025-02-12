import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teraflow/services/payment/api_service.dart';

class PaymentPage extends StatefulWidget {
  final String? email;
  final String? totalAmount;

  PaymentPage({this.email, this.totalAmount});

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
          isLoading = false; // Reset loading state
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
                    : Text("Generate Payment Link"),
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
