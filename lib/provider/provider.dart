
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  String message = "Hello from Parent";

  void updateMessage(String newMessage) {
    message = newMessage;
    notifyListeners();
  }
}