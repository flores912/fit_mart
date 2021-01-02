import 'package:fit_mart/trainer_view/blocs/plan_details_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_workouts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_mart/constants.dart';

class PlanDetails extends StatefulWidget {
  final String workoutPlanUid;

  const PlanDetails({Key key, this.workoutPlanUid}) : super(key: key);
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
  void initState() {
    workoutPlanUid = widget.workoutPlanUid;
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
              if (isEdit == true) {
                //don't create a new workout and only update fields
              } else {
                //is new so create a new one

                //check if its free to add details to DB accordingly
                checkIfFree();
                //validate fields before creating new plan
                if (_formKey.currentState.validate()) {
                  _bloc
                      .createNewPlan(title, description, price, isFree)
                      .then((value) {
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
            },
          )
        ],
      ),
      body: Padding(
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
                maxLines: 6,
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
    } else {
      isEdit = false;
      //set initial price for dropdown menu
      price = kFree;
    }
  }

  getValues() {
    if (isEdit == true) {
      _bloc.getPlanDetails(workoutPlanUid).then((value) {
        title = value.get('title');
        description = value.get('price');
        isFree = value.get('isFree');
        if (isFree == true) {
          price = kFree;
        }
      });
    } else {
      //set default price for new workout - free
      price = kPriceList.first;
    }
  }
}
