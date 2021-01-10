import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/trainer_view/blocs/exercise_name_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/exercise_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ExerciseName extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final int exerciseIndex;
  final Exercise exercise;
  final bool isEdit;

  const ExerciseName(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.exerciseIndex,
      this.exercise,
      this.isEdit})
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
  void initState() {
    if (widget.isEdit == true) {
      exerciseUid = widget.exercise.exerciseUid;
      exerciseName = widget.exercise.exerciseName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text(exerciseName == null ? kNext : kSave),
            onPressed: widget.isEdit == true
                ? () {
                    updateExerciseName();
                  }
                : () {
                    addNewExercise();
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

  void updateExerciseName() {
    if (_formKey.currentState.validate()) {
      _bloc
          .updateExerciseName(widget.workoutPlanUid, widget.weekUid,
              widget.workoutUid, exerciseUid, exerciseName)
          .whenComplete(() => Navigator.pop(context));
    }
  }

  void addNewExercise() {
    if (_formKey.currentState.validate()) {
      _bloc
          .addNewExercise(exerciseName, widget.exerciseIndex, 0, null,
              widget.workoutPlanUid, widget.weekUid, widget.workoutUid)
          .then((value) => exerciseUid = value.id)
          .whenComplete(
            () => _bloc
                .updateNumberOfExercises(widget.workoutPlanUid, widget.weekUid,
                    widget.workoutUid, widget.exerciseIndex)
                .whenComplete(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetails(
                        workoutPlanUid: widget.workoutPlanUid,
                        weekUid: widget.weekUid,
                        workoutUid: widget.workoutUid,
                        exerciseUid: exerciseUid,
                      ),
                    ),
                  ).then(
                    (value) => Navigator.pop(context),
                  ),
                ),
          );
    }
  }
}
