import 'package:fit_mart/blocs/create_plan/plan_length_screen_bloc.dart';
import 'package:fit_mart/blocs/create_plan/plan_length_screen_bloc_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/workouts_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlanLengthScreen extends StatefulWidget {
  static const String title = ' Step 3 of 7: Length';
  static const String id = 'plan_length_screen';

  final String workoutPlanUid;
  final int length;
  final bool isEdit;

  const PlanLengthScreen(
      {Key key, this.workoutPlanUid, this.length, this.isEdit})
      : super(key: key);

  @override
  PlanLengthScreenState createState() => PlanLengthScreenState();
}

class PlanLengthScreenState extends State<PlanLengthScreen> {
  PlansLengthScreenBloc _bloc;

  String days;
  bool isProgressBarShowing = false;

  LinearProgressIndicator showProgressBar() {
    setState(() {
      isProgressBarShowing = true;
    });
    return LinearProgressIndicator();
  }

  @override
  void initState() {
    if (widget.length != null) {
      days = widget.length.toString();
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = PlanLengthScreenBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isProgressBarShowing,
      child: Scaffold(
        appBar: AppBar(
          title: Text(PlanLengthScreen.title),
          centerTitle: true,
          actions: [
            widget.isEdit != true
                ? FlatButton(
                    onPressed: () {
                      _bloc
                          .addDaysToPlan(int.parse(days), widget.workoutPlanUid)
                          .whenComplete(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkoutsScreen(
                                      workoutPlanUid: widget.workoutPlanUid,
                                    )));
                      });
                    },
                    textColor: Colors.white,
                    child: Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                : FlatButton(
                    onPressed: () {
                      _bloc.addDaysToPlan(
                          int.parse(days), widget.workoutPlanUid);
                    },
                    textColor: Colors.white,
                    child: Text(
                      'Save',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isProgressBarShowing == true
                      ? showProgressBar()
                      : Container(
                          height: 0,
                        ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 75,
                          child: CustomTextForm(
                            textInputType: TextInputType.number,
                            textInputFormatter: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            labelText: 'Length',
                            obscureText: false,
                            initialValue: days,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
