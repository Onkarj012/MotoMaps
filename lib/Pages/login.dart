import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool otpSent = false;
  bool isButtonDisabled = false;
  late Timer _timer;
  int _start = 30; // Time in seconds

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            isButtonDisabled = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                SizedBox(height: 30),
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('lib/Assets/wheel-small.png'), // Ensure this path is correct
                ),
                SizedBox(height: 10),
                // App Name
                Text(
                  'MotoMaps',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 10),
                // Sign Up Title
                Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: HoverTextField(
                        labelText: 'First name',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: HoverTextField(
                        labelText: 'Last name',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                HoverTextField(
                  labelText: 'Username',
                ),
                SizedBox(height: 15),
                HoverTextField(
                  labelText: 'Email Address',
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isButtonDisabled
                        ? null
                        : () {
                      setState(() {
                        otpSent = true;
                        isButtonDisabled = true;
                        _start = 30;
                        startTimer();
                      });
                    },
                    child: isButtonDisabled
                        ? Text(
                        'Send OTP ($_start s)',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                        : Text(
                        'Send OTP',
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
                SizedBox(height: 15),
                if (otpSent)
                  Row(
                    children: [
                      Expanded(
                        child: HoverTextField(
                          labelText: 'Enter OTP',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle OTP verification
                          },
                          child: Text(
                              'Verify OTP',
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
                    ],
                  ),
                SizedBox(height: 15),
                HoverTextField(
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 15),
                HoverTextField(
                  labelText: 'Confirm password',
                  obscureText: true,
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle sign-up here
                    },
                    child: Text(
                        'Signup →',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HoverTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;

  const HoverTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
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
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: offWhite), // Custom off-white for label
          filled: true,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15), // Consistent padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: offWhite), // Custom off-white for text
        obscureText: widget.obscureText,
        keyboardType: widget.labelText == 'Enter OTP' ? TextInputType.number : TextInputType.text, // Numeric keyboard for OTP
      ),
    );
  }
}