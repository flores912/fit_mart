import 'package:fit_mart/round_button_set_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseCardItem extends StatefulWidget {
  final String exerciseName;
  final int weight;
  final List<RoundButtonSetItem> roundSetButtons;

  const ExerciseCardItem(
      {Key key, this.exerciseName, this.weight, this.roundSetButtons})
      : super(key: key);

  @override
  ExerciseCardItemState createState() => ExerciseCardItemState();
}

class ExerciseCardItemState extends State<ExerciseCardItem> {
  List<RoundButtonSetItem> roundSetButtons = [
    new RoundButtonSetItem(),
    new RoundButtonSetItem(),
    new RoundButtonSetItem(),
    new RoundButtonSetItem(),
    new RoundButtonSetItem(),
    new RoundButtonSetItem(),
    new RoundButtonSetItem(),
    new RoundButtonSetItem(),
  ];
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Squats',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '230',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                      child: Text(
                        'lbs',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 72.0,
            child: ListView(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              children: roundSetButtons,
            ),
          )
        ],
      ),
    );
  }
}
