import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teraflow/pages/utils/chats/chatpage_main.dart';


class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
      String? username;

void messageFunction(context,doc) async{
    
      var userData = doc.data() as Map<String, dynamic>;
      QuerySnapshot q = await FirebaseFirestore.instance.collection('chats').where('users',arrayContains: FirebaseAuth.instance.currentUser!.email).get(); 
      bool chatExists = false;
      for (var doc in q.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['users'] != null && data['users'].contains(userData['email'])) {
          chatExists = true;
          print("Chat exists: ${doc.id}");
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatpageMain(doc: doc,recieverEmail: userData['email'],)));
          break;
        }
      }
    if ( chatExists == false ){
        //create a new chat 
        var data ={
          'users':[
            FirebaseAuth.instance.currentUser!.email,
            userData['email'],
          ],
          "recent_text":"HI",
          "lastmessageTimeStamp":DateTime.now().toString(),
        };

        // sening fifrebase command
        DocumentReference newchat = await FirebaseFirestore.instance.collection('chats').add(data);
        DocumentSnapshot newsnapshot =  await newchat.get();
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatpageMain(doc: newsnapshot,recieverEmail: userData['email'],)));

        }                    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Search For A  psyctist "),
        flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  ) ,
        body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter user name",
              ),
              onChanged: (val){
                username=val;
                setState(() {// to refresh the state of ther name 
                  
                });
              },
            ),
          ),
           
          if (username != null)
          if (username!.length > 3) FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users').where('email',isEqualTo: username).get(),// passed the search result to the snapshot
            builder: (context,snapshot){
              for (var doc in snapshot.data!.docs) {
                //print("searched data");
               //print(doc.id); // Prints the document ID
              //print(doc.data()); // Prints the document data as a map
                  }
              
              var filtered = snapshot.data!.docs.where((doc){
                return doc['email'] != FirebaseAuth.instance.currentUser!.email;//exluding the seracers email 
              }
              ).toList();
              
             if(filtered.isEmpty ?? false){
                  return Text("No user Found!");
                }
              return Expanded(
                child: ListView.builder(
                  itemCount: filtered.length ?? 0,
                  itemBuilder: (context,index){
                    DocumentSnapshot doc = filtered[index];
                  
                  return ListTile(
                    leading: IconButton(
                      onPressed: () => {messageFunction(context,doc)}
                      ,
                      icon: Icon(Icons.chat),color: Colors.indigo,
                    ),
                     title: Text(doc['email']),
                      trailing: FutureBuilder<DocumentSnapshot>(
                        future: doc.reference.collection('followers').doc(FirebaseAuth.instance.currentUser!.email).get() ,
                         builder: (context,snapshot){

                          if (snapshot.hasData){
                            if (snapshot.data?.exists ?? false){
                              return ElevatedButton(
                                onPressed: ()async{
                                  await doc.reference.collection('followers').doc(FirebaseAuth.instance.currentUser!.email).delete();
                                setState(() async{

                                }); // to refresh  the state it rebuild the whole app **not recomnded in production level apps          


                                },
                                child: Text("Un Follow")
                                );

                            };

                          }
                            return ElevatedButton(onPressed: () async {
                             await   doc.reference.collection('followers').doc(FirebaseAuth.instance.currentUser!.email).set(
                                {
                                  'followed by ': FirebaseAuth.instance.currentUser?.email,
                                  'time':DateTime.now(),

                                }// here we  are regstering the current email we have logeed in to to the followrs section for the searched account 
                                // improvemrnt : we can register the followed accouint to the cureent email  people i follow section 
                              );

                              setState(() {});
                            },
                             child: Text("Follow")
                             );
                          
                         })
                     
                  );
                
                }),
              );




            },),
             
        
        ],
      ),
    
    );
  
  }
}