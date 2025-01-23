import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Import file picker package
import 'package:intl/intl.dart'; // To format the timestamp
import 'package:teraflow/pages/videocall_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatpageMain extends StatefulWidget {
    final DocumentSnapshot doc;
    final String recieverEmail;


  const ChatpageMain({
    super.key,
    required this.doc,
    required this.recieverEmail,
  });

  @override
  State<ChatpageMain> createState() => _ChatpageMainState();
}

class _ChatpageMainState extends State<ChatpageMain> {
  final TextEditingController message = TextEditingController();

  // Function to send a message
  void _sendMessage() async {
    if (message.text.isNotEmpty) {
      final timestamp =
          DateFormat('hh:mm a').format(DateTime.now()); // Format timestamp
       await widget.doc.reference.collection('messages').add(
        {
          'message': message.text,
          'timestamp': timestamp,
          'sender': FirebaseAuth.instance.currentUser!.email, // You can set this according to the sender
        });
      }
      message.clear(); // Clear the input field
    }
  

  // Function to pick a file
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.first;
      print("File picked: ${file.name}");
      // You can handle the file here, such as sending it
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.doc.reference.collection('messages') );
    return Scaffold(
      backgroundColor:
          Colors.blueGrey.shade50, // Background color for the whole screen
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back button, profile image, and video call button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(//back button
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  
                  const CircleAvatar(//other guy photo or /avatar
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  
                  const SizedBox(width: 10),
                  Expanded(//other guy email
                    child: Text(
                      widget.recieverEmail,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(//vide call redirecting button
                    icon: const Icon(Icons.videocam, color: Colors.deepPurple),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VideoCallScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Chat messages area with a custom background color
            Expanded(
              child: StreamBuilder(
            stream: widget.doc.reference.collection('messages').snapshots(), 
          builder: (context, snapshot){
            if(snapshot.hasData){
              //print(snapshot.data!.docs);
              if (snapshot.data?.docs.isEmpty == true){
                return Text("No messages yet!");

              }
             
             return ListView.builder(
                padding:  EdgeInsets.all(15.0),
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  
                  DocumentSnapshot msg =snapshot.data!.docs[index];
                  
                  bool isSender = msg['sender'] ==FirebaseAuth.instance.currentUser!.email; // Check if the message is from the sender
                  
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: isSender
                                  ? LinearGradient(
                                      colors: [
                                        Colors.deepPurple.shade300,
                                        Colors.deepPurple.shade700,
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.grey.shade300,
                                        Colors.grey.shade100,
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              msg['message']!,
                              style: TextStyle(
                                color: isSender ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg['timestamp']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

            }
            else{
              return CircularProgressIndicator();
            }
            }
  ),
  
  ),
            // Input area with file picker button and rounded input field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Media Sharing Button
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: _pickFile,
                  ),
                  const SizedBox(width: 8),
                  // Input Field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send Button
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
