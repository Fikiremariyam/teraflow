import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CustomerPaymentPage extends StatelessWidget {
  const CustomerPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'My Payments',
              //style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: _buildPaymentsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsList(BuildContext context) {
    // This is mock data. Replace with your actual data source
    final mockData = [
      {
        'name': 'Dr. Sarah Wilson',
        'username': '@drsarah',
        'id': '#TH-2245',
        'sessions': '4 sessions',
        'schedule': 'Feb 15, 2:00 PM',
        'amount': '\$400.00',
        'status': 'pending',
        'description':
            'Cognitive Behavioral Therapy sessions for anxiety management.'
      },
      {
        'name': 'Dr. Michael Chen',
        'username': '@drchen',
        'id': '#TH-2244',
        'sessions': '2 sessions',
        'schedule': 'Feb 12, 3:30 PM',
        'amount': '\$200.00',
        'status': 'completed',
        'description': 'Follow-up sessions for stress reduction techniques.'
      },
      {
        'name': 'Dr. Emily Brown',
        'username': '@drbrown',
        'id': '#TH-2243',
        'sessions': '1 session',
        'schedule': 'Feb 10, 11:00 AM',
        'amount': '\$100.00',
        'status': 'cancelled',
        'description': 'Initial consultation for depression treatment.'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockData.length,
      itemBuilder: (context, index) {
        final payment = mockData[index];

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
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('ID', payment['id']!),
                _buildInfoRow('Sessions', payment['sessions']!),
                _buildInfoRow('Schedule', payment['schedule']!),
                _buildInfoRow('Amount', payment['amount']!),
                const SizedBox(height: 8),
                Text(
                  'Description:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  payment['description']!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                if (payment['status'] == 'pending')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _showPaymentLinkDialog(context, payment),
                        child: const Text('Pay Now'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _showCompletePaymentDialog(context, payment),
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

  void _showPaymentLinkDialog(
      BuildContext context, Map<String, String> payment) {
    final paymentLink = 'https://example.com/pay/${payment['id']}';

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
                _buildInfoRow('Therapist', payment['name']!),
                _buildInfoRow('Sessions', payment['sessions']!),
                _buildInfoRow('Schedule', payment['schedule']!),
                _buildInfoRow('Amount', payment['amount']!),
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

  void _showCompletePaymentDialog(
      BuildContext context, Map<String, String> payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: const Text('Complete Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Therapist', payment['name']!),
                _buildInfoRow('Sessions', payment['sessions']!),
                _buildInfoRow('Schedule', payment['schedule']!),
                _buildInfoRow('Amount', payment['amount']!),
                const SizedBox(height: 16),
                const Text('Please attach a screenshot of your payment:'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      // Handle the selected image
                      print('Image selected: ${image.path}');
                      // You can add logic here to display the selected image or prepare it for upload
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
              onPressed: () {
                // Implement submit functionality here
                print('Submit button pressed');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
