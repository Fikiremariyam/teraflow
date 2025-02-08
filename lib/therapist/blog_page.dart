import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teraflow/services/blog/addblogpage.dart';
import 'package:teraflow/services/blog/firestore_service.dart';
import 'package:teraflow/util/blog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late SharedPreferences prefs;
  Map<String, bool> likedBlogs = {}; // Stores liked status locally

  @override
  void initState() {
    super.initState();
    _loadLikedBlogs();
  }

  // Load liked blogs from SharedPreferences
  Future<void> _loadLikedBlogs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      likedBlogs = Map<String, bool>.from(
        prefs.getKeys().where((key) => prefs.getBool(key) == true).fold(
          {},
          (map, key) => {...map, key: true},
        ),
      );
    });
  }

  // Toggle like/unlike the bloge
  Future<void> _toggleLike(Blog blog) async {
    bool isLiked = likedBlogs[blog.id] ?? false;

    if (isLiked) {
      // Unlike the blog in Firestore
      await FirebaseFirestore.instance.collection('blogs').doc(blog.id).update({
        'likes': FieldValue.increment(-1),
      });
      prefs.setBool(blog.id, false); // Update local storage
    } else {
      // Like the blog in Firestore
      await FirebaseFirestore.instance.collection('blogs').doc(blog.id).update({
        'likes': FieldValue.increment(1),
      });
      prefs.setBool(blog.id, true); // Update local storage
    }

    setState(() {
      likedBlogs[blog.id] = !isLiked; // Update the local liked status map
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Blog>>(
        stream: _firestoreService.getBlogs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading blogs'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final blogs = snapshot.data ?? [];

          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              bool isLiked = likedBlogs[blog.id] ?? false;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(blog.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('By ${blog.author}'),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text('${blog.likes} Likes',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => _showBlogDetails(context, blog),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBlogPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Show blog details in a popup dialog
  void _showBlogDetails(BuildContext context, Blog blog) {
    bool isLiked = likedBlogs[blog.id] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(blog.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('By: ${blog.author}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(blog.content),
              ],
            ),
          ),
          actions: [
            // Like button in the pop-up dialog
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: isLiked ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: () {
                _toggleLike(blog); // Toggle like when the button is pressed
                Navigator.pop(
                    context); // Close the dialog after liking/unliking
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
