import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punk/services/UserService.dart';
import 'package:punk/supplies/app_colors.dart';

import '../../clases/User.dart';
import '../../services/ModeratorServices.dart';
import '../WelcomeScreen.dart';


class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  late List<User> filteredUsers = [];
  bool isLoading = true;
  String errorMessage = '';
  int _page = 1;
  final int _limit = 20;
  String _currentQuery = '';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchUsers();
  }
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      ++_page;
      _fetchUsers(query: _currentQuery);
    }
  }

  Future<void> _fetchUsers({String query = ''}) async {
    try {
      List<User> visibleUsers = await ModeratorService.fetchUsers("da10e78e-2bdb-46cc-b53a-70a7612dff24");

      setState(() {
        if (_page == 1) {
          filteredUsers = visibleUsers;
        } else {
          filteredUsers.addAll(visibleUsers);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    _currentQuery = query;
    _page = 1;
    _fetchUsers(query: _currentQuery);
  }

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
    }
  }

  void _confirmDelete(String userId, String userName, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          title: const Text('Подтверждение удаления', style: TextStyle(color: AppColors.primaryText),),
          content: Text(
            'Вы точно хотите удалить пользователя $userName?',
            style: const TextStyle(color: AppColors.primaryText),
          ),
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
              },
              child: const Text('Да', style: TextStyle(color: AppColors.primaryText),),
            ),
          ],
        );
      },
    );
  }

  void _confirmUnreport(User user, String userName, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          title: const Text('Подтверждение отказа репорта', style: TextStyle(color: AppColors.primaryText),),
          content: Text(
            'Вы точно хотите созранить пользователя $userName?',
            style: const TextStyle(color: AppColors.primaryText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Нет', style: TextStyle(color: AppColors.primaryText),),
            ),
            TextButton(
              onPressed: () {
                user.isReported = false;

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
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.icons2,
              backgroundImage: ((){
                if(user.photoUrl != null){
                  return NetworkImage(user.photoUrl!);
                } else {
                  return null;
                }
              })(),
              child: user.photoUrl == null
                  ? Icon(
                Icons.person,
                size: 50,
                color: AppColors.primaryBackground,
              )
                  : null,
            ),
            title: Text(user.userName, style: TextStyle(color: AppColors.primaryText),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: AppColors.priceTag),
                  onPressed: () {
                    _confirmUnreport(user, user.userName, context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.error),
                  onPressed: () {
                    _confirmDelete(user.userID, user.userName, context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}