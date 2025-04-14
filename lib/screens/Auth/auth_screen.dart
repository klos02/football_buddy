import 'package:flutter/material.dart';
import 'package:football_buddy/providers/auth_navigation_provider.dart';
import 'package:football_buddy/screens/Auth/login_screen.dart';
import 'package:football_buddy/screens/Auth/register_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNavigationProvider>(
      builder: (context, nav, _) {
        return Scaffold(
          body: switch (nav.currentScreen) {
            AppScreen.login => LoginScreen(),
            AppScreen.register => RegisterScreen(),
            AppScreen.forgotPassword => const Scaffold(
              body: Center(child: Text('Forgot Password Screen')),
            ),
          },
        );
      },
    );
  }
}
