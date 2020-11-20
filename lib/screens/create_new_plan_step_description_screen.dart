import 'dart:ui';

import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/create_new_plan_pricing.dart';
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
  int _categoryValue;
  int _locationValue;
  int _skillLevelValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false, //new line
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateNewPlanPricingScreen.id);
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextForm(
                textInputType: TextInputType.multiline,
                maxLength: 300,
                maxLines: 7,
                labelText: 'Description',
                obscureText: false,
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
                    child: DropdownButton(
                        isExpanded: true,
                        value: _categoryValue,
                        hint: Text('Select Category'),
                        items: [
                          DropdownMenuItem(
                            child: Text('Weightlifting',
                                textAlign: TextAlign.center),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child:
                                Text('Bodyweight', textAlign: TextAlign.center),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text('HIIT Training',
                                textAlign: TextAlign.center),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text('Strength Training',
                                textAlign: TextAlign.center),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Text('Sports Training',
                                textAlign: TextAlign.center),
                            value: 5,
                          ),
                          DropdownMenuItem(
                            child: Text('Mobility Training',
                                textAlign: TextAlign.center),
                            value: 6,
                          ),
                          DropdownMenuItem(
                            child: Text('Military Training',
                                textAlign: TextAlign.center),
                            value: 7,
                          ),
                          DropdownMenuItem(
                            child: Text('Bodybuilding',
                                textAlign: TextAlign.center),
                            value: 8,
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _categoryValue = value;
                          });
                        }),
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
                    child: DropdownButton(
                        isExpanded: true,
                        value: _locationValue,
                        hint: Text('Select Location'),
                        items: [
                          DropdownMenuItem(
                            child: Text('Home', textAlign: TextAlign.center),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text('Gym', textAlign: TextAlign.center),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text('Outdoor', textAlign: TextAlign.center),
                            value: 3,
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _locationValue = value;
                          });
                        }),
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
                    child: DropdownButton(
                        isExpanded: true,
                        value: _skillLevelValue,
                        hint: Text('Select Skill Level'),
                        items: [
                          DropdownMenuItem(
                            child:
                                Text('Beginner', textAlign: TextAlign.center),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text('Intermediate',
                                textAlign: TextAlign.center),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child:
                                Text('Advanced', textAlign: TextAlign.center),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text('Any', textAlign: TextAlign.center),
                            value: 4,
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _skillLevelValue = value;
                          });
                        }),
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
