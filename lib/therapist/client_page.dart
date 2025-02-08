import 'package:flutter/material.dart';
import 'package:teraflow/pages/payment_page.dart';

class ClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Client Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to PaymentPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
              child: Text('Request Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
