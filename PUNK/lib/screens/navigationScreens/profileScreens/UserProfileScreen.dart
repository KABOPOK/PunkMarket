import 'package:flutter/material.dart';
import '../../../Online/Online.dart';
import '../../../clases/User.dart';
import '../../../supplies/app_colors.dart';
import '../messangerScreens/ChatScreen.dart';
import 'ProfileSettingsScreen.dart';

import 'package:flutter/material.dart';
import '../../../Online/Online.dart';
import '../messangerScreens/ChatScreen.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.icons),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.accentBackground,
                backgroundImage: widget.user.photoUrl != null
                    ? NetworkImage(widget.user.photoUrl!)
                    : null,
                child: widget.user.photoUrl == null
                    ? Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.icons2,
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
                        builder: (context) => ChatScreen(),
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
                      Icons.message,
                      color: AppColors.secondaryText,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            widget.user.userName,
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
              color:  AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileInfoRow(label: 'Full Name:', value: widget.user.userName),
                ProfileInfoRow(label: 'Phone Number:', value: widget.user.number),
                ProfileInfoRow(label: 'Telegram:', value: widget.user.telegramID),
                ProfileInfoRow(label: 'Address:', value: widget.user.location),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
