import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:football_buddy/providers/auth_navigation_provider.dart';
import 'package:football_buddy/providers/auth_provider.dart';
import 'package:football_buddy/providers/navigation_provider.dart';
import 'package:football_buddy/widget_tree.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuthNavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Buddy',
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
      home: WidgetTree(),

      debugShowCheckedModeBanner: false,
    );
  }
}
