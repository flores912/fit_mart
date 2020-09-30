import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CheckmarkWidget extends StatelessWidget {
  final Color color;
  final Function onTap;
  const CheckmarkWidget({
    @required this.color, @ required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color, // button color
        child: InkWell(
          splashColor: kAccentColor, // inkwell color
          child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 36,
              )),
          onTap: onTap,
        ),
      ),
    );
  }
}
