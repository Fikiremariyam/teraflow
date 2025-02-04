import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teraflow/util/blog.dart';

class FirestoreService {
  // Reference to the "blogs" collection in Firestore.
  final CollectionReference blogsCollection =
      FirebaseFirestore.instance.collection('blogs');

  /// Adds a new blog to the "blogs" collection.
  Future<void> addBlog(Blog blog) async {
    await blogsCollection.add({
      ...blog.toMap(), // Convert blog object to a map
      'timestamp':
          FieldValue.serverTimestamp(), // Automatically set server timestamp
    });
  }

  /// Returns a stream of blogs ordered by the timestamp (most recent first).
  Stream<List<Blog>> getBlogs() {
    return blogsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        print(doc.data());
        return Blog.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
