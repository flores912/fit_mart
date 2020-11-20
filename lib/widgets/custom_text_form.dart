import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  final TextInputType textInputType;
  final String labelText;
  final Function onChanged;
  final bool obscureText;
  final String errorText;
  final int maxLength;
  final List<TextInputFormatter> textInputFormatter;

  final int maxLines;

  const CustomTextForm({
    Key key,
    this.textInputType,
    this.labelText,
    this.onChanged,
    this.obscureText,
    this.errorText,
    this.maxLength,
    this.maxLines,
    this.textInputFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: textInputFormatter,
      autofocus: false,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: textInputType,
      maxLength: maxLength,
      maxLines: maxLines,
      maxLengthEnforced: true,
      decoration: InputDecoration(
        labelText: labelText,
        alignLabelWithHint: true,
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
