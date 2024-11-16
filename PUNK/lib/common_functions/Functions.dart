import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Functions{
  static showSnackBar(String message, final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}