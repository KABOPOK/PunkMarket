// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// var e = 32;
// int d = 3;
// String ADDRESS = 'http://192.168.152.20:5000/';
// Future<List<dynamic>> fetchUsers() async {
//   final response = await http.get(Uri.parse('${address}users'));
//
//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   } else {
//     throw Exception('Failed to load users');
//   }
// }
//
// Future<void> addUser(String username, String password, String number, String telegram) async {
//   final response = await http.post(
//     Uri.parse('${ADDRESS}create-user'),  // Correct endpoint
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'name': username,
//       'password': password,
//       'number' : number,
//       'telegram' : telegram
//     }),
//   );
//
//   if (response.statusCode != 200) {
//     throw Exception('Failed to add user');
//   }
// }
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   List<dynamic> _users = [];
//   final _nameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _numberController = TextEditingController();
//   final _telegramController = TextEditingController();
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   Future<void> _loadUsers() async {
//     try {
//       List<dynamic> users = await fetchUsers();
//       setState(() {
//         _users = users;
//       });
//     } catch (e) {
//       // Handle the error
//       print('Error fetching users: $e');
//     }
//   }
//
//   Future<void> _addUser() async {
//     String username = _nameController.text;
//     String password = _passwordController.text;
//     String number = _numberController.text;
//     String telegram = _telegramController.text;
//     try {
//       await addUser(username, password, number, telegram);
//       _nameController.clear();
//       _passwordController.clear();
//       _numberController.clear();
//       _telegramController.clear();
//       _loadUsers();  // Refresh the user list
//     } catch (e) {
//       // Handle the error
//       print('Error adding user: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUsers();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('Users:'),
//             for (var user in _users) Text('${user[1]} (${user[2]}) (${user[3]}) (${user[4]})'),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Username',
//                     ),
//                   ),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(
//                       labelText: 'password',
//                     ),
//                   ),
//                   TextField(
//                     controller: _numberController,
//                     decoration: const InputDecoration(
//                       labelText: 'number',
//                     ),
//                   ),
//                   TextField(
//                     controller: _telegramController,
//                     decoration: const InputDecoration(
//                       labelText: 'telegram',
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: _addUser,
//                     child: const Text('Add User'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'screens/WelcomeScreen.dart';
// Import the WelcomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Set WelcomeScreen as the home screen
    );
  }
}
