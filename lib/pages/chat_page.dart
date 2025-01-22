import 'package:flutter/material.dart';
import 'package:teraflow/pages/chatpage_main.dart';
import 'package:teraflow/services/chat_services.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final ChatServices _chatServices = ChatServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Set background color to grey 300
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildUserList(), // Ensure user list takes remaining space
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.grey[300], // Background color for the header
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle selected menu item action
              print('Selected: $value');
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text('Option 1'),
                ),
                PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Text('Option 2'),
                ),
                PopupMenuItem<String>(
                  value: 'Option 3',
                  child: Text('Option 3'),
                ),
              ];
            },
            child: Icon(
              Icons.more_vert, // Icon for menu button
              color: Colors.deepPurple,
            ),
          ),
          // Search Button
          IconButton(
            onPressed: () {
              // Implement search functionality if needed
              print("Search button pressed");
            },
            icon: Icon(
              Icons.search,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatServices.getUserStream(),
      builder: (context, snapshot) {
        // Error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error occurred while fetching users",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        }
        // User List
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatpageMain(
              recieverEmail: userData["email"],
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Image (or placeholder)
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepPurple.shade300,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 16),
            // User's email text (with compact styling)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData["email"],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Last message preview", // You can add a message preview here
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Spacer(),
            // Optional: You can add a status indicator here if needed
          ],
        ),
      ),
    );
  }
}
