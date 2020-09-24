import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextInputType textInputType;
  final Icon icon;
  Icon prefixIcon;
  bool isObscure;
  Function onChanged;

  CustomTextField(
      {@required this.labelText,
      @required this.textInputType,
      @required this.isObscure,
      this.icon,
      this.prefixIcon,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        onChanged: onChanged,
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
