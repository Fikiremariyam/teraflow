import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class ResourceDetailPage extends StatefulWidget {
  final Map<String, dynamic> resource;

  const ResourceDetailPage({
    Key? key,
    required this.resource,
  }) : super(key: key);

  @override
  State<ResourceDetailPage> createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    if (widget.resource['type'] == 'video') {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.asset(
          widget.resource['videoUrl'],
        ),
      );
    }
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1, // Slight shadow for better separation
        title: Text(
          widget.resource['title'],
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false, // Prevents double back button
            expandedHeight: widget.resource['type'] == 'video' ? 300 : 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.resource['type'] == 'video'
                  ? Container(
                      color: Colors.black,
                      child: flickManager != null
                          ? FlickVideoPlayer(flickManager: flickManager!)
                          : Center(child: CircularProgressIndicator()),
                    )
                  : Image.asset(
                      widget.resource['imageUrl'],
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.resource['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (widget.resource['type'] == 'article')
                    Text(
                      widget.resource['content'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    )
                  else
                    Text(
                      widget.resource['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
