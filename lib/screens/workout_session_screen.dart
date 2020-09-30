import 'package:fit_mart/widgets/exercise_workout_session_widget.dart';
import 'package:flutter/cupertino.dart';

class WorkoutSessionScreen extends StatefulWidget {
  static const String id = 'workout_session_screen';
  @override
  WorkoutSessionScreenState createState() => WorkoutSessionScreenState();
}

class WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExerciseWorkoutSessionWidget();
  }
}
