import 'package:flutter/material.dart';
import 'screens/diary_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DiaryHomeScreen(),
      debugShowCheckedModeBanner: false, // Disables the debug banner
    );
  }
}
