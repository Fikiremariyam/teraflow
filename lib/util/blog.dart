import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String id;
  final String title;
  final String content;
  final String author;
  final String authorId;
  final String category;
  final int likes;
  final DateTime timestamp;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.authorId,
    required this.category,
    required this.likes,
    required this.timestamp,
  });

  // Convert a Blog object into a Map. This is used when saving the blog to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'authorId': authorId,
      'category': category,
      'likes': likes,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Create a Blog object from a Map. This is used when retrieving the blog from Firestore.
  factory Blog.fromMap(String id, Map<String, dynamic> map) {
    return Blog(
      id: id,
      title: map['title'] as String,
      content: map['content'] as String,
      author: map['author'] as String,
      authorId: map['authorId'] as String,
      category: map['category'] as String,
      likes: map['likes'] as int,
      // Handle timestamp field being null or different format
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is Timestamp
              ? (map['timestamp'] as Timestamp).toDate()
              : DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int))
          : DateTime
              .now(), // Default to the current date if no timestamp exists
    );
  }
}
