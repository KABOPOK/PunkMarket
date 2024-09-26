import 'package:flutter/material.dart';
import 'RegistrationForm.dart';
import 'LoginForm.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(),
            SizedBox(height: 50),
            _buildLoginButton(context),
            SizedBox(height: 20),
            _buildRegistrationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'ПУНК',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'market',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 50,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginForm()),
        );
      },
      child: Text(
        'ВОЙТИ',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationForm()),
        );
      },
      child: Text(
        'РЕГИСТРАЦИЯ',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
