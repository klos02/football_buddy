
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:football_buddy/providers/auth_provider.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Center(
      child: ElevatedButton(onPressed: () {
        auth.signOut();
      }, child: Text('Logout')),
    );
  }
}
