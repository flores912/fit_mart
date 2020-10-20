import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseWorkoutSessionWidget extends StatelessWidget {
  final String title;
  final int weight;
  final ListView setsList;
  final Color colorContainer;

  final Function onSelected;

  const ExerciseWorkoutSessionWidget({
    Key key,
    this.title,
    this.weight,
    this.setsList,
    this.colorContainer,
    this.onSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          color: colorContainer,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${weight.toString()} lbs',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: setsList,
                      height: 56,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
