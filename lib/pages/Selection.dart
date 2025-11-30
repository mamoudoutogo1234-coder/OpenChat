import 'package:flutter/material.dart';
import 'package:openchat/pages/home1.dart';
import 'package:openchat/utils/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    // List of categories for cleaner code
    final List<Map<String, dynamic>> categories = [
      {
        "name": "Medecine",
        "icon": Icons.medical_information,
        "color": Colors.redAccent
      },
      {
        "name": "Technologie",
        "icon": Icons.computer,
        "color": Colors.deepPurpleAccent
      },
      {
        "name": "Art & Musique",
        "icon": Icons.music_note,
        "color": Colors.amber[700]
      },
      {
        "name": "Agriculture",
        "icon": Icons.agriculture,
        "color": Colors.green
      },
      {
        "name": "Sport",
        "icon": Icons.fitness_center,
        "color": Colors.blueAccent
      },
      {
        "name": "Style de Vie",
        "icon": Icons.spa,
        "color": Colors.deepOrangeAccent
      },
    ];

    Widget _buildCategoryCard(
      String name,
      IconData icon,
      Color color,
    ) {
      return GestureDetector(
        onTap: () async {
          saveName(name);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Home1Page()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Choisissez un sujet",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Catégories",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1, // Adjust card aspect ratio
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return _buildCategoryCard(
                      cat['name'],
                      cat['icon'],
                      cat['color'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
