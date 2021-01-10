import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/trainer_view/blocs/edit_workout_name_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class EditWorkoutName extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final Workout workout;

  const EditWorkoutName(
      {Key key, this.workoutPlanUid, this.weekUid, this.workout})
      : super(key: key);

  @override
  _EditWorkoutNameState createState() => _EditWorkoutNameState();
}

class _EditWorkoutNameState extends State<EditWorkoutName> {
  EditWorkoutNameBloc _bloc = EditWorkoutNameBloc();
  String workoutName;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    workoutName = widget.workout.workoutName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Name'),
        actions: [
          FlatButton(
            child: Text(kSave),
            onPressed: () {
              _bloc
                  .updateWorkoutName(widget.workoutPlanUid, widget.weekUid,
                      widget.workout.uid, workoutName)
                  .whenComplete(
                    () => Navigator.pop(context),
                  );
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: workoutName,
          validator: (value) {
            workoutName = value;
            if (workoutName.isEmpty) {
              return kRequired;
            }
            return null;
          },
          maxLines: 1,
          onChanged: (value) {
            workoutName = value;
          },
          decoration: InputDecoration(
            labelText: kWorkoutName + '*',
            alignLabelWithHint: true,
          ),
        ),
      ),
    );
  }
}
