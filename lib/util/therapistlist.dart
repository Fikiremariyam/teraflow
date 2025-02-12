import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teraflow/pages/therapistprofile_page.dart';
import 'package:teraflow/util/therapist_card.dart';

class Therapistlist extends StatefulWidget {
  const Therapistlist({super.key});

  @override
  State<Therapistlist> createState() => _TherapistlistState();
}

class _TherapistlistState extends State<Therapistlist> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
  future: FirebaseFirestore.instance.collection('users').where('role',isEqualTo: "Therapist").get(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text("No Doctors avalible "));
    }
    
    var items = snapshot.data!.docs; // Assume it's a List
    return SizedBox(
      height: 100, // Set a fixed height
      child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context,index){
              var  current_user = items[index].data();
              return  GestureDetector(
                onTap: (){
              
                  MaterialPageRoute(
                            builder: (context) =>
                                TherapistPortfolioPage(therapistEmail: current_user['email']),
                          );

                },
                child: TherapistCard(
                            therapistImagePublicId: current_user['profile_image '] ?? "cld-sample-4",
                            rating: current_user['rating'] ?? '  rating',
                            therapistName: current_user['fullName:'] ?? ' user name ',
                            therapistProfession: current_user['title'] ?? ' title ',
                            experience: current_user['expirance'] ??  ' expiranvce',
                            onTap: () {
                               
                            },
                          ),
              );
                        //SizedBox(width: 10),
                      }
            ),
          );
        }
      );
    }
  }
