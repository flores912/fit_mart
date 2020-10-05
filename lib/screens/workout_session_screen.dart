import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/widgets/exercise_workout_session_widget.dart';
import 'package:fit_mart/widgets/round_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutSessionScreen extends StatefulWidget {
  static const String id = 'workout_session_screen';
  //TODO: IMPLEMENT 2 STREAM BUILDERS. ONE FOR EXERCISE QUERY AND THE OTHER FOR THE SETS QUERY
  @override
  WorkoutSessionScreenState createState() => WorkoutSessionScreenState();
}

class WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: SafeArea(),);
  }
  ListView buildList(List<Exercise>exercisesList){
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: exercisesList.length,
      itemBuilder: (context, index) {
        return ExerciseWorkoutSessionWidget(
          title: exercisesList[index].title,
          weight: exercisesList[index].weight,
          setsList: buildList(exercisesList),
        );
      },
    );
  }

ListView buildSetsList(List<Set>setsList){
  return ListView.separated(scrollDirection: Axis.horizontal,
    separatorBuilder: (BuildContext context, int index) => Divider(),
    itemCount: setsList.length,
    itemBuilder: (context, index) {
      return RoundButtonWidget(
        nestedWidget:Text(setsList[index].reps.toString()) ,
      );
    },
  );
}
}
