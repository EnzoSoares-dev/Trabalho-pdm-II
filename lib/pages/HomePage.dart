import 'package:flutter/material.dart';
import 'package:projeto_chat/pages/ProfilePage.dart';
import 'ChatScreen.dart';

class HomePage extends StatefulWidget {

  HomePage({super.key});
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pageOptions.elementAt(_currentIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "texto"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "texto"),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  final List<Widget> _pageOptions = const <Widget>[ChatScreen(), ProfilePage()];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

