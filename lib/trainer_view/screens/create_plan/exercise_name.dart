import 'package:fit_mart/trainer_view/blocs/exercise_name_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/exercise_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ExerciseName extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final int exercise;

  const ExerciseName(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.exercise})
      : super(key: key);
  @override
  _ExerciseNameState createState() => _ExerciseNameState();
}

class _ExerciseNameState extends State<ExerciseName> {
  String exerciseName;
  final _formKey = GlobalKey<FormState>();
  ExerciseNameBloc _bloc = ExerciseNameBloc();

  String exerciseUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text(kNext),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _bloc
                    .addNewExercise(
                        exerciseName,
                        widget.exercise,
                        widget.workoutPlanUid,
                        widget.weekUid,
                        widget.workoutUid)
                    .then((value) => exerciseUid = value.id)
                    .whenComplete(() => Navigator.pop(context))
                    .whenComplete(() => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetails(
                              workoutPlanUid: widget.workoutPlanUid,
                              weekUid: widget.weekUid,
                              workoutUid: widget.workoutUid,
                              exerciseUid: exerciseUid,
                            ),
                          ),
                        ));
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            initialValue: exerciseName,
            validator: (value) {
              exerciseName = value;
              if (exerciseName.isEmpty) {
                return kRequired;
              }
              return null;
            },
            maxLines: 1,
            onChanged: (value) {
              exerciseName = value;
            },
            decoration: InputDecoration(
              labelText: kExerciseName + '*',
              alignLabelWithHint: true,
            ),
          ),
        ),
      ),
    );
  }
}
