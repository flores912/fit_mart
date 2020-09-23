import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  CustomMaterialButton(
      {@required this.title,
      @required this.onPressed,
      @required this.color,
      @required this.textColor});

  final String title;
  final Function onPressed;
  final Color color;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(title),
      height: 48.0,
      textColor: textColor,
      onPressed: onPressed,
      color: color,
    );
  }
}
