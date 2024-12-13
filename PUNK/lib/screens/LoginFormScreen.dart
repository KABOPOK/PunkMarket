import 'package:flutter/material.dart';
import '../clases/User.dart';
import '../common_functions/Functions.dart';
import '../services/UserService.dart';
import 'package:flutter/services.dart';

import '../supplies/app_colors.dart';

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
      Functions.showSnackBar('Please, check your password',context);
      return false;
    }

    if (_numberController.text.isEmpty) {
      Functions.showSnackBar('Please, check your phone number',context);
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
      backgroundColor: AppColors.primaryBackground,
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
                    labelText: 'phone number',
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'password',
                    labelStyle: const TextStyle(color: AppColors.primaryText),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: AppColors.primaryText),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please, enter your password';
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
                        'engine start',
                        style: TextStyle(color: AppColors.primaryText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBackground,
                    foregroundColor: AppColors.icons,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _loginUser,
                  child: const Text(
                    'LOG IN',
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
