import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatpage_main.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chats',
          style:
              TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        ),
        /* actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.deepPurple),
            onPressed: () {
              // Add functionality for more options
            },
          ),
        ],*/
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('users',
                arrayContains: FirebaseAuth.instance.currentUser!.email)
            .orderBy("lastmessageTimeStamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No chats yet",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }
            var filteredDocs = snapshot.data!.docs.where((doc) {
              var receiverEmail = doc['users'].firstWhere(
                (email) => email != FirebaseAuth.instance.currentUser!.email,
                orElse: () => '',
              );
              return receiverEmail.toLowerCase().contains(_searchQuery);
            }).toList();

            return ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = filteredDocs[index];
                var senderEmail = FirebaseAuth.instance.currentUser!.email;
                var receiverEmail = doc['users'].firstWhere(
                  (email) => email != senderEmail,
                  orElse: () => '',
                );

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple[100],
                      child: Text(
                        receiverEmail[0].toUpperCase(),
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                    title: Text(
                      receiverEmail,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      doc['recent_text'] ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTimestamp(doc['lastmessageTimeStamp']),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.deepPurple,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatpageMain(
                            doc: doc,
                            recieverEmail: receiverEmail,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            );
          }
        },
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    // Simple timestamp formatting - you can enhance this
    return timestamp.split(' ')[1];
  }
}
