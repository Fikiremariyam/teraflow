import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool isMuted = false;
  bool isVideoOn = true;
  bool isFrontCamera = true;

  // Function to toggle mute
  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
  }

  // Function to toggle video on/off
  void toggleVideo() {
    setState(() {
      isVideoOn = !isVideoOn;
    });
  }

  // Function to toggle camera (front/back)
  void toggleCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }

  // End call confirmation dialog
  void endCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('End Call?'),
          content: Text('Are you sure you want to end the call?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // End the call and return
              },
              child: Text('End Call'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.deepPurple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Placeholder for video stream
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.videocam,
                      size: 100,
                      color: isVideoOn ? Colors.deepPurpleAccent : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Video Call in Progress",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              // Control Buttons in Row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute/Unmute Button
                    ElevatedButton(
                      onPressed: toggleMute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMuted ? Colors.red : Colors.green,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        elevation: 5,
                      ),
                      child: Icon(
                        isMuted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    // Video Toggle Button
                    ElevatedButton(
                      onPressed: toggleVideo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isVideoOn ? Colors.deepPurpleAccent : Colors.grey,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        elevation: 5,
                      ),
                      child: Icon(
                        isVideoOn ? Icons.videocam_off : Icons.videocam,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    // Flip Camera Button
                    ElevatedButton(
                      onPressed: toggleCamera,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        elevation: 5,
                      ),
                      child: Icon(
                        isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // End Call Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Confirm before ending call
                    endCall(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "End Call",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
