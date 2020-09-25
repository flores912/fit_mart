import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: fix state in this widget
class RoundButtonSetItem extends StatelessWidget {
  bool isSetDone = false;
  Color buttonColor;
  int reps = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 16.0),
        child: ClipOval(
          child: Material(
            color: buttonColor, // button color
            child: InkWell(
              splashColor: Colors.red, // inkwell color
              child: SizedBox(
                  width: 56.0,
                  child: Center(
                    child: displaySetStatus(),
                  )),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }

  Widget displayCheck() {
    return Icon(
      Icons.check,
      color: Colors.white,
      size: 36.0,
    );
  }

  Widget displayReps() {
    return Text(
      reps.toString(),
      style: TextStyle(
        color: Colors.red,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget displaySetStatus() {
    if (isSetDone == false) {
      return displayReps();
    } else {
      return displayCheck();
    }
  }
}
