import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plan_details_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_workouts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_mart/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PlanDetails extends StatefulWidget {
  final String workoutPlanUid;
  final bool isEdit;
  final WorkoutPlan workoutPlan;
  const PlanDetails({
    Key key,
    this.workoutPlanUid,
    this.workoutPlan,
    this.isEdit,
  }) : super(key: key);
  @override
  _PlanDetailsState createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  PlanDetailsBloc _bloc = PlanDetailsBloc();

  String title;

  String description;

  //default values
  String type = kTypes.first;
  String location = kLocations.first;
  String level = kLevels.first;

  final _formKey = GlobalKey<FormState>();

  String workoutPlanUid;
  bool isBackPressed;

  @override
  initState() {
    workoutPlanUid = widget.workoutPlanUid;
    if (workoutPlanUid != null) {
      title = widget.workoutPlan.title;
      description = widget.workoutPlan.description;
      type = widget.workoutPlan.type;
      level = widget.workoutPlan.level;
      location = widget.workoutPlan.location;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Details'),
        actions: [
          FlatButton(
            child: Text(isBackPressed == true || workoutPlanUid == null
                ? kNext
                : kSave),
            onPressed: () {
              if (isBackPressed == true || widget.isEdit == true) {
                //don't create a new workout and only update fields
                updateNewPlan();
              } else {
                //is new so create a new one
                createNewPlan();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: title,
                    validator: (value) {
                      title = value;
                      if (title.isEmpty) {
                        return kRequired;
                      }
                      return null;
                    },
                    maxLines: 1,
                    maxLength: 70,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                      labelText: kTitle + '*',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: description,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: InputDecoration(
                      labelText: kDescription + kOptional,
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Training Type',
                        style: TextStyle(fontSize: 22),
                      ),
                      DropdownButton(
                        value: type,
                        onChanged: (value) {
                          setState(() {
                            type = value;
                          });
                        },
                        items: dropdownMenuTypes(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level',
                        style: TextStyle(fontSize: 22),
                      ),
                      DropdownButton(
                        value: level,
                        onChanged: (value) {
                          setState(() {
                            level = value;
                          });
                        },
                        items: dropdownMenuLevels(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(fontSize: 22),
                      ),
                      DropdownButton(
                        value: location,
                        onChanged: (value) {
                          setState(() {
                            location = value;
                          });
                        },
                        items: dropdownMenuLocations(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> dropdownMenuTypes() {
    List<DropdownMenuItem> items = [];
    for (String type in kTypes) {
      items.add(
        DropdownMenuItem(
          value: type,
          child: Text(type),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem> dropdownMenuLevels() {
    List<DropdownMenuItem> items = [];
    for (String level in kLevels) {
      items.add(
        DropdownMenuItem(
          value: level,
          child: Text(level),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem> dropdownMenuLocations() {
    List<DropdownMenuItem> items = [];
    for (String location in kLocations) {
      items.add(
        DropdownMenuItem(
          value: location,
          child: Text(location),
        ),
      );
    }
    return items;
  }

  //LOGIC
  //TODO:PUT ALL THIS LOGIc IN BLOC

  createNewPlan() {
    if (_formKey.currentState.validate()) {
      EasyLoading.show();
      _bloc
          .createNewPlan(title, description, type, location, level)
          .then((value) async {
        //this will stop from adding a new workout plan if user presses back button and will update instead
        workoutPlanUid = value.id;
        isBackPressed = true;
      }).whenComplete(() => EasyLoading.dismiss().whenComplete(() => Get.to(
                PlanWorkouts(
                  workoutPlanUid: workoutPlanUid,
                ),
              )));
    }
  }

  updateNewPlan() {
    if (_formKey.currentState.validate()) {
      EasyLoading.show();
      _bloc
          .updatePlanDetails(
              workoutPlanUid, title, description, type, location, level)
          .whenComplete(() {
        if (widget.isEdit == true) {
          EasyLoading.dismiss().whenComplete(() => Navigator.pop(context));
        } else {
          //this will stop from adding a new workout plan if user presses back button and will update instead

          EasyLoading.dismiss().whenComplete(() => Get.to(PlanWorkouts(
                workoutPlanUid: workoutPlanUid,
              )));
        }
      });
    }
  }
}
