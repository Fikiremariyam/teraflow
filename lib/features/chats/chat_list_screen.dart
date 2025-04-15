import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  final List<ChatPreview> chats = [
    ChatPreview(
      name: "UYOYE 👑",
      message: "Nice work 🕺 🕺 🕺",
      time: DateTime.now().subtract(Duration(minutes: 6)),
      avatar: "https://example.com/avatar1.jpg",
      isRead: true,
    ),
    ChatPreview(
      name: "Kal :)",
      message: "Ere teyat esuan nege keseat endewllatalen",
      time: DateTime.now().subtract(Duration(hours: 1)),
      avatar: "https://example.com/avatar2.jpg",
      isRead: true,
    ),
    // Add more chat previews...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatListTile(chat: chat);
        },
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final ChatPreview chat;

  const ChatListTile({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              contactName: chat.name,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundImage:
            chat.avatar != null ? NetworkImage(chat.avatar!) : null,
        child: chat.avatar == null ? Text(chat.name[0]) : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            timeago.format(chat.time, allowFromNow: true),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.message,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.isRead)
            Icon(
              Icons.done_all,
              size: 16,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class ChatPreview {
  final String name;
  final String message;
  final DateTime time;
  final String? avatar;
  final bool isRead;

  ChatPreview({
    required this.name,
    required this.message,
    required this.time,
    this.avatar,
    this.isRead = false,
  });
}
