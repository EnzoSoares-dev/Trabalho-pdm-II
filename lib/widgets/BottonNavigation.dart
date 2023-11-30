import 'package:flutter/material.dart';

class BottonNavigation extends StatefulWidget {
  const BottonNavigation({super.key});

  BottonNavigationState createState() => BottonNavigationState();
}

class BottonNavigationState extends State<BottonNavigation> {
  final int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.message), label: "texto"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.account_box), label: "texto"),
      ],
      currentIndex: _currentIndex,
    );
  }
}
