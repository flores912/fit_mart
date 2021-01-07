import 'package:fit_mart/trainer_view/blocs/edit_set_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

class EditSetCollection extends StatefulWidget {
  final String exerciseUid;
  final int set;

  const EditSetCollection({Key key, this.exerciseUid, this.set})
      : super(key: key);
  @override
  _EditSetCollectionState createState() => _EditSetCollectionState();
}

class _EditSetCollectionState extends State<EditSetCollection> {
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
          actions: [
            FlatButton(
              child: (Text(kSave)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _bloc
                      .addNewSetCollection(
                          widget.exerciseUid, widget.set, reps, rest)
                      .whenComplete(() => Navigator.pop(context));
                }
              },
            ),
          ],
        ),
        body: Row(
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
    );
  }
}
