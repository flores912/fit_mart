import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/create_new_plan_add_workouts_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateNewPlanLengthScreen extends StatefulWidget {
  static const String title = ' Step 3 of 7: Length';
  static const String id = 'create_new_plan_length_screen';

  final String workoutPlanUid;

  const CreateNewPlanLengthScreen({Key key, this.workoutPlanUid})
      : super(key: key);

  @override
  CreateNewPlanLengthScreenState createState() =>
      CreateNewPlanLengthScreenState();
}

class CreateNewPlanLengthScreenState extends State<CreateNewPlanLengthScreen> {
  String days;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreateNewPlanLengthScreen.title),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              print(widget.workoutPlanUid);
              FirestoreProvider firestoreProvider = FirestoreProvider();
              firestoreProvider
                  .addDaysToPlan(int.parse(days), widget.workoutPlanUid)
                  .whenComplete(() => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNewPlanAddWorkoutsScreen(
                                workoutPlanUid: widget.workoutPlanUid,
                              ))));
            },
            textColor: Colors.white,
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 75,
                  child: CustomTextForm(
                    textInputType: TextInputType.number,
                    textInputFormatter: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    labelText: 'Length',
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        days = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Days',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
