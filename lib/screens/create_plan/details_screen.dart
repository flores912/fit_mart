import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/categories_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  static const String title = 'Step 1 of 7: Details';
  static const String id = 'details_screen';

  final bool isEdit;
  final String workoutPlanTitle;
  final String description;

  const DetailsScreen(
      {Key key, this.isEdit, this.workoutPlanTitle, this.description})
      : super(key: key);

  @override
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  String title;

  String description;

  String docId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //new line
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
                          new RegExp(r'[A-Z]', caseSensitive: false))) {
                FirestoreProvider _firestoreProvider = FirestoreProvider();
                _firestoreProvider
                    .createNewWorkoutPlan(
                  FirebaseAuth.instance.currentUser.uid,
                  FirebaseAuth.instance.currentUser.displayName,
                  title,
                  description,
                )
                    .then((doc) {
                  docId = doc.id;
                }).whenComplete(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesScreen(
                        workoutPlanUid: docId,
                      ),
                    ),
                  );
                });
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
