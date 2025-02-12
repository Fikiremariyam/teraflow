import 'package:flutter/material.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({Key? key}) : super(key: key);

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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with actual data length
      itemBuilder: (context, index) {
        // This is mock data. Replace with your actual data source
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
          {
            'name': 'Dr. Michael Chen',
            'username': '@drchen',
            'id': '#TH-2244',
            'sessions': '2 sessions',
            'schedule': 'Feb 12, 3:30 PM',
            'amount': '\$200.00',
            'status': 'paid'
          },
          {
            'name': 'Dr. Emily Brown',
            'username': '@drbrown',
            'id': '#TH-2243',
            'sessions': '1 session',
            'schedule': 'Feb 10, 11:00 AM',
            'amount': '\$100.00',
            'status': 'cancelled'
          },
          {
            'name': 'Dr. John Smith',
            'username': '@drsmith',
            'id': '#TH-2242',
            'sessions': '3 sessions',
            'schedule': 'Feb 8, 1:00 PM',
            'amount': '\$300.00',
            'status': 'pending'
          },
          {
            'name': 'Dr. Lisa Johnson',
            'username': '@drjohnson',
            'id': '#TH-2241',
            'sessions': '2 sessions',
            'schedule': 'Feb 5, 4:00 PM',
            'amount': '\$200.00',
            'status': 'paid'
          },
        ];

        final payment = mockData[index];

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
                          payment['name']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          payment['username']!,
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
                        payment['id']!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Sessions', payment['sessions']!),
                _buildInfoRow('Schedule', payment['schedule']!),
                _buildInfoRow('Amount', payment['amount']!),
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
                        color: _getStatusColor(payment['status']!),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        payment['status']!.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusTextColor(payment['status']!),
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
