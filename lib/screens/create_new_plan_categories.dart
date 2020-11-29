import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/create_new_plan_add_workouts_screen.dart';
import 'package:fit_mart/screens/create_new_plan_length_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CreateNewPlanCategoriesScreen extends StatefulWidget {
  static const String title = 'Step 2 of 7: Categories';
  static const String id = 'create_new_plan_step_categories_screen';

  final String workoutPlanUid;

  @override
  CreateNewPlanCategoriesScreenState createState() =>
      CreateNewPlanCategoriesScreenState();

  const CreateNewPlanCategoriesScreen({this.workoutPlanUid});
}

class CreateNewPlanCategoriesScreenState
    extends State<CreateNewPlanCategoriesScreen> {
  String _categoryValue;
  String _locationValue;
  String _skillLevelValue;

  List<String> _categoryItems = [
    'Weightlifting',
    'Bodyweight',
    'Military',
    'Sports',
    'Bodybuilding',
    'Strength',
  ];
  List<String> _locationItems = [
    'Gym',
    'Home',
    'Outdoors',
  ];

  List<String> _skillLevelItems = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Any',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false, //new line
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              print(widget.workoutPlanUid);
              FirestoreProvider firestoreProvider = FirestoreProvider();
              if (_categoryValue.isNotEmpty &&
                  _locationValue.isNotEmpty &&
                  _skillLevelValue.isNotEmpty) {
                firestoreProvider
                    .updateWorkoutPlanCategoriesStep(widget.workoutPlanUid,
                        _categoryValue, _locationValue, _skillLevelValue)
                    .whenComplete(() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateNewPlanLengthScreen(
                                  workoutPlanUid: widget.workoutPlanUid,
                                ))));
              } else {
                //complete required fields
              }
            },
            textColor: Colors.white,
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
        title: Text(CreateNewPlanCategoriesScreen.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: kPrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  )),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _categoryValue,
                        onChanged: (newValue) {
                          setState(() {
                            _categoryValue = newValue;
                          });
                        },
                        hint: Text('Select Category'),
                        items: _categoryItems.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: kPrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  )),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _locationValue,
                        onChanged: (newValue) {
                          setState(() {
                            _locationValue = newValue;
                          });
                        },
                        hint: Text('Select Location'),
                        items: _locationItems.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: kPrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  )),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _skillLevelValue,
                        onChanged: (newValue) {
                          setState(() {
                            _skillLevelValue = newValue;
                          });
                        },
                        hint: Text('Select Skill Level'),
                        items: _skillLevelItems.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
