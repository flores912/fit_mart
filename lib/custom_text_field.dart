import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextInputType textInputType;
  final Icon icon;
  Icon prefixIcon;
  bool isObscure;

  CustomTextField({
    @required this.labelText,
    @required this.textInputType,
    @required this.isObscure,
    this.icon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: textInputType,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          icon: icon,
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
