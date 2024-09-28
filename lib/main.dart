import 'package:flutter/material.dart';
import 'Assets/app_theme.dart';
import 'Pages/login.dart';
import 'Pages/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme, // Set the default theme to dark
      home: LoginPage(),
    );
  }
}
