import 'package:flutter/material.dart';
import '../../../clases/Chat.dart';
import '../../../supplies/chat_list.dart';

// Dummy Chat data based on your Chat model


class MyChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
        'PUNK MARKET',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        ),),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              'Logo',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat.otherPhotoUrl),
                  radius: 25,
                ),
                title: Text(
                  chat.otherName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Last message preview..."),  // Mocked message preview
                trailing: Text(
                  '10:30 AM', // Mocked time
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  // Handle chat item tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(chat: chat),
                    ),
                  );
                },
              ),
              Divider(height: 1),
            ],
          );
        },
      ),
    );
  }
}

// A basic detail screen for each chat (optional)
class ChatDetailScreen extends StatelessWidget {
  final Chat chat;

  ChatDetailScreen({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.otherName),
      ),
      body: Center(
        child: Text(
          'Chat with ${chat.otherName}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}


