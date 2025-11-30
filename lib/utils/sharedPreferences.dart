import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void saveName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("name", name);
}

void saveUid() async {
  final supabase = Supabase.instance.client;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("uid", supabase.auth.currentUser!.id);
}
Future<String?> getUid() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString("name");
  return name;
}


void getName() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString("name");
}
