import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:motomaps/Pages/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/Assets/wheel-small.png'), // Update path as needed
                  backgroundColor: Colors.black, // Ensures background color is black
                ),
                SizedBox(height: 20),
                // App Name
                Text(
                  'MotoMaps',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Login Title
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      HoverTextField(
                        controller: _usernameController,
                        labelText: 'Username',
                      ),
                      SizedBox(height: 15),
                      HoverTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle login logic here
                    },
                    child: Text(
                        'Login',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800], // Darker gray background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Google sign-up here
                    },
                    icon: Image.asset(
                      'lib/Assets/google-logo.png',
                    ),
                    label: Text(
                      'Signup with Google',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800], // Ensure this color matches the theme's button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, // Ensure this uses the theme's text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // "Join if new user" Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'New rider? ',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable HoverTextField Widget
class HoverTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

  const HoverTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  _HoverTextFieldState createState() => _HoverTextFieldState();
}

class _HoverTextFieldState extends State<HoverTextField> {
  Color fillColor = Colors.grey[850]!;

  @override
  Widget build(BuildContext context) {
    Color offWhite = Color(0xFFFAFAFA); // Light off-white color

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          fillColor = Colors.grey[700]!;
        });
      },
      onExit: (event) {
        setState(() {
          fillColor = Colors.grey[850]!;
        });
      },
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: offWhite),
          filled: true,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: offWhite),
        obscureText: widget.obscureText,
      ),
    );
  }
}
