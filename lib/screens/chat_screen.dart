// lib/screens/chat_screen.dart
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png'],
                    );
                    if (result != null) {
                      final filePath = result.files.single.path;
                      chatProvider.addChat(
                        Chat(
                          id: DateTime.now().toString(),
                          message: "File selected: $filePath",
                          isUser: true,
                        ),
                      );
                    }
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
                  onPressed: () async {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      chatProvider.addChat(
                        Chat(id: DateTime.now().toString(), message: message, isUser: true),
                      );
                      _controller.clear();

                      try {
                        final response = await GeminiAPI.sendMessage(message);
                        chatProvider.addChat(
                          Chat(id: DateTime.now().toString(), message: response, isUser: false),
                        );
                        
                        // Scroll to the bottom of the list
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      } catch (e) {
                        chatProvider.addChat(
                          Chat(id: DateTime.now().toString(), message: "Error: $e", isUser: false),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}