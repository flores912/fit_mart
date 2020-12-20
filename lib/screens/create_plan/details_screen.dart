import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/blocs/create_plan/details_screen_bloc.dart';
import 'package:fit_mart/blocs/create_plan/details_screen_bloc_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/categories_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  static const String title = 'Step 1 of 7: Details';
  static const String id = 'details_screen';

  final bool isEdit;
  final String workoutPlanUid;
  final String workoutPlanTitle;
  final String description;

  const DetailsScreen(
      {Key key,
      this.isEdit,
      this.workoutPlanTitle,
      this.description,
      this.workoutPlanUid})
      : super(key: key);

  @override
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  String title;

  String description;

  String workoutPlanUid;

  DetailsScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = DetailsScreenBlocProvider.of(context);
    title = widget.workoutPlanTitle;
    description = widget.description;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //new line
      appBar: AppBar(
        actions: [
          widget.isEdit == true
              ? FlatButton(
                  onPressed: () {
                    if (_bloc.isFieldsValid(title, description) == true) {
                      if (_bloc.isFieldsValid(title, description) == true) {
                        _bloc
                            .updateWorkoutPlanDetails(
                                widget.workoutPlanUid, title, description)
                            .whenComplete(
                              () => Navigator.pop(context),
                            );
                      } else {
                        //fix fields
                      }
                    } else {
                      //fix fields
                    }
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : FlatButton(
                  onPressed: () {
                    _bloc
                        .createNewWorkoutPlan(title, description)
                        .then((value) => workoutPlanUid = value.id)
                        .whenComplete(
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesScreen(
                                workoutPlanUid: workoutPlanUid,
                              ),
                            ),
                          ),
                        );
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
        ],
        title: Text(DetailsScreen.title),
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
                child: CustomTextForm(
                  textInputType: TextInputType.text,
                  labelText: 'Create a title',
                  obscureText: false,
                  maxLength: 60,
                  maxLines: 1,
                  initialValue: widget.workoutPlanTitle,
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
                    maxLines: 4,
                    labelText: 'Add a description',
                    initialValue: widget.description,
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
