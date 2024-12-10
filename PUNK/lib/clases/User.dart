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

  User({
    this.userID = '',
    this.number = '',
    this.password = '',
    this.userName = '',
    this.photoUrl = '',
    this.location = '',
    this.telegramID = '',
  });

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

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'telegramID': telegramID,
      'userName': userName,
      'number': number,
      'password': password,

    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'] ?? '',
      number: json['number'] ?? '',
      password: json['password'] ?? '',
      userName: json['userName'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      location: json['location'] ?? '',
      telegramID: json['telegramID'] ?? '',
    );
  }

  String display() {
    return 'User ID: $userID\n'
        'Number: $number\n'
        'User Name: $userName\n'
        'Photo URL: $photoUrl\n'
        'Location: $location\n'
        'Telegram: $telegramID';
  }

}
