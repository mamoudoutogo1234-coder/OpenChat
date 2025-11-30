import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openchat/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InscriptionsPage extends StatefulWidget {
  const InscriptionsPage({super.key});

  @override
  State<InscriptionsPage> createState() => _InscriptionsPageState();
}

class _InscriptionsPageState extends State<InscriptionsPage> {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: isGoogleSignIn ? IndexInscriptions() : Inscriptions(),
        ),
      ),
    );
  }

  // Inscriptions
  Widget IndexInscriptions() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.9, // Ensure it takes up most of the screen height
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          const Text(
            "Inscriptions",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B847F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Rejoignez la communauté OpenChat",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 1),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 56),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            icon: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
              height: 24,
            ),
            label: const Text("Continuer avec Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            onPressed: () {
              googleSignIn();
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B847F),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.email_outlined, size: 24),
            label: const Text("S'inscrire avec un email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            onPressed: () {
              setState(() {
                isGoogleSignIn = false;
              });
            },
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Email Inscriptions
  Widget Inscriptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Back Button
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isGoogleSignIn = true;
                  });
                },
                icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1B847F)),
              ),
              const SizedBox(width: 10),
              const Text(
                "Créer un compte",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B847F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Form(
            key: key,
            child: Column(
              spacing: 20, // Utilizing spacing from recent Flutter versions or wrap in SizedBox
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: "Nom complet",
                  icon: Icons.person_outline,
                  validator: (value) => (value == null || value.isEmpty) ? "Entrer un nom valide" : null,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == "" || value!.isEmpty || !value.contains("@")) ? "Entrer un email valide" : null,
                ),
                _buildTextField(
                  controller: _passwordVController,
                  label: "Mot de passe",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez entrer un mot de passe';
                    if (value.length < 6) return 'Min 6 caractères';
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _passwordController,
                  label: "Confirmer le mot de passe",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Confirmez le mot de passe";
                    if (_passwordController.text != _passwordVController.text) return "Les mots de passe ne correspondent pas";
                    return null;
                  },
                ),
                TextFormField(
                  controller: _interetController,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) => (value == "" || value!.isEmpty) ? "Ce champ est requis" : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    labelText: "Vos motivations",
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.edit_note, color: Color(0xFF1B847F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1B847F), width: 2),
                    ),
                    labelStyle: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B847F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () {
              if (key.currentState!.validate()) {
                SignIn();
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Finaliser l'inscription",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1B847F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1B847F), width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[700]),
      ),
    );
  }
}
