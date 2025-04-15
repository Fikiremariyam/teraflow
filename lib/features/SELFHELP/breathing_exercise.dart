import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; 

class BreathingExerciseDetailPage extends StatefulWidget {
  const BreathingExerciseDetailPage({super.key});

  @override
  State<BreathingExerciseDetailPage> createState() =>
      _BreathingExerciseDetailPageState();
}

class _BreathingExerciseDetailPageState
    extends State<BreathingExerciseDetailPage> {
      late VideoPlayerController _videoPlayerController;
      List<Map<String, dynamic>>? _videoData; // Nullable to avoid late initialization error
      int _currentVideoIndex = 0;

      late FlickManager flickmanager;

  
  @override
  void initState() {
    super.initState();
    //_loadVideoData();
    flickmanager =FlickManager( 
      videoPlayerController:
        VideoPlayerController.asset("assets/video-1.mp4"));
        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _videoData != null && _videoData!.isNotEmpty
              ? _videoData![_currentVideoIndex]['title']
              : 'Loading...',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      
      body: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    
                  child: FlickVideoPlayer(flickManager: flickmanager),
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                     
                        "title",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                   
                        "discription",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
