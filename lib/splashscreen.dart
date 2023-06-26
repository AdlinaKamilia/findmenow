import 'dart:async';
import 'package:findmenow/screens/loginscreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double screenH, screenW;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: screenH * 0.5,
          width: screenW * 0.75,
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(10),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenH * 0.2,
                  width: screenW * 0.65,
                  child: Image.asset("assets/images/findmenowsplash.jpg"),
                ),
                Text(
                  "FindMeNow",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                SizedBox(
                  height: screenH * 0.05,
                ),
                const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
