import 'package:flutter/material.dart';
import 'package:qr_app/pages/home_page.dart';

/// Entry point of the application. Boots the app with MyApp.
void main() {
  runApp(const MyApp());
}

/// Root widget configuring app theming and the home page.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QR App",
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}