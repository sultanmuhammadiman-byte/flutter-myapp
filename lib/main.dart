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
      debugShowCheckedModeBanner: false,
      title: 'Warung Madura Iman',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HomePage(),
    );
  }
}