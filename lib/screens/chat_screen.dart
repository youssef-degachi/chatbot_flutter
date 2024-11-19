// lib/screens/chat_screen.dart
import 'dart:io';

import 'package:chatbot_app/components/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/chat_provider.dart';
import '../models/chat.dart';
import '../services/gemini_api.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedFile;
  bool _isLoading = false;

  void _sendMessage(ChatProvider chatProvider) async {
    final message = _controller.text;
    if (message.isEmpty && _selectedFile == null) return;

    setState(() { _isLoading = true; });
    
    // Add user message
    chatProvider.addChat(
      Chat(id: DateTime.now().toString(), message: message, isUser: true),
    );
    _controller.clear();

    try {
      String response;
      if (_selectedFile != null) {
        // If file is an image, use image+text API
        response = await GeminiAPI.sendImageMessage(
          _selectedFile!, 
          message.isEmpty ? "Describe this image" : message
        );
        _selectedFile = null; // Reset selected file
      } else {
        // Text-only message
        response = await GeminiAPI.sendTextMessage(message);
      }

      // Add AI response
      chatProvider.addChat(
        Chat(id: DateTime.now().toString(), message: response, isUser: false),
      );
      
      // Scroll to bottom
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      chatProvider.addChat(
        Chat(id: DateTime.now().toString(), message: "Error: $e", isUser: false),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatProvider.chats.length,
              itemBuilder: (ctx, index) {
                final chat = chatProvider.chats[index];
                return Align(
                  alignment: chat.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: chat.isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chat.message,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Selected File: ${_selectedFile!.path.split('/').last}'),
            ),
          if (_isLoading)
            CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FilePickerWidget(
                  onFileSelected: (File file) {
                    setState(() {
                      _selectedFile = file;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Enter a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isLoading ? null : () => _sendMessage(chatProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}