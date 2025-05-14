import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:teraflow/features/aichat/consts.dart';

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

  final openAi = OpenAI.instance.build(
    token: AI_secret_Key,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
      ),
      
      body:DashChat(
        
        messageOptions: const MessageOptions(
         currentUserContainerColor: Color.fromARGB(255, 23, 90, 11),
          containerColor: Color.fromARGB(255, 229, 44, 44), // visible background for other users
          showOtherUsersAvatar: false,
          showCurrentUserAvatar: false,
          textColor: Colors.black,
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
  List<Messages> messagesHistory = messages.reversed.map((m){
    
    if (m.user == currentUser){
      return Messages(role: Role.user, content : m.text);

     
    }else {
      return Messages(role: Role.assistant,content: m.text);

    }


  }).toList();
  
  final request = ChatCompleteText(
    model: Gpt4ChatModel(),
    messages: messagesHistory.map((m) => m.toJson()).toList(),
    maxToken: 200
  );
  try { 
    final result = await openAi.onChatCompletion(request: request);
    print(result);
    for (var element in result!.choices) {
      if (element.message != null) {
        setState(() {
          messages.insert(0, ChatMessage(user: gpt_user, createdAt: DateTime.now(), text: element.message!.content));
        });
      }
    }
  } catch (e) {
    setState(() {
      messages.insert(
        0,
        ChatMessage(
          user: gpt_user,
          createdAt: DateTime.now(),
          text: "Sorry, your model is not working.",
        ),
      );
    });
  }
  
}
}