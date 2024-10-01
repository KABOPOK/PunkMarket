class User {
  String name;
  String password;
  String number;
  String telegram;
  String photoUrl;
  String location;
  List<String> chatUrls;

  User(this.name, this.password, this.number, this.telegram, this.photoUrl,
      this.location, this.chatUrls); //?

  // Constructor


  // Named constructor if you want an empty user

  User.empty()
      : name = '',
        password = '',
        number = '',
        telegram = '',
        photoUrl = '',
        location = '',
        chatUrls = [];

  // Method to display user information
  void displayUser() {
    print('Name: $name');
    print('Email: $password');
    print('Age: $number');
  }
}