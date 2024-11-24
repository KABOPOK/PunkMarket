import 'package:flutter/material.dart';
import '../../../Online/Online.dart';
import 'ProfileSettingsScreen.dart';

class MyProfileScreen extends StatefulWidget {

  MyProfileScreen();

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  _MyProfileScreenState();


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
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[700],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    // Await result from ProfileSettingsScreen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSettingsScreen(user: Online.user,),
                      ),
                    );
                    // If result is true, refresh the UI with setState
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: Online.user!.photoUrl != null
                        ? NetworkImage(Online.user!.photoUrl!)
                        : null,
                    child: Online.user!.photoUrl == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'ACCOUNT NAME',
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
                ProfileInfoRow(label: 'PhotoUrl:', value: Online.user.photoUrl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
