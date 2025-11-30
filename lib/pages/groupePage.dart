import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Groupepage extends StatelessWidget {
  const Groupepage({super.key});

  final List<Map<String, dynamic>> frequentUsers = const [
    {"name": "Siriman", "profil": "salut cv"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 50),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.lightbulb, color: Colors.yellow),
              ),
              Text(
                "En ligne:5",
                style: TextStyle(color: Colors.white, fontFamily: "Cursive"),
              ),
            ],
          ),
        ],
        actionsIconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        leading: Icon(Icons.flip_to_back, color: Colors.white),
        leadingWidth: 100,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group_add_rounded, size: 64),
                    const SizedBox(height: 24),
                    const Text(
                      "Rejoignez la communauté",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Connectez-vous et commencez à discuter avec les autres utilisateurs en temps réel.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text(
                          "Rejoindre le groupe",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
