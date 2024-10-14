class Chat {
  String userID_1;
  String userID_2;
  String chatID;
  String photoUrl;

  Chat(this.userID_1, this.userID_2, this.chatID, this.photoUrl); //?

  // Constructor


  // Named constructor if you want an empty user

  Chat.empty()
      : userID_1 = '',
        userID_2 = '',
        chatID = '',
        photoUrl = '';

  // Method to display user information
  void displayUser() {
    print('Name: $userID_1');
    print('Email: $userID_2');
    print('Age: $chatID');
  }
}