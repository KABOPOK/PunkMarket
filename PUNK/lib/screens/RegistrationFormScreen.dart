import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:punk/screens/WelcomeScreen.dart';
import 'package:uuid/uuid.dart';

import 'package:punk/Global/Global.dart';

import '../clases/User.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _numberController = TextEditingController();
  final _telegramController = TextEditingController();
  File? _image;
  bool _agreementChecked = false;
  final ImagePicker _picker = ImagePicker();

  // PostgreSQL connection
  late PostgreSQLConnection _connection;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      // if (pickedFile != null) {
      //   _image = File(pickedFile.path);
      // } else {
      //   print('No image selected.');
      // }
      if (pickedFile != null) {
        // Define the new file name
        String newFileName = 'custom_name.jpg'; // Change this to your desired name
        String newPath = '${pickedFile.path.substring(0, pickedFile.path.lastIndexOf('\\'))}/$newFileName';

        // Create a new file with the desired name
        _image = File(newPath);
        pickedFile.saveTo(newPath); // Save the original file to the new path
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _registerUser() async {
    if(_nameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('кто ты, воин?')),
      );
      return;
    }
    if(_passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('тут пароль может быть в 1 цифру')),
      );
      return;
    }
    if(_numberController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('номер дай, я продам втб, они будут тебе кредит втюхивать')),
      );
      return;
    }
    User user = User(
      userName : _nameController.text,
        password : _passwordController.text,
        number : _numberController.text,
        telegramID : _telegramController.text
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/users/create'));

      // Add the user field as a JSON string
      request.fields['user'] = json.encode(user.toUserDTO());

      // Add image file if available
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      // Send the request
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        // Handle error response
        final errorData = json.decode(responseString);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Unknown error')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Pop the current screen off the navigation stack
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.black,
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Номер',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _telegramController,
                  decoration: InputDecoration(
                    labelText: 'Telegramm @ID',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Telegram ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _agreementChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _agreementChecked = value!;
                        });
                      },
                    ),
                    const Text(
                      'Погожев всегда прав',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _registerUser,
                  child: const Text(
                    'зарегаться',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
