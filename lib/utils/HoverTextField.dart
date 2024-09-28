import 'package:flutter/material.dart';

class HoverTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged; // Add this line to include the onChanged callback

  const HoverTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
    this.onChanged, // Add this parameter to the constructor
  }) : super(key: key);

  @override
  _HoverTextFieldState createState() => _HoverTextFieldState();
}

class _HoverTextFieldState extends State<HoverTextField> {
  Color fillColor = Colors.grey[850]!;

  @override
  Widget build(BuildContext context) {
    Color offWhite = const Color(0xFFFAFAFA); // Light off-white color

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
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: offWhite),
        obscureText: widget.obscureText,
        onChanged: widget.onChanged, // Pass the onChanged callback to the TextField
      ),
    );
  }
}
