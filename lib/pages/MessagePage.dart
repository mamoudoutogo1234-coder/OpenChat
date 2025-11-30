import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:openchat/pages/DiscussionsPage.dart';
import 'package:openchat/pages/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:openchat/utils/Hive.dart';

import '../models/FrequentUser.dart';
import '../utils/sharedPreferences.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final StreamSubscription<List<ConnectivityResult>>
  _connectivitySubscription;
  String? name;
  Color color = Color(0xFF1B847F);
  List frequentUsers = [];
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  bool online = false;
  String? uid ;

  Future<void> loadDataOff() async {
    final hiveFrequentStorage = HiveFrequentStorage();
    await hiveFrequentStorage.init();
    final local = hiveFrequentStorage.getAll();
    log(local.toString());
    if (!mounted) return;
    setState(() async {
      frequentUsers = local.toList();
      isLoading = false;
      uid = await getUid();
    });
  }

  Future<void> loadData() async {
    final user_id = supabase.auth.currentUser?.id;
    final hiveFrequentStorage = HiveFrequentStorage();
    await hiveFrequentStorage.init();
    final supabaseFuture = supabase
        .from("frequents")
        .select('''
          id,
          last_message,
          updated_at,
          sender:sender_uid (uid, name, actus),
          receiver:receiver_uid (uid, name, actus)
        ''')
        .or('sender_uid.eq.$user_id,receiver_uid.eq.$user_id')
        .order('updated_at', ascending: false);
    final results = await supabaseFuture;
    final items = results.map<FrequentUser>((m) {
      return FrequentUser(
        id: m['id'].toString(),
        lastMessage: m['last_message'],
        updatedAt: m['updated_at'],
        sender: m['sender'],
        receiver: m['receiver'],
      );
    }).toList();
    hiveFrequentStorage.saveMany(items);
    if (!mounted) return;
    setState(() {
      frequentUsers = List<Map<String, dynamic>>.from(results);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        setState(() => online = true);
        loadData();
      } else {
        setState(() => online = false);
        loadDataOff();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget Online(frequentUser) {
    final me = frequentUser['receiver']['uid'] == supabase.auth.currentUser?.id;
    final lastMessage = frequentUser['last_message'];

    final rawDate = frequentUser['updated_at'];
    final dateTime = DateTime.parse(rawDate);
    final date =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    final user = me ? frequentUser['sender'] : frequentUser['receiver'];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiscussionsPage(
              uid: user['uid'],
              username: user['name'],
              profil: 'assets/images/profil.png',
            ),
          ),
        );
      },
      title: Text(
        user['name'],
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: lastMessage.contains("https://")
            ? Row(
                children: [
                  Icon(Icons.image, color: Colors.grey),
                  Text('image'),
                ],
              )
            : Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
      ),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: color,
        child: Icon(Icons.person, color: Colors.white, size: 28),
      ),
      trailing: Text(
        date, // Placeholder time
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
      tileColor: Colors.white,
    );
  }

  Widget Offline(frequentUser) {
    final me = frequentUser.receiver['uid'] == uid;
    final lastMessage = frequentUser.last_message;

    final rawDate = frequentUser.updated_at;
    final dateTime = DateTime.parse(rawDate);
    final date =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    final user = me ? frequentUser.sender : frequentUser.receiver;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiscussionsPage(
              uid: user.uid,
              username: user['name'],
              profil: 'assets/images/profil.png',
            ),
          ),
        );
      },
      title: Text(
        user['name'],
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: lastMessage.contains("https://")
            ? Row(
                children: [
                  Icon(Icons.image, color: Colors.grey),
                  Text('image'),
                ],
              )
            : Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
      ),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: color,
        child: Icon(Icons.person, color: Colors.white, size: 28),
      ),
      trailing: Text(
        date, // Placeholder time
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
      tileColor: Colors.white,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Light grey background for the whole page
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.person, color: color, size: 25),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: color,
        title: Text(
          "OpenChat",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserPage(color: color)),
          );
        },
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: color))
          : ListView.separated(
              itemCount: frequentUsers.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (BuildContext context, int index) {
                final frequentUser = frequentUsers[index];
                if (!online) {
                  return Offline(frequentUser);
                }
                return Online(frequentUser);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 1, indent: 80, endIndent: 20);
              },
            ),
    );
  }
}
