import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat.dart';

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
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Enter a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      chatProvider.addChat(
                        Chat(id: DateTime.now().toString(), message: message, isUser: true),
                      );
                      _controller.clear();
                      // TODO: Call API here to get AI response
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
