import 'package:flutter/material.dart';

class MyNavigationBar extends StatefulWidget{
  @override
  State<MyNavigationBar> createState() => _NavigationBarstate();

}

class _NavigationBarstate extends State<MyNavigationBar> {

  int _screenIndex =0;
  List<Widget> body = const [
    Icon(Icons.home),
    Icon(Icons.question_answer_sharp),
    Icon(Icons.shopping_basket),
    Icon(Icons.message),
    Icon(Icons.person)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : body[_screenIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        onTap: (int newIndex){
          setState(() {
            _screenIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'home',
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              label: 'question_answer_sharp',
              icon: Icon(Icons.question_answer_sharp)
          ),
          BottomNavigationBarItem(
              label: 'shopping_basket',
              icon: Icon(Icons.shopping_basket)
          ),
          BottomNavigationBarItem(
              label: 'messxage',
              icon: Icon(Icons.message)
          ),
          BottomNavigationBarItem(
              label: 'home',
              icon: Icon(Icons.person)
          ),

        ],
      ),
    );
  }
  
}