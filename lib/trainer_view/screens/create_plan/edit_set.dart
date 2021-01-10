import 'package:fit_mart/trainer_view/blocs/edit_set_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

class EditSet extends StatefulWidget {
  final int set;
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final String exerciseUid;

  final String setUid;

  const EditSet(
      {Key key,
      this.set,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.exerciseUid,
      this.setUid})
      : super(key: key);

  @override
  _EditSetState createState() => _EditSetState();
}

class _EditSetState extends State<EditSet> {
  EditSetBloc _bloc = EditSetBloc();

  int reps;
  int rest;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Set'),
          actions: [
            FlatButton(
              child: (Text(kSave)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _bloc
                      .addNewSet(
                          widget.workoutPlanUid,
                          widget.weekUid,
                          widget.workoutUid,
                          widget.exerciseUid,
                          widget.set,
                          reps,
                          rest)
                      .whenComplete(() =>
                          _bloc.updateExerciseDetailsNumberOfSets(
                              widget.set,
                              widget.workoutPlanUid,
                              widget.weekUid,
                              widget.workoutUid,
                              widget.exerciseUid))
                      .whenComplete(() => Navigator.pop(context));
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(kSet + ' ' + widget.set.toString()),
              ),
              Expanded(
                child: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  initialValue: reps != null ? reps.toString() : '',
                  validator: (value) {
                    if (value.isEmpty) {
                      return kRequired;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    reps = int.parse(value);
                  },
                  decoration: InputDecoration(
                    labelText: kReps + '*',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    initialValue: rest != null ? rest.toString() : '',
                    validator: (value) {
                      if (value.isEmpty) {
                        return kRequired;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      rest = int.parse(value);
                    },
                    decoration: InputDecoration(
                      labelText: kRest + ' (s)' + '*',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
