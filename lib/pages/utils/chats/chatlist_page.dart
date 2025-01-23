import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatpage_main.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
return   Scaffold(
      appBar: AppBar(title: Text("your Chats"),),
      body: FutureBuilder(
        future:  FirebaseFirestore.instance.collection('chats').where('users',arrayContains: FirebaseAuth.instance.currentUser!.email).get() , 
        builder: (context,snapshot){
          if (snapshot.hasData){
            if (snapshot.data!.docs.isEmpty ?? true){
              return Text("no chat yets");
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0 ,
              itemBuilder:(context, index){
                DocumentSnapshot doc = snapshot.data!.docs[index];
                 var  senderemail = FirebaseAuth.instance.currentUser!.email;
                 var  reciveremail="bcvbcvbnv";

                return ListTile(
                   


                  

                  title : Text( reciveremail )
                  ,
                  subtitle: Text(doc['recent_text']),
                  onTap: (){
                    
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatpageMain(doc: doc,recieverEmail: reciveremail,)));

                  },
                  trailing: Icon(

                    Icons.arrow_forward,
                    
                  ),
                  );
                
              });
          }else{
           return  CircularProgressIndicator();
          }
          
          
         
        }
        ),

    );
  }
  }

