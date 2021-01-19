import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/trainer_view/blocs/edit_set_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../constants.dart';

class EditSetCollection extends StatefulWidget {
  final String exerciseUid;
  final int numberOfSet;
  final bool isEdit;
  final Set set;
  final String setUid;

  const EditSetCollection(
      {Key key,
      this.exerciseUid,
      this.numberOfSet,
      this.isEdit,
      this.set,
      this.setUid})
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

  bool isSetInMin;

  bool isRestInMin;
  @override
  void initState() {
    getEditSetValues();
    super.initState();
  }

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
                  EasyLoading.show();
                  checkTypesOfValues();
                  if (widget.isEdit == true) {
                    updateSet();
                  } else {
                    addNewSet();
                  }
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
                        child: Text(kSet + ' ' + widget.numberOfSet.toString()),
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

  void updateSet() {
    print(widget.setUid);
    _bloc
        .updateSetCollection(
            widget.exerciseUid,
            widget.set.setUid,
            widget.set.set,
            reps,
            rest,
            isTimed,
            isFailure,
            isSetInMin,
            isRestInMin)
        .whenComplete(() => EasyLoading.dismiss())
        .whenComplete(() => Navigator.pop(context));
  }

  void addNewSet() {
    _bloc
        .addNewSetCollection(widget.exerciseUid, widget.numberOfSet, reps, rest,
            isTimed, isFailure, isSetInMin, isRestInMin)
        .whenComplete(() => _bloc.updateExerciseDetailsNumberOfSetsCollection(
            widget.numberOfSet, widget.exerciseUid))
        .whenComplete(() => EasyLoading.dismiss())
        .whenComplete(() => Navigator.pop(context));
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
      reps = null;
    } else {
      isFailure = false;
    }
    if (typeOfReps == 'min') {
      isSetInMin = true;
      reps = reps * 60;
    } else {
      isSetInMin = false;
    }
    if (restUnit == 'min') {
      isRestInMin = true;
      rest = rest * 60;
    } else {
      isRestInMin = false;
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

  void getEditSetValues() {
    if (widget.isEdit == true) {
      reps = widget.set.reps;
      rest = widget.set.rest;
      isTimed = widget.set.isTimed;
      isFailure = widget.set.isFailure;
      if (widget.set.isRestInMin == true) {
        restUnit = 'min';
        rest = rest ~/ 60;
      }
      if (widget.set.isSetInMin == true) {
        typeOfReps = 'min';
        reps = reps ~/ 60;
      } else if (widget.set.isSetInMin == false && widget.set.isTimed == true) {
        typeOfReps = 'secs';
      } else if (widget.set.isFailure) {
        typeOfReps = 'failure';
      } else {
        typeOfReps = 'reps';
      }
    }
  }
}
