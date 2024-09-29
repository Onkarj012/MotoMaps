import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/HoverTextField.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool otpSent = false;
  bool isButtonDisabled = false;
  late Timer _timer;
  int _start = 30;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final Map<String, String> _formData = {};
  bool _isLoading = false;
  bool _isOTPLoading = false;
  bool _isVerified = false;
  String? _error;
  String? _otpError;
  String? _token;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final response = await http.post(
          Uri.parse('https://motomaps-backend-1-gvet.onrender.com/auth/google'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': user.displayName,
            'email': user.email,
            'profile_pic': user.photoURL,
          }),
        );

        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          final rawCookie = response.headers['set-cookie'];
          if (rawCookie != null) {
            _token = rawCookie.split(';').firstWhere((cookie) => cookie.startsWith('access_token')).split('=').last;
            await prefs.setString('jwt', _token!);
          }
          // Navigate to the home screen upon successful sign-up
          // Navigator.pushReplacementNamed(context, '/home');
        } else {
          final errorResponse = jsonDecode(response.body);
          setState(() {
            _error = errorResponse['error'];
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> sendOTP() async {
    setState(() {
      _isOTPLoading = true;
    });

    if (_formData['email'] == null || _formData['email']!.isEmpty) {
      setState(() {
        _otpError = 'Please enter an email for OTP verification';
        _isOTPLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://motomaps-backend-1-gvet.onrender.com/auth/sendOTP'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _formData['email']}),
      );

      if (response.statusCode == 200) {
        setState(() {
          otpSent = true;
          _isOTPLoading = false;
        });
      } else {
        setState(() {
          _otpError = 'Failure to send OTP. Please try again later.';
          _isOTPLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _otpError = 'Unexpected error occurred while sending OTP.';
        _isOTPLoading = false;
      });
    }
  }

  Future<void> verifyOTP() async {
    setState(() {
      _isOTPLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://motomaps-backend-1-gvet.onrender.com/auth/verifyOTP'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _formData['email'],
          'otp': _formData['otp'],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isVerified = true;
          _otpError = null;
        });
      } else {
        setState(() {
          _otpError = 'Incorrect OTP';
        });
      }
    } catch (e) {
      setState(() {
        _otpError = 'Unexpected error occurred while verifying OTP.';
      });
    } finally {
      setState(() {
        _isOTPLoading = false;
      });
    }
  }

  Future<void> signupUser() async {
    setState(() {
      _isLoading = true;
    });

    final requiredFields = [
      'firstname',
      'lastname',
      'username',
      'email',
      'password',
      'confirmpassword',
    ];
    final isFormValid = requiredFields.every((field) => _formData[field]?.isNotEmpty ?? false);

    if (!isFormValid) {
      setState(() {
        _error = 'All fields are required';
        _isLoading = false;
      });
      return;
    }

    if (!_isVerified) {
      setState(() {
        _error = 'Email Verification failed';
        _isLoading = false;
      });
      return;
    }

    if (_formData['password'] != _formData['confirmpassword']) {
      setState(() {
        _error = 'Passwords do not match';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://motomaps-backend-1-gvet.onrender.com/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _formData['username'],
          'email': _formData['email'],
          'password': _formData['password'],
          'firstname': _formData['firstname'],
          'lastname': _formData['lastname'],
        }),
      );

      if (response.statusCode == 200) {
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          _token = rawCookie.split(';').firstWhere((cookie) => cookie.startsWith('access_token')).split('=').last;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', _token!);
        }
        // Navigator.pushReplacementNamed(context, '/home');
      } else {
        final errorResponse = jsonDecode(response.body);
        setState(() {
          _error = errorResponse['error'];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
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
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('lib/Assets/wheel-small.png'), // Ensure this path is correct
                ),
                const SizedBox(height: 10),
                // App Name
                Text(
                  'MotoMaps.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                // Sign Up Title
                Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: HoverTextField(
                              labelText: 'First name',
                              controller: _firstNameController,
                              onChanged: (value) {
                                setState(() {
                                 _formData['firstname'] = value.toString().trim();
                                 _error = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: HoverTextField(
                              labelText: 'Last name',
                              controller: _lastNameController,
                              onChanged: (value) {
                                setState(() {
                                  _formData['lastname'] = value.toString().trim();
                                  _error = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                HoverTextField(
                  labelText: 'Username',
                  controller: _usernameController,
                  onChanged: (value) {
                    setState(() {
                      _formData['username'] = value.toString().trim();
                      _error = null;
                    });
                  },
                ),
                const SizedBox(height: 15),
                HoverTextField(
                  labelText: 'Email Address',
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {
                      _formData['email'] = value.toString().trim();
                      _error = null;
                      _otpError = null;

                    });
                  },
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isButtonDisabled ? null : sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, // Ensure this uses the theme's text color
                      ),
                    ),
                    child: isButtonDisabled
                        ? Text(
                      'Send OTP ($_start s)',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                        : Text(
                      'Send OTP',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                if (otpSent)
                  Row(
                    children: [
                      Expanded(
                        child: HoverTextField(
                          labelText: 'Enter OTP',
                          controller: _otpController,
                          onChanged: (value) {
                            setState(() {
                              _formData['otp'] = value.toString().trim();
                              _error = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isOTPLoading ? null : verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800], // Ensure this color matches the theme's button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white, // Ensure this uses the theme's text color
                            ),
                          ),
                          child: _isOTPLoading
                              ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                              : Text(
                            'Verify OTP',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_otpError != null)
                  Text(
                    _otpError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                HoverTextField(
                  labelText: 'Password',
                  obscureText: true,
                  controller: _passwordController,
                  onChanged: (value) {
                    setState(() {
                      _formData['password'] = value.toString().trim();
                      _error = null;
                    });
                  },
                ),
                const SizedBox(height: 15),
                HoverTextField(
                  labelText: 'Confirm password',
                  obscureText: true,
                  controller: _confirmPasswordController,
                  onChanged: (value) {
                    setState(() {
                      _formData['confirmpassword'] = value.toString().trim();
                      _error = null;
                    });
                  },
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : signupUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800], // Ensure this color matches the theme's button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, // Ensure this uses the theme's text color
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
                            'Signup →',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: handleGoogleSignUp,
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
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, // Ensure this uses the theme's text color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Already a user? Login
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already a rider? ',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        TextSpan(
                          text: 'Log in',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
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