import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teraflow/features/chats/chatpage_main.dart';


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
      
       backgroundColor: Colors.transparent,
  
        body: Container(
          decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(99, 0, 0, 0).withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
          child: Column(
            
          children: [
            SizedBox(
              height: 40,
            ),
          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                color: Colors.white, // Opaque white container
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    
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
            ),
             Container(
                 decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75), // Transparent white background
                    borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                  ),
                 
                constraints: BoxConstraints(
                    minWidth: double.infinity,
                  minHeight: 500, // Minimum height of 25px
                ),
                child: (username != null)?
                  FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: username)
                      .get(), // passed the search result to the snapshot
                  builder: (context, snapshot) {
                    var filtered = snapshot.data!.docs
                        .where((doc) =>
                            doc['email'] != FirebaseAuth.instance.currentUser!.email)
                        .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text("No users found"),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true, // Allows the ListView to take only the space it needs
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for the parent ListView
                itemCount: filtered.length ?? 0,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = filtered[index];

                  return ListTile(
                    leading: IconButton(
                      onPressed: () => {messageFunction(context, doc)},
                      icon: Icon(Icons.chat),
                      color: Colors.indigo,
                    ),
                    title: Text(doc['email']),
                    trailing: FutureBuilder<DocumentSnapshot>(
                      future: doc.reference
                          .collection('followers')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data?.exists ?? false) {
                            return ElevatedButton(
                              onPressed: () async {
                                await doc.reference
                                    .collection('followers')
                                    .doc(FirebaseAuth.instance.currentUser!.email)
                                    .delete();
                                setState(() {});
                              },
                              child: Text("Un Follow"),
                            );
                          }
                        }

                        return ElevatedButton(
                          onPressed: () async {
                            await doc.reference
                                .collection('followers')
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .set({
                              'followed by ': FirebaseAuth.instance.currentUser?.email,
                              'time': DateTime.now(),
                            });

                            setState(() {});
                          },
                          child: Text("Follow"),
                        );
                      },
                    ),
                  );
                },
              );
            },
          )
:Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    ),
                  ],
                  ),
                  child: Text("Enter a user name"),
                ),
                ),
              )
              ],
        ),
      ),
    );
  
  }
}