import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:openchat/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://avocjgqkxkkofheshsrw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2b2NqZ3FreGtrb2ZoZXNoc3J3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxOTI2ODksImV4cCI6MjA3OTc2ODY4OX0.GBzpltawE2PfLVXiIjlVJk9au3BMCfMnBkEWFX2xz2g',
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 5,
          backgroundColor: Color(0xFF1B847F),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B847F),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            color: const Color(0xFF1B847F),
          ),
        ),
      ),
      home: indexPage(),
    );
  }
}

// ignore: camel_case_types
class indexPage extends StatefulWidget {
  const indexPage({super.key});

  @override
  State<indexPage> createState() => _indexPageState();
}

// ignore: camel_case_types
class _indexPageState extends State<indexPage> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(width: w, height: h),
          Positioned(
            top: h * 0.2,
            left: w * 0.2,
            child: Image.asset('assets/icon/icon.png', width: 120, height: 120),
          ),
          Positioned(
            top: h * 0.25,
            left: w * 0.42,
            child: Text(
              "penChat",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
          Positioned(
            top: h * 0.3,
            left: w * 0.3,
            child: Text(
              "Chattez Autrement Autrement",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: "Cursive",
                fontSize: 20,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xAF1B847F),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xAF1B847F),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
