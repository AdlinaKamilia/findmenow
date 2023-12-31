import 'dart:async';
import 'dart:convert';

import 'package:findmenow/MyConfig.dart';
import 'package:findmenow/screens/checkinscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import 'registrationscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        // Wrap the Card with Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Times New Roman'),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Set mainAxisSize to min to allow the card to take up only the necessary space
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailEditingController,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "Enter a valid email or password"
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.email),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordEditingController,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 5)
                                      ? "Enter a valid email or password"
                                      : null,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.lock),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minWidth: screenWidth / 3,
                              height: 40,
                              elevation: 10,
                              onPressed: onLogin,
                              color: Theme.of(context).colorScheme.primary,
                              textColor: Theme.of(context).colorScheme.onError,
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: _goToRegister,
              child: const Text(
                "New Account?",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
    }
    String email = _emailEditingController.text;
    String password = _passwordEditingController.text;
    Uri uri = Uri.parse("${MyConfig().server}/login_user.php?"
        "email=$email&password=$password");

    print(uri.toString());
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata.toString());
        if (jsondata['status'] == 'success') {
          User user = User.fromJson(jsondata['data']);
          print(user.email);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Success")));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (content) => CheckInScreen(
                        user: user,
                      )),
              (Route<dynamic> route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registrations Failed")));
        }
        //Navigator.pop(context);
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registrations Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegisterScreen()));
  }
}
