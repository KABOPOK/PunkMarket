import 'package:flutter/material.dart';
import 'package:punk/screens/WelcomeScreen.dart';
import '../../../Online/Online.dart';
import '../../../services/UserService.dart';
import '../../../supplies/app_colors.dart';
import 'ProfileSettingsScreen.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen();

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  _MyProfileScreenState();

  void _handleMenuSelection(String choice, BuildContext context) {
    switch (choice) {
      case 'settings':
      // Navigate to settings screen
        break;
      case 'log_out':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging Out...')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
      case 'delete':
        _confirmDelete(Online.user.userID, context);
        break;
    }
  }

  void _confirmDelete(String userId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          title: const Text('Подтверждение удаления', style: TextStyle(color: AppColors.primaryText),),
          content: const Text('Вы точно хотите удалить свой аккаунт?', style: TextStyle(color: AppColors.primaryText),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Нет', style: TextStyle(color: AppColors.primaryText),),
            ),
            TextButton(
              onPressed: () {
                UserService.deleteUser(userId, context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                );
              },
              child: const Text('Да', style: TextStyle(color: AppColors.primaryText),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: Text(
          'PUNK MARKET',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryBackground,
            child: Text(
              'LOGO',
              style: TextStyle(color: AppColors.primaryText, fontSize: 12),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.secondaryBackground,
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.icons,
              size: 30,
            ),
            onSelected: (choice) => _handleMenuSelection(choice, context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Настройки', style: TextStyle(color: AppColors.primaryText),),
              ),
              const PopupMenuItem<String>(
                value: 'log_out',
                child: Text('Выйти из аккаунта', style: TextStyle(color: AppColors.primaryText),),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Удалить Аккаунт', style: TextStyle(color: AppColors.primaryText),),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.icons2,
                backgroundImage: ((){
                  if(Online.user.photoUrl != null){
                    return NetworkImage(Online.user.photoUrl!);
                  } else {
                    return null;
                  }
                })(),
                child: Online.user.photoUrl == null
                    ? Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.primaryBackground,
                )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSettingsScreen(
                          user: Online.user,
                        ),
                      ),
                    );
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.accent,
                    radius: 18,
                    child: Icon(
                      Icons.settings,
                      color: AppColors.icons,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            Online.user.userName ?? 'ACCOUNT NAME',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBackground,
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileInfoRow(label: 'Full Name:', value: Online.user.userName),
                ProfileInfoRow(label: 'Phone Number:', value: Online.user.number),
                ProfileInfoRow(label: 'Telegram:', value: Online.user.telegramID),
                ProfileInfoRow(label: 'Address:', value: Online.user.location),
              ],
            ),
          ),
        ],
      ),
    );
  }
}