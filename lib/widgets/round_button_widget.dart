import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoundButtonWidget extends StatelessWidget {
  final Color color;
  final Function onTap;
  final Widget nestedWidget;
  const RoundButtonWidget({
    @required this.color,
    @required this.onTap,
    this.nestedWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color, // button color
        child: InkWell(
          splashColor: kAccentColor, // inkwell color
          child: SizedBox(width: 56, height: 56, child: nestedWidget),
          onTap: onTap,
        ),
      ),
    );
  }
}
