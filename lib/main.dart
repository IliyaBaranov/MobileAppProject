import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
