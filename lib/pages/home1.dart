import 'package:flutter/material.dart';
import 'package:openchat/pages/DecouvertePage.dart';
import 'package:openchat/pages/MessagePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'groupePage.dart';

class Home1Page extends StatefulWidget {
  Home1Page({super.key});

  @override
  State<Home1Page> createState() => _Home1PageState();
}

class _Home1PageState extends State<Home1Page> {
  String? name;
  Color color = Color(0xFF1B847F);
  int _selectedIndex = 0;


  final List<Widget> routes = [MessagePage(), Groupepage(), Decouvertepage()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(elevation: 5, backgroundColor: color),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.deepPurple,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: color,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
        ),
        iconTheme: IconThemeData(color: color),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: color),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            color: color,
          ),
        ),
      ),
      home: Scaffold(
        body: routes[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: "Discussion",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Communauté"),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism_sharp),
              label: "Decouverte",
            ),
          ],
        ),
      ),
    );
  }
}
