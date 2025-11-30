import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openchat/pages/home1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscussionsPage extends StatefulWidget {
  String username;
  String profil;
  String uid;

  DiscussionsPage({
    super.key,
    required this.username,
    required this.profil,
    required this.uid,
  });

  @override
  State<DiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<DiscussionsPage> {
  String name = "";
  Color color = Color(0xFF1B847F);
  final TextEditingController _messageController = TextEditingController();
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> frequentUsers = [];

  Future<String?> uploadImage(XFile file) async {
    final supabase = Supabase.instance.client;

    final fileBytes = await file.readAsBytes();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    await supabase.storage
        .from('uploads')
        .uploadBinary(
      fileName,
      fileBytes,
      fileOptions: const FileOptions(upsert: false),
    );
    return fileName;
  }


  Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> sendImage(String url) async {
    final supabase = Supabase.instance.client;
    await supabase.from('messages').insert({
      "type": "image",
      "content": url,
      "sender_uid": supabase.auth.currentUser!.id,
      "receiver_uid": widget.uid,
    });
  }

  String getImageUrl(String path) {
    final supabase = Supabase.instance.client;
    return supabase.storage.from('uploads').getPublicUrl(path);
  }

  Future<void> sendText() async {
    final text = _messageController.text;
    await supabase.from("messages").insert({
      "content": text,
      "sender_uid": supabase.auth.currentUser?.id,
      "receiver_uid": widget.uid,
    });
    setState(() {});
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = supabase.auth.currentUser?.id;
    final messages = await supabase
        .from("messages")
        .select()
        .or(
          'and(sender_uid.eq.$userId,receiver_uid.eq.${widget.uid}),and(sender_uid.eq.${widget.uid},receiver_uid.eq.$userId)',
        )
        .order('created_at', ascending: true);
    setState(() {
      frequentUsers = List<Map<String, dynamic>>.from(messages);
      name = prefs.getString("name")!;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    Supabase.instance.client
        .channel('messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            final newRecord = payload.newRecord;
            if ((newRecord['sender_uid'] == widget.uid &&
                    newRecord['receiver_uid'] ==
                        supabase.auth.currentUser?.id) ||
                (newRecord['sender_uid'] == supabase.auth.currentUser?.id &&
                    newRecord['receiver_uid'] == widget.uid)) {
              setState(() {
                frequentUsers.add(newRecord);
              });
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget dateBuble(String message) {
    return Align(
      alignment: Alignment.center,
      child: Text(message, style: TextStyle(color: color)),
    );
  }

  Widget chatBubleS(String message, Color choicecolor) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 50), // prevent full width
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: choicecolor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget chatBubleR(String message, Color choicecolor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 50),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: choicecolor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Home1Page()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        leadingWidth: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        ),
        centerTitle: true,
        backgroundColor: color,
        title: Row(
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: 20,
                maxWidth: 45,
                minHeight: 40,
                maxHeight: 40,
              ),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(55)),
              ),
              child: Icon(Icons.person, color: color),
            ),
            SizedBox(width: 10),
            Text(
              widget.username,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            child: ListView.separated(
              itemCount: frequentUsers.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index) {
                final frequentUser = frequentUsers[index];
                final type = frequentUser["type"];
                if (type == "date") {
                  final predate = frequentUser["date"] as DateTime;
                  final date = DateTime.now().difference(predate);
                  if (date.inDays > 0 && date.inDays <= 1) {
                    return dateBuble("Hier");
                  } else if (date.inDays <= 0) {
                    return dateBuble("Aujourd'hui");
                  } else {
                    List<String> months = [
                      'janvier',
                      'février',
                      'mars',
                      'avril',
                      'mai',
                      'juin',
                      'juillet',
                      'août',
                      'septembre',
                      'octobre',
                      'novembre',
                      'décembre',
                    ];
                    return dateBuble(
                      "${predate.day} ${months[predate.month - 1]} ${predate.year}",
                    );
                  }
                } else if (type == "image") {
                  return Image.network(
                    frequentUser["content"],
                    width: 200,
                    fit: BoxFit.cover,
                  );
                } else {
                  final verify =
                      frequentUser["sender_uid"] ==
                      supabase.auth.currentUser?.id;
                  if (verify) {
                    return chatBubleS(frequentUser["content"], color);
                  } else {
                    return chatBubleR(frequentUser["content"], Colors.grey);
                  }
                }
                return null;
              },

              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
            ),
          ),

          Positioned(
            bottom: 20,
            right: 5,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(width: 2, color: Colors.white),
              ),
              child: IconButton(
                onPressed: () {
                  sendText();
                  _messageController.text = "";
                },
                icon: Icon(Icons.send, color: Colors.white, size: 30),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 60,
            child: Container(
              child: TextField(
                style: TextStyle(color: color),
                controller: _messageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: color!, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions_outlined, color: color),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add_a_photo, color: color),
                    onPressed: () async {
                      final file = await pickImage();
                      if (file != null) {
                        final path = await uploadImage(file);
                        if (path != null) {
                          final url = getImageUrl(path);
                          await sendImage(url);
                        }
                      }
                    },
                  ),
                  hintText: "Message",
                  hintStyle: TextStyle(color: color),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
