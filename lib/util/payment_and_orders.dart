import 'package:flutter/material.dart';

class PaymentAndOrders extends StatefulWidget {
  const PaymentAndOrders({super.key});

  @override
  State<PaymentAndOrders> createState() => _PaymentAndOrdersState();
}

class _PaymentAndOrdersState extends State<PaymentAndOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: const Text('Settings'),
      ),
        );
  
  }
}