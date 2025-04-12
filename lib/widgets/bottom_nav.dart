import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentIndex,
      onTap: (index) => navigationProvider.setIndex(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Info',
        ),
      ],
    );
  }
}
