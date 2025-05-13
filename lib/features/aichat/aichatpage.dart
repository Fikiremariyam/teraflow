import 'package:dart_openai/dart_openai.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AICHATPAGE extends StatefulWidget {
  const AICHATPAGE({super.key});

  @override
  State<AICHATPAGE> createState() => _AICHATPAGEState();
}

class _AICHATPAGEState extends State<AICHATPAGE> {
  final ChatUser currentUser = ChatUser(

    id:  "1",
  );
  final ChatUser gpt_user = ChatUser(
    id : "2",

  );
  List<ChatMessage> messages =  <ChatMessage>[];
  final openAi = OpenAI.instance.chat.create(model: model, messages: messages)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
      ),
      
      body:DashChat(
        messageOptions: const MessageOptions(
        currentUserContainerColor:  Color.fromARGB(255, 23, 90, 11),
        containerColor: Color.fromARGB(0, 166, 126, 1),
        textColor: Colors.white,
        ),
        currentUser: currentUser,
        onSend: (ChatMessage m ){
          getChatResponse(m);
      },
       messages: messages)
    );
  }
  
Future<void> getChatResponse(ChatMessage message) async {
  // Handle sending the message
  setState(() {
    messages.insert(0, message);    
  });
  
}
}