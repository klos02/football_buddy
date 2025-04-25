import 'package:flutter/material.dart';
import 'package:football_buddy/providers/navigation_provider.dart';
import 'package:football_buddy/providers/nearby_points_provider.dart';
import 'package:football_buddy/screens/Content/info_screen.dart';
import 'package:football_buddy/screens/Content/map_screen.dart';
import 'package:football_buddy/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  
  static final List<Widget> _screens = [const MapScreen(), const InfoScreen()];
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          body: _screens[navProvider.currentIndex],
          bottomNavigationBar: const BottomNav(),
        );
      },
    );
  }
}
