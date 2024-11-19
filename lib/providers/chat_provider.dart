// providers/chat_provider.dart
import 'package:flutter/material.dart';
import '../models/chat.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];

  List<Chat> get chats => _chats;

  void addChat(Chat chat) {
    _chats.add(chat);
    notifyListeners();
  }
}