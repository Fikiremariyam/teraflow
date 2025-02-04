
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

// creating the eniing 

final int  appID = 54234541;
final appSign="3dce0357b70a0630fffab6416c246760603f2b78706532cde548f5d3e11d4afa";


 //main class

class _CallPageState extends State<CallPage> {
  Widget? localView;
  Widget? remoteView;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appID, 
      appSign: appSign,
      callID: "fghjkl", 
      userID: FirebaseAuth.instance.currentUser!.email ?? "hi", // You can set this according to the sende. , 
      userName: "userName",
       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  
}
}