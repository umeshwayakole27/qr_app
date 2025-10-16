import 'package:flutter/material.dart';
import 'package:qr_app/pages/generator_page.dart';
import 'package:qr_app/pages/scanner_page.dart';

/// Hosts navigation between QR generator and scanner pages.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for HomePage controlling the selected bottom navigation tab.
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[GeneratorPage(), ScannerPage()];

  /// Switches the visible page in response to bottom navigation taps.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR App"), centerTitle: true),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.qr_code), label: "Generate"),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan",
          ),
        ],
      ),
    );
  }
}
