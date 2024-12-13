import 'package:flutter/material.dart';
import '../supplies/app_colors.dart';
import 'RegistrationFormScreen.dart';
import 'LoginFormScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
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
            color: AppColors.accent,
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'market',
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 50,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.primaryText,
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
        'LOG IN',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.primaryText,
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
        'SIGN UP',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
