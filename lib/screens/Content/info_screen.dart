import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tu możesz dodać informacje o aplikacji, użytkowniku itp.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
