import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  // Examples of messages
  List<Map<String, dynamic>> messages = [
    {
      'text': "I still don't see why I need a driver's license. Albert Einstein never had a driver's license.",
      'isSender': true,
      'avatar': 'https://i.pinimg.com/564x/a2/49/c8/a249c8d5742f75fbcfe0465ad263aba8.jpg',
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 5)),
    },
    {
      'text': "Yeah, but I never wanted to kill Albert Einstein.",
      'isSender': false,
      'avatar': 'https://i.pinimg.com/564x/f7/21/df/f721df4f4c3648a766cc6fc1f1c52656.jpg',
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 5)),
    },
    {
      'text': "I just gotta ask, why didn't you get a license when you were sixteen like everyone else?",
      'isSender': false,
      'avatar': 'https://i.pinimg.com/564x/f7/21/df/f721df4f4c3648a766cc6fc1f1c52656.jpg',
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 5)),
    },
    {
      'text': "I was otherwise engaged.",
      'isSender': true,
      'avatar': 'https://i.pinimg.com/564x/f7/21/df/f721df4f4c3648a766cc6fc1f1c52656.jpg',
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 5)),
    },
    {
      'text': "Doing what?",
      'isSender': false,
      'avatar': 'https://i.pinimg.com/564x/f7/21/df/f721df4f4c3648a766cc6fc1f1c52656.jpg',
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 5)),
    },
    {
      'text': "Examining perturbative amplitudes  in N equals 4 supersymmetric theories leading to a re-examination of the ultraviolet properties of multi-loop N equals 8 supergravity using modern twistor theory.",
      'isSender': true,
      'avatar': 'https://i.pinimg.com/564x/f7/21/df/f721df4f4c3648a766cc6fc1f1c52656.jpg',
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 5)),
    },
    {
      'text': "...",
      'isSender': false,
      'avatar': 'https://i.pinimg.com/564x/f7/21/df/f721df4f4c3648a766cc6fc1f1c52656.jpg',
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 5)),
    },
    // Additional sample messages...
  ];

  void _sendMessage(String message, {String? imagePath}) {
    if (message.trim().isNotEmpty || imagePath != null) {
      setState(() {
        messages.add({
          'text': message ?? imagePath,
          'isSender': true,
          'isImage': imagePath != null,
          'avatar': 'https://i.pinimg.com/564x/a2/49/c8/a249c8d5742f75fbcfe0465ad263aba8.jpg',
          'timestamp': DateTime.now(),
        });
      });
      _controller.clear();
    }
  }
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _sendMessage('', imagePath: result.files.single.path);
    }
  }
  void _attachFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Logic for handling the picked file
      final file = result.files.first;
      setState(() {
        messages.add({
          'text': "Sent a file: ${file.name}",
          'isSender': true,
          'avatar': 'https://i.pinimg.com/564x/a2/49/c8/a249c8d5742f75fbcfe0465ad263aba8.jpg',
          'timestamp': DateTime.now(),
          'isFile': true,
        });
      });
    }
  }

  bool _isNewDay(int index) {
    if (index == 0) return true; // Always show the date for the first message
    final currentMessageDate = DateTime(
      messages[index]['timestamp'].year,
      messages[index]['timestamp'].month,
      messages[index]['timestamp'].day,
    );
    final previousMessageDate = DateTime(
      messages[index - 1]['timestamp'].year,
      messages[index - 1]['timestamp'].month,
      messages[index - 1]['timestamp'].day,
    );
    return currentMessageDate != previousMessageDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/564x/f7/21/df/f721df4f4c3648a766cc6fc1f1c52656.jpg',
              ),
              radius: 18,
            ),
            SizedBox(width: 10),
            Text(
              'Penny',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final isNewDay = _isNewDay(messages.length - 1 - index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isNewDay)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(message['timestamp']),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: message['isSender']
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!message['isSender'])
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(message['avatar']),
                          ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7),
                          decoration: BoxDecoration(
                            color: message['isSender']
                                ? Colors.lightBlueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(
                                color: message['isSender']
                                    ? Colors.white
                                    : Colors.black87),
                          ),
                        ),
                        if (message['isSender'])
                          SizedBox(width: 8),
                        if (message['isSender'])
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(message['avatar']),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.orange),
            onPressed: _attachFile,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Start typing...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              maxLines: null, // Allows text field to expand for multiple lines
              onSubmitted: (value) => _sendMessage(value),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.orange),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}
