import 'package:flutter/material.dart';
import 'Assets/app_theme.dart';
import 'Pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme, // Set the default theme to dark
      home: SignUpPage(),
    );
  }
}
