import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem {
  final String userName;
  final String userAvatar;
  final String action;
  final String target;
  final DateTime timestamp;
  final String? thumbnail;
  final bool isRead;

  NotificationItem({
    required this.userName,
    required this.userAvatar,
    required this.action,
    required this.target,
    required this.timestamp,
    this.thumbnail,
    required this.isRead,
  });
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!notification.isRead)
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                notification.userAvatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: notification.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: ' ${notification.action} ',
                        ),
                        TextSpan(
                          text: notification.target,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (notification.thumbnail != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    notification.thumbnail!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return DateFormat('d MMM').format(timestamp);
    }
    return DateFormat('d MMM, y').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final List<NotificationItem> notifications = [
      NotificationItem(
        userName: "Meron",
        userAvatar: "https://example.com/avatar1.jpg",
        action: "liked",
        target: "your post",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationItem(
        userName: "Jane Smith",
        userAvatar: "https://example.com/avatar2.jpg",
        action: "commented on",
        target: "your photo",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        thumbnail: "https://example.com/photo_thumbnail.jpg",
      ),
      // Add more sample notifications as needed
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the home page
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
        title: const Text('Notifications'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You have ${notifications.where((n) => !n.isRead).length} unread notifications',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              child: _buildNotificationList(notifications),
            ),
          ],
        ),
      ),
    );
  }
}
