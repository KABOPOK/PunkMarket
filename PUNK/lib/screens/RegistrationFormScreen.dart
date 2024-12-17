import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postgres/postgres.dart';
import 'package:punk/screens/WelcomeScreen.dart';

import '../clases/User.dart';
import '../services/UserService.dart';
import '../supplies/app_colors.dart';

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
  late PostgreSQLConnection _connection;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected, no swag.');
      }
    });
  }

  bool _validateLoginForm() {
    if(_nameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please, enter your name')),
      );
      return false;
    }
    if(_passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please, enter your password')),
      );
      return false;
    }
    if(_numberController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please, enter your phone number')),
      );
      return false;
    }
    return true;
  }

  Future<void> _registerUser() async {
    if(_validateLoginForm() == false) {return;}
    User user = User(
      userName: _nameController.text,
      password: _passwordController.text,
      number: _numberController.text,
      telegramID: _telegramController.text,
    );
    try {
      await UserService.registerUser(user, imagePath: _image?.path);
      Navigator.push(context, MaterialPageRoute(builder: (_) => WelcomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.icons),
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
                    backgroundColor: AppColors.accent,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                      Icons.person,
                      size: 80,
                      color: AppColors.secondaryBackground,
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: AppColors.primaryText),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(32),
                  ],
                  style: const TextStyle(color: AppColors.primaryText),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please, enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: AppColors.primaryText),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                  ],
                  obscureText: true,
                  style: const TextStyle(color: AppColors.primaryText),
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
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(color: AppColors.primaryText),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  style: const TextStyle(color: AppColors.primaryText),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please, enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _telegramController,
                  decoration: InputDecoration(
                    labelText: 'Telegramm @ID',
                    labelStyle: const TextStyle(color: AppColors.primaryText),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(32),
                  ],
                  style: const TextStyle(color: AppColors.primaryText),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please, enter your Telegram ID';
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
                      style: TextStyle(color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBackground,
                    foregroundColor: AppColors.primaryText,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _registerUser,
                  child: const Text(
                    'sign up',
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