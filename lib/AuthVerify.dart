import 'package:flutter/material.dart';
import 'package:openchat/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? _session;

  @override
  void initState() {
    super.initState();

    // Session actuelle
    _session = Supabase.instance.client.auth.currentSession;

    // Écouter les changements
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      setState(() {
        _session = event.session;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_session == null) {
      return LoginPage();
    }

    return widget.child;
  }
}
