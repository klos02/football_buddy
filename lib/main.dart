import 'package:flutter/material.dart';
import 'package:football_buddy/providers/navigation_provider.dart';
import 'package:football_buddy/screens/Content/info_screen.dart';
import 'package:football_buddy/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';
import 'screens/Content/map_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final List<Widget> _screens = [const MapScreen(), const InfoScreen()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Buddy',
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
      home: Consumer<NavigationProvider>(
        builder: (context, navProvider, _) {
          return Scaffold(
            body: _screens[navProvider.currentIndex],
            bottomNavigationBar: const BottomNav(),
          );
        },
      ),

      debugShowCheckedModeBanner: false,
    );
  }
}
