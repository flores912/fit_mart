import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'round_button_widget.dart';

class CurrentPlanWorkoutWidget extends StatelessWidget {
  final Color checkMarkButtonColor;
  final bool isDone;
  final String title;
  final int day;
  final Function onTapCheckmark;
  final Widget roundButtonWidget;

  const CurrentPlanWorkoutWidget(
      {@required this.checkMarkButtonColor,
      @required this.isDone,
      @required this.title,
      @required this.day,
      @required this.onTapCheckmark,
      this.roundButtonWidget});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  RoundButtonWidget(
                    color: checkMarkButtonColor,
                    onTap: onTapCheckmark,
                    nestedWidget: roundButtonWidget,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Day ${day.toString()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ],
    );
  }
}
