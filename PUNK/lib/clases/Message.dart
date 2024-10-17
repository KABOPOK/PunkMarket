class Message {
  String messageID;
  String text;
  DateTime time;
  String chatID;
  String userID;

  // Empty constructor
  Message({
    this.messageID = '',
    this.text = '',
    DateTime? time,
    this.chatID = '',
    this.userID = '',
  }) : time = time ?? DateTime.now(); // Default to current time if not provided

  // Method to convert Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'text': text,
      'time': time.toIso8601String(), // Convert DateTime to ISO 8601 string
      'chatID': chatID,
      'userID': userID,
    };
  }

  // Method to create a Message object from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageID: json['messageID'] ?? '',
      text: json['text'] ?? '',
      time: DateTime.parse(json['time'] ??
          DateTime.now().toIso8601String()), // Parse ISO 8601 string
      chatID: json['chatID'] ?? '',
      userID: json['userID'] ?? '',
    );
  }

  // Method to display message details
  String display() {
    return 'Message ID: $messageID\n'
        'Text: $text\n'
        'Time: ${time.toLocal()}\n' // Convert to local time
        'Chat ID: $chatID\n'
        'User ID: $userID';
  }
}
