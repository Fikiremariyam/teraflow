import 'dart:async';

class ChatServices {
  // Mock user data
  List<Map<String, dynamic>> mockUsers = [
    {"email": "user1@example.com"},
    {"email": "user2@example.com"},
    {"email": "user3@example.com"},
    {"email": "user4@example.com"},
    {"email": "user5@example.com"},
    {"email": "user6@example.com"},
  ];

  // Simulate user stream
  Stream<List<Map<String, dynamic>>> getUserStream() async* {
    await Future.delayed(Duration(seconds: 1)); // Simulate loading
    yield mockUsers;
  }
}
