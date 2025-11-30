import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openchat/pages/Selection.dart';
import 'package:openchat/pages/login.dart';
import 'package:openchat/pages/survey3.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Survey2 extends StatefulWidget {
  const Survey2({super.key});

  @override
  State<Survey2> createState() => _Survey2State();
}

class _Survey2State extends State<Survey2> {
  bool isGoogleSignIn = true;
  final key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordVController = TextEditingController();
  final _interetController = TextEditingController();

  Future<void> SignIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await Supabase.instance.client.auth.signUp(
        emailRedirectTo: null,
        data: {
          'display_name': _nameController.text,
        },
        email: _emailController.text,
        password: _passwordVController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Ferme le chargement

      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    } on AuthException catch (e) {
      Navigator.pop(context);
      String message;
      if (e.message.contains("User already registered")) {
        message = "Cet email est déjà utilisé par un autre compte.";
      } else if (e.message.contains("Password should be at least")) {
        message = "Le mot de passe est trop court (min 6 caractères).";
      } else if (e.message.contains("Password should contain at least one digit")) {
        message = "Le mot de passe doit contenir au moins un chiffre.";
      } else if (e.message.contains("Password should contain at least one uppercase character")) {
        message = "Le mot de passe doit contenir au moins une majuscule.";
      } else if (e.message.contains("Password should contain at least one special character")) {
        message = "Le mot de passe doit contenir au moins un caractère spécial.";
      } else {
        message = "Erreur lors de l'inscription : ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Ferme le chargement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is AuthException
                ? e.message
                : "Erreur lors de l'inscription : $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> googleSignIn() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isGoogleSignIn ? IndexInscriptions() : Inscriptions(),
    );
  }

  // Inscriptions
  Widget IndexInscriptions() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: h * 0.1,
          left: 0.25 * w,
          child: Text(
            "Inscriptions",
            style: TextStyle(
              fontFamily: 'Cursive',
              fontSize: 45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: h * 0.5,
          left: 0.25 * w,
          child: Column(
            spacing: 15,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                  height: 24,
                ),
                label: Text("S'inscrire avec Google"),
                onPressed: () {
                  googleSignIn();
                },
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xAF1B847F),
                  foregroundColor: Colors.black87,
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  Icons.people_alt_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  "S'inscrire avec son email",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    isGoogleSignIn = false;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(width: w, height: h),
        Positioned(
          top: h * 0.1,
          right: -50,
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
          top: h * 0.85,
          left: -50,
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
    );
  }

  //Email Inscriptions
  Widget Inscriptions() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: h * 0.2,
          left: w * 0.1,
          width: w * 0.8,
          child: Form(
            key: key,
            child: Column(
              spacing: 40,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrer un nom valide";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1B847F)),
                    labelText: "Nom",
                    labelStyle: TextStyle(color: Color(0xFF1B847F)),
                  ),
                  controller: _nameController,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value!.isEmpty || !value.contains("@")) {
                      return "Entrer une email Valide";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF1B847F)),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Color(0xFF1B847F)),
                  ),
                  controller: _emailController,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.white.withOpacity(0.9),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF1B847F)),
                    labelText: "Mot de Passe",
                    labelStyle: TextStyle(color: Color(0xFF1B847F)),
                  ),
                  controller: _passwordVController,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrer un nom Mot de passe de comfirmation";
                    }
                    if (_passwordController.text != _passwordVController.text) {
                      return "Les mot de passe doivent être identique";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.white.withOpacity(0.9),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF1B847F),
                    ),
                    labelText: "Confirmation",
                    labelStyle: TextStyle(color: Color(0xFF1B847F)),
                  ),
                  controller: _passwordController,
                ),
                TextFormField(
                  controller: _interetController,
                  validator: (value) {
                    if (value == "" || value!.isEmpty) {
                      return "Entrer un avis valide";
                    }
                    return null;
                  },
                  minLines: 4,
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    labelText: "Décrivez vos Motivations",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(color: Color(0xFF1B847F)),
                  ),
                ),
                SizedBox(height: 60), // Space for the submit button
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1B847F),
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              elevation: 5,
            ),
            onPressed: () {
              setState(() {
                isGoogleSignIn = true;
              });
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1B847F),
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              elevation: 5,
            ),
            onPressed: () {
              if (key.currentState!.validate()) {
                SignIn();
              }
            },
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
          ),
        ),
        Positioned(
          top: h * 0.1,
          left: 0.25 * w,
          child: Text(
            "E-mail Inscriptions",
            style: TextStyle(fontFamily: 'Cursive', fontSize: 30),
          ),
        ),
        Positioned(
          top: 40,
          left: w * 0.22,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Color(0xFF1B847F)),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Positioned(
          top: h * 0.1,
          right: -50,
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
          top: h * 0.85,
          left: -50,
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
    );
  }
}
