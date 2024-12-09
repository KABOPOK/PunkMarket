import 'package:flutter/material.dart';
import '../../../Online/Online.dart';
import '../../../services/UserService.dart';
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
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы точно хотите удалить свой аккаунт?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Нет'),
            ),
            TextButton(
              onPressed: () {
                UserService.deleteUser(userId, context); // Call delete
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Да'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'PUNK MARKET',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              'LOGO',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
              size: 30,
            ),
            onSelected: (choice) => _handleMenuSelection(choice, context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Настройки'),
              ),
              const PopupMenuItem<String>(
                value: 'log_out',
                child: Text('Выйти из аккаунта'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Удалить Аккаунт'),
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
                backgroundColor: Colors.grey[300],
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
                  color: Colors.grey[700],
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
                    backgroundColor: Colors.orange,
                    radius: 18,
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
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
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
