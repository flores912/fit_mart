import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plan_details_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_workouts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_mart/constants.dart';

class PlanDetails extends StatefulWidget {
  final String workoutPlanUid;
  final WorkoutPlan workoutPlan;
  const PlanDetails({
    Key key,
    this.workoutPlanUid,
    this.workoutPlan,
  }) : super(key: key);
  @override
  _PlanDetailsState createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  PlanDetailsBloc _bloc = PlanDetailsBloc();

  String title;

  String description;

  dynamic price;

  bool isFree;

  final _formKey = GlobalKey<FormState>();

  String workoutPlanUid;
  bool isEdit;
  bool isBackPressed;
  @override
  initState() {
    workoutPlanUid = widget.workoutPlanUid;
    title = widget.workoutPlan.title;
    isFree = widget.workoutPlan.isFree;
    description = widget.workoutPlan.description;
    price = widget.workoutPlan.price;
    checkIfEdit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text(isBackPressed == true || workoutPlanUid == null
                ? kNext
                : kSave),
            onPressed: () {
              //check if its free to add details to DB accordingly
              checkIfFree();

              if (isEdit == true) {
                //don't create a new workout and only update fields
                updateNewPlan();
              } else {
                //is new so create a new one
                createNewPlan();

                //validate fields before creating new plan

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
              children: [
                TextFormField(
                  initialValue: title,
                  validator: (value) {
                    title = value;
                    if (title.isEmpty) {
                      return kRequired;
                    }
                    return null;
                  },
                  maxLines: 1,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(
                    labelText: kTitle + '*',
                    alignLabelWithHint: true,
                  ),
                ),
                TextFormField(
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
                DropdownButton(
                  value: price,
                  onChanged: (value) {
                    setState(() {
                      price = value;
                    });
                  },
                  items: dropdownMenuItems(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> dropdownMenuItems() {
    List<DropdownMenuItem> items = List();
    for (dynamic price in kPriceList) {
      items.add(
        DropdownMenuItem(
          value: price,
          child: Text('\$' + price.toString()),
        ),
      );
    }
    return items;
  }
  //LOGIC
  //TODO:PUT ALL THIS LOGIN IN BLOC

  checkIfFree() {
    if (price == kFree) {
      isFree = true;
      price = null;
    } else {
      isFree = false;
    }
  }

  checkIfEdit() {
    if (workoutPlanUid != null) {
      isEdit = true;
      if (price == null) {
        price = kFree;
      }
    } else {
      isEdit = false;
      //set initial price for dropdown menu
      price = kFree;
    }
  }

  createNewPlan() {
    if (_formKey.currentState.validate()) {
      _bloc
          .createNewPlan(title, description, price, isFree)
          .then((value) async {
        //this will stop from adding a new workout plan if user presses back button and will update instead
        workoutPlanUid = value.id;
        isEdit = true;
        isBackPressed = true;
      }).whenComplete(
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanWorkouts(
              workoutPlanUid: workoutPlanUid,
            ),
          ),
        ),
      );
    }
  }

  updateNewPlan() {
    if (_formKey.currentState.validate()) {
      _bloc
          .updatePlanDetails(workoutPlanUid, title, description, price, isFree)
          .whenComplete(() {
        //this will stop from adding a new workout plan if user presses back button and will update instead
        isEdit = true;
        isBackPressed = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanWorkouts(
              workoutPlanUid: workoutPlanUid,
            ),
          ),
        );
      });
    }
  }
}
