import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/trainer_view/blocs/exercise_name_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/exercise_details.dart';
import 'package:fit_mart/trainer_view/screens/home/exercise_details_collection.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ExerciseNameCollection extends StatefulWidget {
  final int exerciseIndex;
  final Exercise exercise;
  final bool isEdit;

  const ExerciseNameCollection(
      {Key key, this.exerciseIndex, this.exercise, this.isEdit})
      : super(key: key);

  @override
  _ExerciseNameCollectionState createState() => _ExerciseNameCollectionState();
}

class _ExerciseNameCollectionState extends State<ExerciseNameCollection> {
  String exerciseName;
  final _formKey = GlobalKey<FormState>();
  ExerciseNameBloc _bloc = ExerciseNameBloc();

  String exerciseUid;

  @override
  void initState() {
    if (widget.isEdit == true) {
      exerciseName = widget.exercise.exerciseName;
      exerciseUid = widget.exercise.exerciseUid;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text(widget.isEdit == true ? kSave : kNext),
            onPressed: widget.isEdit == true
                ? () {
                    if (_formKey.currentState.validate()) {
                      _bloc
                          .updateExerciseNameCollection(
                              exerciseUid, exerciseName)
                          .whenComplete(() => Navigator.pop(context));
                    }
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

  void addNewExercise() {
    if (_formKey.currentState.validate()) {
      _bloc
          .addNewExerciseToCollection(exerciseName, 0)
          .then((value) => exerciseUid = value.id)
          .whenComplete(
            () => Navigator.pop(context),
          )
          .whenComplete(() => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExerciseDetailsCollection(
                          exerciseUid: exerciseUid,
                        )),
              ));
    }
  }
}
