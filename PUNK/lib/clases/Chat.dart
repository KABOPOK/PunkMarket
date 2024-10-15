class Chat {
  String chatID;
  String otherName;
  String otherPhotoUrl;
  String otherChatID;
  String userID;

  // Empty constructor
  Chat({
    this.chatID = '',
    this.otherName = '',
    this.otherPhotoUrl = '',
    this.otherChatID = '',
    this.userID = '',
  });

  // Method to convert Chat object to JSON
  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'otherName': otherName,
      'otherPhotoUrl': otherPhotoUrl,
      'otherChatID': otherChatID,
      'userID': userID,
    };
  }

  // Method to create a Chat object from JSON
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatID: json['chatID'] ?? '',
      otherName: json['otherName'] ?? '',
      otherPhotoUrl: json['otherPhotoUrl'] ?? '',
      otherChatID: json['otherChatID'] ?? '',
      userID: json['userID'] ?? '',
    );
  }

  // Method to display chat details
  String display() {
    return 'Chat ID: $chatID\n'
        'Other Name: $otherName\n'
        'Other Photo URL: $otherPhotoUrl\n'
        'Other Chat ID: $otherChatID\n'
        'User ID: $userID';
  }
}
