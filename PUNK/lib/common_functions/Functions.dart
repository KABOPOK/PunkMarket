import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Functions {

  static showSnackBar(String message, final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static Future<File> urlToFile(String imageUrl) async {
    int i = 0;
    String fileName;
    while (imageUrl[i+1] != '.'){ ++i; } // get original filenames for valid order
    if (imageUrl[i] == 'p') { fileName = 'envelop.jpg'; }
    else { fileName = '${imageUrl[i]}.jpg';  }
    final response = await http.get(Uri.parse(imageUrl));
    final directory = Directory('${Directory.current.path}/supplies');
    final file = File('${directory.path}/$fileName');
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

}