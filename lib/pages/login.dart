import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openchat/AuthVerify.dart';
import 'package:openchat/pages/Selection.dart';
import 'InscriptionsPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:openchat/utils/sharedPreferences.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
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
          child: const CircularProgressIndicator(color: Color(0xAF1B847F)),
        ),
      ),
    );
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      saveUid();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AuthGate(child: SelectionPage())),
      );
    } catch (e) {
      Navigator.pop(context);
      String errorMessage = "Une erreur inattendue s'est produite.";

      if (e is AuthException) {
        if (e.message.contains("Invalid login")) {
          errorMessage = "Compte introuvable. Veuillez vous inscrire d'abord.";
          Timer(const Duration(seconds: 2), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => InscriptionsPage()),
            );
          });
        } else if (e.message.contains("Rate limit exceeded")) {
          errorMessage = "Trop de tentatives. Veuillez réessayer plus tard.";
        } else {
          errorMessage = "Veuillez vous connecter à Interner";
        }
      } else {
        errorMessage = "Erreur de connexion. Vérifiez votre internet.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: AwesomeSnackbarContent(
            title: 'Erreur',
            message: errorMessage,
            contentType: ContentType.failure,
          ),
        ),
      );
      _emailController.clear();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Connexions',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B847F),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Connectez vous pour reprendre les discussions',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 100),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'exemple@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xAF1B847F)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Email Field
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: '**********',
                    prefixIcon: const Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xAF1B847F)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login(); // Trigger the OTP send
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1B847F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Connexion",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 250),
                Text(
                  "En continuant vous acceptez nos conditions d'utulisations, et vous vous engager à respecter la règle et morale humaine",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous n'avez pas de compte ? ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => InscriptionsPage()),
                        );
                      },
                      child: Text(
                        "En créer",
                        style: TextStyle(
                          color: Color(0xAF1B847F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
