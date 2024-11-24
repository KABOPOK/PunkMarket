import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Online/Online.dart';
import '../../../clases/User.dart';
import '../../../common_functions/Functions.dart';
import '../../../services/UserService.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final User user;

  ProfileSettingsScreen({required this.user});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState(user: user);
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {

  final ImagePicker _picker = ImagePicker();
  String existingImageUrl = '';
  File? newImage;

  User user;

  _ProfileSettingsScreenState({required this.user});

  // Update user details
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final telegramController = TextEditingController();
  final addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize the TextEditingControllers with Online.user values
    fullNameController.text = Online.user.userName ?? '';
    phoneNumberController.text = Online.user.number ?? '';
    telegramController.text = Online.user.telegramID ?? '';
    addressController.text = Online.user.location ?? '';
  }
  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    telegramController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        newImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> _updateUser() async {
    try {
      user.userName = fullNameController.text;
      user.number = phoneNumberController.text;
      user.telegramID = telegramController.text;
      user.location= addressController.text;
      user.password = Online.user.password;
      // Call the updateProduct service with all data
      await UserService.updateUser(
        Online.user.userID,
        user,
        context,
        imagePath: newImage?.path,
      );

      Navigator.pop(context);
    } catch (e) {
      Functions.showSnackBar('Error updating user: $e', context);
    }
  }
  // Save the changed settings
  void _changeSettings() {
    if (_formKey.currentState!.validate()) {
      _updateUser();
      // Pop and return true to indicate that changes were made
      Navigator.pop(context, true);
    }else{
      Functions.showSnackBar("Please, fill all fields", context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Profile Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Online.user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
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

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(2, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Full Name
                      InfoRow(
                        label: "Full Name",
                        controller: fullNameController,
                      ),
                      SizedBox(height: 8),
                      InfoRow(
                        label: "Phone Number",
                        controller: phoneNumberController,
                      ),
                      SizedBox(height: 8),
                      InfoRow(
                        label: "Telegram",
                        controller: telegramController,
                      ),
                      SizedBox(height: 8),
                      InfoRow(
                        label: "Address",
                        controller: addressController,
                      ),
                    ],
                  ),
                ),
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

// Custom widget for rows with label and editable field
class InfoRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  InfoRow({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        Container(
          width: 120,
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        // Editable Text Field
        Expanded(
          child: TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              isDense: true, // Reduces the height of the TextFormField
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String? value;

  ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? '',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
