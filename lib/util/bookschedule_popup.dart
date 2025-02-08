
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teraflow/pages/home_page.dart';
import 'package:teraflow/pages/utils/chats/chatlist_page.dart';
import 'package:teraflow/pages/utils/chats/chatpage_main.dart';
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

  

  
void createappontiment(context,doctoremail  )async{
    
      QuerySnapshot q = await FirebaseFirestore.instance.collection('chats').where('users',arrayContains: FirebaseAuth.instance.currentUser!.email).get(); 
      bool chatExists = false;
      String Docid= "";
      for (var doc in q.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        if (data['users'] != null && data['users'].contains(doctoremail)) {
          chatExists = true;
          print("Chat exists: ${doc.id}");
          Docid =doc.id;
          break;
          
        }
      }
    if ( chatExists == false ){
        //create a new chat 
        var data ={
          'users':[
            FirebaseAuth.instance.currentUser!.email,
            doctoremail,
          ],
          "recent_text":"message",
          "lastmessageTimeStamp":  DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()) // Format timestamp
        };
        
        // CREATING A NEW CHAT it the chat dosen't exist 

        DocumentReference newchat = await FirebaseFirestore.instance.collection('chats').add(data);
        DocumentSnapshot newsnapshot =  await newchat.get();
        
        //PROCEED ONY IF THE MESSAGE CONTROLLER HAS FILE 
        if (messageController.text.isNotEmpty) {
            final timestamp = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()); // Format timestamp
            await newsnapshot.reference.collection('messages').add(
              {
                'message': messageController.text,
                'timestamp': timestamp,
                'sender': FirebaseAuth.instance.currentUser!.email, // You can set this according to the sender
              });
              //update last message and time stamp 
              await newchat.update(
                {
                  "recent_text":messageController.text,
                  "lastmessageTimeStamp":timestamp,
                }
              );
              }
              
        }
        
        else{
          DocumentSnapshot chat=  await FirebaseFirestore.instance.collection("chats").doc(Docid).get();
          print("chatid${chat.data()}");
           if (messageController.text.isNotEmpty) {
            final timestamp = DateFormat('hh:mm a').format(DateTime.now()); // Format timestamp
            await chat.reference.collection('messages').add(
              {
                'message': messageController.text,
                'timestamp': timestamp,
                'sender': FirebaseAuth.instance.currentUser!.email, // You can set this according to the sender
              });
                 await chat.reference.update(
                {
                  "recent_text":messageController.text,
                  "lastmessageTimeStamp":timestamp,
                });
              
              }
        }
        messageController.clear();       
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
                      //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatPage()));
                      createappontiment(context,"doctoraselefech@gmail.com");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomePage()));
                    },
                    child: Text("Send Message"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSent = true; // Mark message as sent
                      });
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
