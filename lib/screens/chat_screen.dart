// screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart'; // Import for file picker
import '../providers/chat_provider.dart';
import '../models/chat.dart';
import '../services/gemini_api.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.chats.length,
              itemBuilder: (ctx, index) {
                final chat = chatProvider.chats[index];
                return ListTile(
                  title: Text(chat.message),
                  subtitle: Text(chat.isUser ? "You" : "AI"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file), // File attachment button
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png'], // Allow only PDFs and images
                    );
                    if (result != null) {
                      // You can handle the selected file here
                      final filePath = result.files.single.path;
                      print("File selected: $filePath");

                      // Optionally, send the file path as a chat message
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
                    decoration: InputDecoration(labelText: "Enter a message"),
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
