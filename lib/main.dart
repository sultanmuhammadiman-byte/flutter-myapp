import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const WarungMaduraApp());
}

class WarungMaduraApp extends StatelessWidget {
  const WarungMaduraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Madura Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomePage(),
    );
  }
}