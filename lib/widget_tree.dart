import 'package:flutter/material.dart';
import 'package:football_buddy/landing_page.dart';
import 'package:football_buddy/providers/auth_provider.dart';
import 'package:football_buddy/screens/Auth/auth_screen.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(body: auth.isAuthenticated ? LandingPage() : AuthScreen());
  }
}
