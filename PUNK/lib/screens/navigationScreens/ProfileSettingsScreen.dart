import 'package:flutter/material.dart';
import '../../clases/User.dart';
import '../../supplies/UserService.dart';
import 'package:http/http.dart' as http;

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final UserService _userService = UserService();
  User? user;

  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController telegramController;
  late TextEditingController addressController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data based on the logged-in phone number
  Future<void> _fetchUserData() async {
    // Replace this with how you retrieve the logged-in user's phone number
    String loggedInPhoneNumber = '7'; // Use the actual logged-in phone number

    // Fetch user data from the backend based on the phone number
    User? fetchedUser = await _userService.fetchUser(loggedInPhoneNumber, '7'); // Empty password for now

    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;

        // Initialize controllers with fetched user data
        fullNameController = TextEditingController(text: user!.userName);
        phoneNumberController = TextEditingController(text: user!.number);
        telegramController = TextEditingController(text: user!.telegramID ?? '');
        addressController = TextEditingController(text: user!.location ?? '');
      });
    }
  }

  // Save the changed settings (you can implement saving logic here)
  void _changeSettings() {
    if (_formKey.currentState!.validate()) {
      // Handle save logic, such as sending the updated data to the backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Profile Settings"),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: user!.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
                    : null,
                child: user!.photoUrl == null
                    ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                    : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: telegramController,
                decoration: InputDecoration(labelText: 'Telegram ID'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _changeSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
