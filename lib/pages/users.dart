import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:openchat/pages/home1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'DiscussionsPage.dart';

class UserPage extends StatefulWidget {
  Color color;

  UserPage({super.key, required this.color});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Map<String, dynamic>> users = [];
  final supabase = Supabase.instance.client;
  bool vide = false;
  Future<void> loadData() async {
    final myemail = Supabase.instance.client.auth.currentUser?.email;
    final List<dynamic> res = await supabase
        .from('profiles')
        .select()
        .neq('email', myemail.toString());
    setState(() {
      users = List<Map<String, dynamic>>.from(res);
      if (users.isEmpty) {
        vide = true;
      }
    });
  }

  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Home1Page()),
            );
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        centerTitle: true,
        title: Text(
          "Utulisateurs",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: users.isEmpty
          ? vide
                ? Center(child: Text("Aucun Utulisateurs Trouvé"))
                : Center(child: CircularProgressIndicator(color: widget.color))
          : ListView.separated(
              itemCount: users.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiscussionsPage(
                          uid: user['uid'],
                          username: user["name"],
                          profil: 'assets/images/profil.png',
                        ),
                      ),
                    );
                  },
                  title: Text(
                    user["name"] ?? "Unknown",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(user["actus"] ?? ""),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: widget.color, size: 28),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: widget.color,
                  subtitleTextStyle: const TextStyle(color: Colors.white70),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
            ),
    );
  }
}
