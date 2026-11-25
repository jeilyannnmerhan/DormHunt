import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme.dart';

void main() => runApp(const DormHuntApp());

class DormHuntApp extends StatelessWidget {
  const DormHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DormHunt',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const LoginScreen(),
    );
  }
}
