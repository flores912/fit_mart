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
  bool isFailure;
  bool isTimed;
  final _formKey = GlobalKey<FormState>();
  String typeOfReps = kTypesOfReps.first;

  String restUnit = kRestUnits.first;

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
                  checkTypesOfValues();
                  _bloc
                      .addNewSetCollection(widget.exerciseUid, widget.set, reps,
                          rest, isTimed, isFailure)
                      .whenComplete(() =>
                          _bloc.updateExerciseDetailsNumberOfSetsCollection(
                              widget.set, widget.exerciseUid))
                      .whenComplete(() => Navigator.pop(context));
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(kSet + ' ' + widget.set.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                typeOfReps == 'failure'
                                    ? IgnorePointer(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'FAILURE',
                                            alignLabelWithHint: true,
                                          ),
                                        ),
                                      )
                                    : TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.number,
                                        initialValue:
                                            reps != null ? reps.toString() : '',
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
                                          labelText:
                                              'Reps' + '($typeOfReps)' + '*',
                                          alignLabelWithHint: true,
                                        ),
                                      ),
                                DropdownButton(
                                  value: typeOfReps,
                                  onChanged: (value) {
                                    setState(() {
                                      typeOfReps = value;
                                    });
                                  },
                                  items: dropdownMenuTypeOfSets(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  initialValue:
                                      rest != null ? rest.toString() : '',
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
                                    labelText: kRest + ' ($restUnit)' + '*',
                                    alignLabelWithHint: true,
                                  ),
                                ),
                                DropdownButton(
                                  value: restUnit,
                                  onChanged: (value) {
                                    setState(() {
                                      restUnit = value;
                                    });
                                  },
                                  items: dropdownMenuRestUnits(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> dropdownMenuTypeOfSets() {
    List<DropdownMenuItem> items = [];
    for (String typeOfReps in kTypesOfReps) {
      items.add(
        DropdownMenuItem(
          value: typeOfReps,
          child: Text(typeOfReps),
        ),
      );
    }
    return items;
  }

  void checkTypesOfValues() {
    if (typeOfReps == 'secs' || typeOfReps == 'min') {
      isTimed = true;
    } else {
      isTimed = false;
    }
    if (typeOfReps == 'failure') {
      isFailure = true;
    } else {
      isFailure = false;
    }
    if (typeOfReps == 'min') {
      reps = reps * 60;
    }
    if (restUnit == 'min') {
      rest = rest * 60;
    }
  }

  List<DropdownMenuItem> dropdownMenuRestUnits() {
    List<DropdownMenuItem> items = [];
    for (String restUnit in kRestUnits) {
      items.add(
        DropdownMenuItem(
          value: restUnit,
          child: Text(restUnit),
        ),
      );
    }
    return items;
  }
}
