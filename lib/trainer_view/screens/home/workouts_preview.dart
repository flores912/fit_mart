import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/week_card.dart';
import 'package:fit_mart/custom_widgets/workout_card.dart';
import 'package:fit_mart/models/week.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plan_workouts_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutsPreview extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutsPreview({Key key, this.workoutPlan}) : super(key: key);
  @override
  _WorkoutsPreviewState createState() => _WorkoutsPreviewState();
}

class _WorkoutsPreviewState extends State<WorkoutsPreview> {
  PlanWorkoutsBloc _bloc = PlanWorkoutsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: weeksListView())),
      ),
    );
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

  Widget weeksListView() {
    return StreamBuilder(
      stream: _bloc.getWeeks(widget.workoutPlan.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Week> weeksList = buildWeeksList(snapshot.data.docs);
          return ListView.builder(
            itemCount: weeksList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: WeekCard(
                    week: weeksList[index].week,
                    workoutList: workoutsListView(weeksList[index].uid),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<Workout> buildWorkoutsList(List<DocumentSnapshot> docList) {
    List<Workout> workoutsList = [];
    docList.forEach((element) {
      Workout workout = Workout(
          weekUid: element.get('weekUid'),
          workoutName: element.get('workoutName'),
          exercises: element.get('exercises'),
          day: element.get('day'),
          uid: element.id);
      workoutsList.add(workout);
    });
    return workoutsList;
  }

  Widget workoutsListView(String weekUid) {
    return StreamBuilder(
        stream: _bloc.getWorkouts(widget.workoutPlan.uid, weekUid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Workout> workoutsList = buildWorkoutsList(
              snapshot.data.docs,
            );
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 56),
              itemCount: workoutsList.length,
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return WorkoutCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutSession(
                                workoutName: workoutsList[index].workoutName,
                                workoutUid: workoutsList[index].uid,
                                weekUid: workoutsList[index].weekUid,
                                workoutPlanUid: widget.workoutPlan.uid,
                              )),
                    );
                  },
                  day: workoutsList[index].day,
                  workoutName: workoutsList[index].workoutName,
                  exercises: workoutsList[index].exercises,
                );
              },
            );
          } else {
            return Container(
                height: 48,
                width: 48,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
