import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/blocs/my_workout_plans_bloc.dart';
import 'package:fit_mart/blocs/my_workout_plans_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/my_workout_plan.dart';
import 'package:fit_mart/screens/my_plan_workouts_screen.dart';
import 'package:fit_mart/widgets/my_workout_plan_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPlansScreen extends StatefulWidget {
  static const String title = 'My Plans';

  @override
  MyPlansScreenState createState() => MyPlansScreenState();
}

class MyPlansScreenState extends State<MyPlansScreen> {
  MyWorkoutPlansBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = MyWorkoutPlansBlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.myWorkoutPlansQuerySnapshot('flores@gmail.com'),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.docs;
            List<MyWorkoutPlan> myWorkoutPlansList =
                _bloc.convertToMyWorkoutPlanList(docList: docs);

            if (myWorkoutPlansList.isNotEmpty) {
              return buildList(myWorkoutPlansList);
            } else {
              return Center(child: Text('No workout plans'));
            }
          } else {
            return Center(child: Text('No workout plans'));
          }
        });
  }

  ListView buildList(List<MyWorkoutPlan> myWorkoutPlansList) {
    return ListView.builder(
      itemCount: myWorkoutPlansList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPlanWorkoutsScreen(
                          myWorkoutPlan: myWorkoutPlansList[index],
                        )));
          },
          child: MyWorkoutPlanWidget(
            title: myWorkoutPlansList[index].title,
            trainer: myWorkoutPlansList[index].trainer,
            imageUrl: myWorkoutPlansList[index].imageUrl,
            progressValue: myWorkoutPlansList[index].progress,
          ),
        );
      },
    );
  }
}
