import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final TextInputType textInputType;
  final String labelText;
  final Function onChanged;
  final bool obscureText;
  final String errorText;

  const CustomTextForm({
    Key key,
    this.textInputType,
    this.labelText,
    this.onChanged,
    this.obscureText,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}