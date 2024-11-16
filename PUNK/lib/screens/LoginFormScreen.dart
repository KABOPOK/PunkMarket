import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:punk/Global/Global.dart';
import 'package:punk/widgets/barWidgets/MyNavigationBarWidget.dart';

import '../Online/Online.dart';
import '../clases/User.dart';
import '../common_functions/Functions.dart';
import '../services/UserService.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreementChecked = false;

  @override
  void dispose() {
    _numberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateLoginForm() {
    if (_passwordController.text.isEmpty) {
      Functions.showSnackBar('тут пароль может быть в 1 цифру',context);
      return false;
    }

    if (_numberController.text.isEmpty) {
      Functions.showSnackBar('номер дай, я продам втб, они будут тебе кредит втюхивать',context);
      return false;
    }

    return true;
  }

  Future<void> _loginUser() async {
    if (!_validateLoginForm()) return;
    User user = User(
      password: _passwordController.text,
      number: _numberController.text,
    );
    try {
      await UserService.loginUser(user, context);
    } catch (e) {
       Functions.showSnackBar('Error: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'номер',
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'пароль',
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
                const SizedBox(height: 20),
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
                    const Expanded(
                      child: Text(
                        'Меня легко потерять и невозможно забыть',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _loginUser,
                  child: const Text(
                    'ВОЙТИ',
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
