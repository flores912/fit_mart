import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/create_new_plan_add_workouts_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNewPlanStepDescriptionScreen extends StatefulWidget {
  static const String title = 'Step 1 of 5: Description';
  static const String id = 'create_new_plan_step_description_screen';

  @override
  CreateNewPlanStepDescriptionScreenState createState() =>
      CreateNewPlanStepDescriptionScreenState();
}

class CreateNewPlanStepDescriptionScreenState
    extends State<CreateNewPlanStepDescriptionScreen> {
  String _categoryValue;
  String _locationValue;
  String _skillLevelValue;

  String title;

  String description;

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
              if ( //TODO : add a minimum string length
                  title.isNotEmpty &&
                      title.contains(
                          new RegExp(r'[A-Z]', caseSensitive: false)) &&
                      description.isNotEmpty &&
                      description.contains(
                          new RegExp(r'[A-Z]', caseSensitive: false)) &&
                      _categoryValue.toString().isNotEmpty &&
                      _locationValue.toString().isNotEmpty &&
                      _skillLevelValue.toString().isNotEmpty) {
                FirestoreProvider _firestoreProvider = FirestoreProvider();
                _firestoreProvider
                    .createNewWorkoutPlan(
                        FirebaseAuth.instance.currentUser.uid,
                        FirebaseAuth.instance.currentUser.displayName,
                        title,
                        description,
                        _categoryValue.toString(),
                        _locationValue.toString(),
                        _skillLevelValue.toString())
                    .whenComplete(() => Navigator.pushNamed(
                        context, CreateNewPlanAddWorkoutsScreen.id));
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
        title: Text(CreateNewPlanStepDescriptionScreen.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextForm(
                textInputType: TextInputType.text,
                labelText: 'Title',
                obscureText: false,
                maxLength: 60,
                maxLines: 2,
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextForm(
                  textInputType: TextInputType.text,
                  maxLength: 300,
                  maxLines: 7,
                  labelText: 'Description',
                  obscureText: false,
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  }),
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
    );
  }
}
