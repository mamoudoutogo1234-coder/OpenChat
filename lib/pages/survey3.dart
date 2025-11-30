import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:openchat/pages/Selection.dart';

class Survey3 extends StatefulWidget {
  final String email;

  const Survey3({super.key, required this.email});

  @override
  State<Survey3> createState() => _Survey3State();
}

class _Survey3State extends State<Survey3> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final key = GlobalKey<FormState>();
    final supabase = Supabase.instance.client;
    final _codeController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.1),
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le code est invalide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_clock_outlined,
                        color: Color(0xFF1B847F),
                      ),
                      labelText: "Code de Vérification",
                      labelStyle: TextStyle(
                        letterSpacing: 2,
                        color: const Color(0xFF1B847F),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFF1B847F)),
                      ),
                    ),
                    controller: _codeController,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            height: 50,
            width: w * 0.5,
            left: w * 0.25,
            top: h * 0.85,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onPressed: () async {
                if (key.currentState!.validate()) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const CircularProgressIndicator(
                          color: Color(0xAF1B847F),
                        ),
                      ),
                    ),
                  );
                  try {
                    final res = await supabase.auth.verifyOTP(
                      email: widget.email,
                      token: _codeController.text,
                      type: OtpType.email,
                    );
                    if (res.user != null) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SelectionPage()),
                      );
                    }
                  } on AuthException catch (e) {
                    Navigator.pop(context);
                    String message;
                    if (e.message.contains("Invalid token")) {
                      message = "Code invalide. Vérifiez votre saisie.";
                    } else {
                      message = "Erreur d'authentification";
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Une erreur inattendue est survenue."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Icon(Icons.verified, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            top: h * 0.1,
            left: 0.2 * w,
            child: Text(
              "Vérifications",
              style: TextStyle(fontFamily: 'Cursive', fontSize: 45),
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
            bottom: h * 0.2,
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
