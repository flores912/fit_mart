import 'package:fit_mart/widgets/round_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseWorkoutSessionWidget extends StatelessWidget {
  final String title;
 final  int weight;
  final ListView setsList;

  const ExerciseWorkoutSessionWidget({Key key, this.title, this.weight, this.setsList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('title',style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),),
            Text('weight',style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.normal,decoration: TextDecoration.underline,),),
          ],
        ),
        setsList
      ],
    );
  }

}
