import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Online/Online.dart';
import '../../../clases/User.dart';
import '../../../common_functions/Functions.dart';
import '../../../services/UserService.dart';
import '../../../supplies/app_colors.dart';

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

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final telegramController = TextEditingController();
  final addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
        existingImageUrl = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> _updateUser() async {
    try {
      Online.user.userName = fullNameController.text;
      Online.user.number = phoneNumberController.text;
      Online.user.telegramID = telegramController.text;
      Online.user.location = addressController.text;
      await UserService.updateUser(
        Online.user.userID,
        context,
        imagePath: newImage?.path,
      );
    } catch (e) {
      Functions.showSnackBar('Error updating user: $e', context);
    }
  }
  void _changeSettings() {
    if (_formKey.currentState!.validate()) {
      _updateUser();
    }else{
      Functions.showSnackBar("Please, fill all fields", context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: Text("Profile Settings", style: TextStyle(color: AppColors.primaryText),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: AppColors.icons,),
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
                  backgroundImage: (() {
                    if (newImage != null) {
                      return FileImage(newImage!);
                    }
                    else { return NetworkImage(Online.user!.photoUrl!); }
                  })() as ImageProvider<Object>?,
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
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
                      backgroundColor: AppColors.accent,
                    ),
                    child: Text('Cancel', style: TextStyle(color: AppColors.primaryText),),
                  ),
                  ElevatedButton(
                    onPressed: _changeSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    child: Text('Save', style: TextStyle(color: AppColors.primaryText),),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primaryText),
          ),
        ),
        // Editable Text Field
        Expanded(
          child: TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 16, color: AppColors.primaryText),
            decoration: InputDecoration(
              isDense: true,
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
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
          ),
          Expanded(
            child: Text(
              value ?? '',
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}