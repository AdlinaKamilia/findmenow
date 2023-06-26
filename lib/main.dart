import 'package:findmenow/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotQuest',
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          textTheme: const TextTheme(
              bodyMedium: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 18,
          ))),
      home: const SplashScreen(),
    );
  }
}
