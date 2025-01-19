import 'package:flutter/material.dart';

class BookschedulePopup extends StatefulWidget {
  final String therapistName;

  const BookschedulePopup({
    super.key,
    required this.therapistName,
  });

  @override
  _BookschedulePopupState createState() => _BookschedulePopupState();
}

class _BookschedulePopupState extends State<BookschedulePopup> {
  TextEditingController messageController = TextEditingController();
  bool isSent = false;

  // Function to handle sending the message
  void sendMessage(String message) {
    print("Message sent: $message");
    setState(() {
      isSent = true; // Mark message as sent
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Contact ${widget.therapistName}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (!isSent) ...[
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter your message here",
                      border: InputBorder.none,
                    ),
                    maxLines: 4,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String message = messageController.text;
                      sendMessage(message);
                    },
                    child: Text("Send Message"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ] else ...[
              Text("Message Sent!"),
              SizedBox(height: 10),
              Icon(Icons.check_circle, color: Colors.deepPurple, size: 40),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
