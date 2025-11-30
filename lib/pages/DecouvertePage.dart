import 'package:flutter/material.dart';

class Decouvertepage extends StatefulWidget {
  const Decouvertepage({super.key});

  @override
  State<Decouvertepage> createState() => _DecouvertepageState();
}

class _DecouvertepageState extends State<Decouvertepage> {
  Color color = Color(0xFF1B847F);

  Future<void> loadData() async {}

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {},
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          child: Icon(Icons.addchart_rounded, color: color),
        ),
      ),
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.emoji_food_beverage, color: Colors.white),
        ),
        title: Text(
          "Decouvertes",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        leadingWidth: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
    );
  }
}
