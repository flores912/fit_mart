import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/week_card.dart';
import 'package:fit_mart/custom_widgets/workout_card.dart';
import 'package:fit_mart/trainer_view/blocs/plan_workouts_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/workout_exercises.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/week.dart';
import '../../../models/workout.dart';

class PlanWorkouts extends StatefulWidget {
  final String workoutPlanUid;

  const PlanWorkouts({Key key, this.workoutPlanUid}) : super(key: key);
  @override
  _PlanWorkoutsState createState() => _PlanWorkoutsState();
}

class _PlanWorkoutsState extends State<PlanWorkouts> {
  PlanWorkoutsBloc _bloc = PlanWorkoutsBloc();

  ScrollController _scrollController = ScrollController();
  String workoutPlanUid;

  int numberOfWeeks;

  bool isCopyMode;

  Workout workoutBeingCopied;
  List<Workout> workoutsList = [];
  List<String> copyWorkoutsList = []; //uids of workouts to copy

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
          _bloc.createNewWeek(workoutPlanUid, numberOfWeeks + 1).whenComplete(
                () => _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 1),
                ),
              );
        },
        label: Text(kAddWeek),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: weeksListView())),
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
            controller: _scrollController,
            itemCount: weeksList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width - 24,
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
            workoutsList = buildWorkoutsList(
              snapshot.data.docs,
            );
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: workoutsList.length,
              itemBuilder: (context, index) {
                _bloc.updateWorkoutExerciseNumber(
                    workoutPlanUid, weekUid, workoutsList[index].uid);
                return WorkoutCard(
                  checkBoxOnChanged: (value) {
                    if (copyWorkoutsList.contains(workoutsList[index].uid) ==
                        false) {
                      setState(() {
                        copyWorkoutsList.add(workoutsList[index].uid);
                      });
                    } else {
                      setState(() {
                        copyWorkoutsList.remove(workoutsList[index].uid);
                      });
                    }
                  },
                  isParentCheckbox: workoutBeingCopied != null
                      ? workoutBeingCopied.uid == workoutsList[index].uid
                      : false,
                  isSelected: copyWorkoutsList
                              .contains(workoutsList[index].uid) ==
                          true
                      ? true
                      : false, //check if workout is on the list if it i s its checked
                  parentCheckBoxOnChanged: (value) {
                    setState(() {
                      workoutBeingCopied = null;
                      copyWorkoutsList = [];
                      isCopyMode = false;
                    });
                  },
                  isOnCopyMode: isCopyMode,
                  exercises: workoutsList[index].exercises,
                  workoutName: workoutsList[index].workoutName,
                  day: workoutsList[index].day,
                  onTap: () {
                    //edit exercises screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutExercises(
                          workoutPlanUid: workoutPlanUid,
                          weekUid: weekUid,
                          workoutUid: workoutsList[index].uid,
                        ),
                      ),
                    );
                  },
                  more: PopupMenuButton(
                      child: Icon(Icons.more_vert),
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            //Edit workout name screen
                            break;

                          case 2:
                            //show copy checkboxes

                            setState(() {
                              isCopyMode = true;
                              workoutBeingCopied = workoutsList[index];
                            });
                            break;
                          case 3:
                            //delete
                            break;
                          case 4:
                            //swap
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          kWorkoutCardPopUpMenuList),
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
          weekUid: element.get('weekUid'),
          workoutName: element.get('workoutName'),
          exercises: element.get('exercises'),
          day: element.get('day'),
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

  copyWorkouts() {
    workoutsList.forEach((element) async {
      if (copyWorkoutsList.contains(element.uid)) {
        await _bloc.copyWorkout(workoutPlanUid, workoutBeingCopied, element);
      }
    });
  }
}
