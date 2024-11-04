import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class User {
  String userID;
  String number;
  String password;
  String userName;
  String photoUrl;
  String location;
  String telegramID;

  // Empty constructor
  User({
    this.userID = '',
    this.number = '',
    this.password = '',
    this.userName = '',
    this.photoUrl = '',
    this.location = '',
    this.telegramID = '',
  });

  // Method to convert User object to JSON
  Map<String, dynamic> toUserDTO() {
    return {
      'number': number,
      'password': password,
      'userName': userName,
      'location': location,
      'telegramID': telegramID,
    };
  }

  Map<String, dynamic> toLogonDataDTO() {
    return {
      'number': number,
      'password': password
    };
  }

  // Method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'] ?? '',
      number: json['number'] ?? '',
      password: json['password'] ?? '',
      userName: json['userName'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      location: json['location'] ?? '',
      telegramID: json['telegram'] ?? '',
    );
  }
  
  

  // Method to display user details
  String display() {
    return 'User ID: $userID\n'
        'Number: $number\n'
        'User Name: $userName\n'
        'Photo URL: $photoUrl\n'
        'Location: $location\n'
        'Telegram: $telegramID';
  }
}
