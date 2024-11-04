import 'package:flutter/material.dart';
import 'RegistrationFormScreen.dart';
import 'LoginFormScreen.dart';

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
            const SizedBox(height: 50),
            _buildLoginButton(context),
            const SizedBox(height: 21),
            _buildRegistrationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginForm()),
        );
      },
      child: const Text(
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationForm()),
        );
      },
      child: const Text(
        'РЕГИСТРАЦИЯ',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
