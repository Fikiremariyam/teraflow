import 'package:chat_gpt_sdk/chat_gpt_sdk.dart' as chatgpt;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart' as gemini;
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
  List<gemini.Content> ai_History = <gemini.Content>[];
  final gemini.Gemini teraflow = gemini.Gemini.instance;

  @override
  void initState() {
    super.initState();
    intilazeChat();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 150, 34, 200), // visible background for other users ,
        title: const Text('Tera Flow ',
          style: TextStyle(
            color : Color.fromARGB(255, 241, 239, 239),
          )
        ),
      ),
      
      body:Container(
        color: const Color.fromARGB(95, 170, 18, 216),
        child: DashChat(
          
          messageOptions: const MessageOptions(
            
           currentUserContainerColor: Color.fromARGB(255, 192, 132, 218), // visible background for other users ,
            containerColor: Color.fromARGB(255, 150, 34, 200), // visible background for other users
            showOtherUsersAvatar: false,
            showCurrentUserAvatar: false,
            textColor: Color.fromARGB(255, 241, 239, 239),
          ),
          currentUser: currentUser,
          onSend: (ChatMessage m ){
            getChatResponse(m);
        },
         messages: messages),
      )
    );
  }
  
Future<void> getChatResponse(ChatMessage message) async {
  // Handle sending the message
  setState(() {
    messages.insert(0, message);  
    ai_History.add(
       gemini.Content(parts: [
        gemini.Part.text(message.text),],
        role: 'user'),
    
    );  
  });

  // changing the messagelist to   gemini contents and sending it to the gemini api
  // after we get the response we will add it to the message list


  
  try { 
    teraflow.chat(ai_History).
    then((value) {
      String response = value?.output ?? "Sorry, your model is not working.";
      
    ChatMessage? lastMesage = messages.firstOrNull;

    if (lastMesage != null && lastMesage.user.id == gpt_user.id) {
      String lastmessage = messages.removeAt(0).text;

      String new_message = lastmessage + response;
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            user: gpt_user,
            createdAt: DateTime.now(),
            text: new_message,
          ),
        );
      
       ai_History.add(
              gemini.Content(parts: [
                gemini.Part.text(new_message),],
                role: 'model'),
            );
      });


    }else{

       String new_message = value?.output ?? "Sorry, your model is not working."; 
         setState(() {
            messages.insert(
              0,
              ChatMessage(
                user: gpt_user,
                createdAt: DateTime.now(),
                text: new_message ,
              ),
            );
            ai_History.add(
              gemini.Content(parts: [
                gemini.Part.text(new_message),],
                role: 'model'),
            );
          });
    }
  });

    /*
        String question = message.text;
final result = teraflow.prompt(
      parts: [
        gemini.Part.text(question),
        ]).then((value) {

      if (value == null || value.content == null) {
        return;
      }
      
      if (value.output != null) {
       
        final responseText =  value.output ;
        setState(() {
            messages.insert(
              0,
              ChatMessage(
                user: gpt_user,
                createdAt: DateTime.now(),
                text: responseText!,
              ),
            );
          });
            }
          });
    */
    
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

void intilazeChat  (){
  // this send tell the gemini  to behave  like tera flow 
  setState(() {
    ai_History.add(
       gemini.Content(parts: [
        gemini.Part.text('i am using you to power my psychotheraphy app and your name is Tera Flow . never reveal you are gemini and start by saying hellow how are u '),],
        role: 'user'),
    );
    messages.insert(
      0,
      ChatMessage(
        user: gpt_user,
        createdAt: DateTime.now(),
        text: "Hello, I am Tera Flow, your AI assistant. How can I help you today?",
      ),
    );
  });
 
}
}
