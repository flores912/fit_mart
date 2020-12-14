import 'package:fit_mart/blocs/create_plan/categories_screen_bloc.dart';
import 'package:fit_mart/blocs/create_plan/categories_screen_bloc_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/create_plan/plan_length_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class CategoriesScreen extends StatefulWidget {
  static const String title = 'Step 2 of 7: Categories';
  static const String id = 'categories_screen';

  final String workoutPlanUid;
  final String category;
  final String location;
  final String skillLevel;
  final bool isEdit;

  @override
  CategoriesScreenState createState() => CategoriesScreenState();

  const CategoriesScreen(
      {this.workoutPlanUid,
      this.category,
      this.location,
      this.skillLevel,
      this.isEdit});
}

class CategoriesScreenState extends State<CategoriesScreen> {
  CategoriesScreenBloc _bloc;
  String _category;
  String _location;
  String _skillLevel;

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
  void initState() {
    _category = widget.category;
    _location = widget.location;
    _skillLevel = widget.skillLevel;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = CategoriesScreenBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false, //new line
      appBar: AppBar(
        actions: [
          widget.isEdit == true
              ? FlatButton(
                  onPressed: () {
                    if (_bloc.isFieldsValid(
                          _category,
                          _location,
                          _skillLevel,
                        ) ==
                        true) {
                      _bloc.updateWorkoutPlanCategories(
                        widget.workoutPlanUid,
                        _category,
                        _location,
                        _skillLevel,
                      );
                    } else {
                      //fix fields
                    }
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ))
              : FlatButton(
                  onPressed: () {
                    if (_bloc.isFieldsValid(
                          _category,
                          _location,
                          _skillLevel,
                        ) ==
                        true) {
                      _bloc
                          .updateWorkoutPlanCategories(
                            widget.workoutPlanUid,
                            _category,
                            _location,
                            _skillLevel,
                          )
                          .whenComplete(
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanLengthScreen(
                                  workoutPlanUid: widget.workoutPlanUid,
                                  isEdit: false,
                                ),
                              ),
                            ),
                          );
                    } else {
                      //fix fields
                    }
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
        ],
        title: Text(CategoriesScreen.title),
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
                        value: _category,
                        onChanged: (newValue) {
                          setState(() {
                            _category = newValue;
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
                        value: _location,
                        onChanged: (newValue) {
                          setState(() {
                            _location = newValue;
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
                        value: _skillLevel,
                        onChanged: (newValue) {
                          setState(() {
                            _skillLevel = newValue;
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
