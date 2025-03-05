import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatpageMain extends StatefulWidget {
  final DocumentSnapshot doc;
  final String recieverEmail;

  const ChatpageMain({
    Key? key,
    required this.doc,
    required this.recieverEmail,
  }) : super(key: key);

  @override
  State<ChatpageMain> createState() => _ChatpageMainState();
}

class _ChatpageMainState extends State<ChatpageMain> {
  final TextEditingController message = TextEditingController();

  void _sendMessage() async {
    if (message.text.isNotEmpty) {
      final timestamp = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
      await widget.doc.reference.collection('messages').add({
        'message': message.text,
        'timestamp': timestamp,
        'sender': FirebaseAuth.instance.currentUser!.email,
      });
      await widget.doc.reference.update({
        "recent_text": message.text,
        "lastmessageTimeStamp": timestamp,
      });
      message.clear();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.first;
      // Handle file upload here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurple[100],
              radius: 20,
              child: Text(
                widget.recieverEmail[0].toUpperCase(),
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recieverEmail,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'last seen recently',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: widget.doc.reference
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot msg = snapshot.data!.docs[index];
                      bool isSender = msg['sender'] ==
                          FirebaseAuth.instance.currentUser!.email;

                      return Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 8,
                            left: isSender ? 50 : 0,
                            right: isSender ? 0 : 50,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSender
                                ? Colors.deepPurple[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg['message'],
                                style: TextStyle(color: Colors.black87),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg['timestamp'].split(' ')[1],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (isSender) ...[
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.done_all,
                                      size: 16,
                                      color: Colors.deepPurple,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[100],
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: TextField(
                    controller: message,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
