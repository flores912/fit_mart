import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/week_card.dart';
import 'package:fit_mart/custom_widgets/workout_card.dart';
import 'package:fit_mart/trainer_view/blocs/plan_workouts_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../week.dart';
import '../../../workout.dart';

class PlanWorkouts extends StatefulWidget {
  final String workoutPlanUid;

  const PlanWorkouts({Key key, this.workoutPlanUid}) : super(key: key);
  @override
  _PlanWorkoutsState createState() => _PlanWorkoutsState();
}

class _PlanWorkoutsState extends State<PlanWorkouts> {
  PlanWorkoutsBloc _bloc = PlanWorkoutsBloc();

  String workoutPlanUid;

  int numberOfWeeks;

  @override
  void initState() {
    workoutPlanUid = widget.workoutPlanUid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _bloc.createNewWeek(workoutPlanUid, numberOfWeeks + 1);
        },
        label: Text(kAddWeek),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: weeksListView()),
        ],
      ),
    );
  }

  Widget weeksListView() {
    return StreamBuilder(
      stream: _bloc.getWeeks(workoutPlanUid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Week> weeksList = buildWeeksList(snapshot.data.docs);
          numberOfWeeks = weeksList.length;
          return ListView.builder(
            itemCount: weeksList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: WeekCard(
                  week: weeksList[index].week,
                  workoutList: workoutsListView(weeksList[index].uid),
                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget workoutsListView(String weekUid) {
    return StreamBuilder(
        stream: _bloc.getWorkouts(workoutPlanUid, weekUid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Workout> workoutsList = buildWorkoutsList(
              snapshot.data.docs,
            );
            return ListView.builder(
              itemCount: workoutsList.length,
              itemBuilder: (context, index) {
                return WorkoutCard(
                  exercises: workoutsList[index].exercises,
                  workoutName: workoutsList[index].workoutName,
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  List<Workout> buildWorkoutsList(List<DocumentSnapshot> docList) {
    List<Workout> workoutsList = [];
    docList.forEach((element) {
      Workout workout = Workout(
          workoutName: element.get('workoutName'),
          exercises: element.get('exercises'),
          uid: element.id);
      workoutsList.add(workout);
    });
    return workoutsList;
  }

  List<Week> buildWeeksList(
    List<DocumentSnapshot> docList,
  ) {
    List<Week> weeksList = [];
    docList.forEach((element) {
      Week week = Week(week: element.get('week'), uid: element.id);
      weeksList.add(week);
    });
    return weeksList;
  }
}
