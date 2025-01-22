import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Import file picker package
import 'package:intl/intl.dart'; // To format the timestamp
import 'package:teraflow/pages/videocall_page.dart';

class ChatpageMain extends StatefulWidget {
  final String recieverEmail;

  const ChatpageMain({
    super.key,
    required this.recieverEmail,
  });

  @override
  State<ChatpageMain> createState() => _ChatpageMainState();
}

class _ChatpageMainState extends State<ChatpageMain> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages =
      []; // List to hold the messages with timestamp

  // Function to send a message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final timestamp =
          DateFormat('hh:mm a').format(DateTime.now()); // Format timestamp
      setState(() {
        messages.add({
          'message': _controller.text,
          'timestamp': timestamp,
          'sender': 'me', // You can set this according to the sender
        });
      });
      _controller.clear(); // Clear the input field
    }
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.recieverEmail,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
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
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  bool isSender = message['sender'] ==
                      'me'; // Check if the message is from the sender
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
                              message['message']!,
                              style: TextStyle(
                                color: isSender ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['timestamp']!,
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
                        controller: _controller,
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
