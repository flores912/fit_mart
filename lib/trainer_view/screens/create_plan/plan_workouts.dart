import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/week_card.dart';
import 'package:fit_mart/custom_widgets/workout_card.dart';
import 'package:fit_mart/trainer_view/blocs/plan_workouts_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/cover_photo.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_workout_name.dart';
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

  bool isWorkoutCopyMode;
  bool isWeekCopyMode;

  Workout workoutBeingCopied;
  Week weekBeingCopied;

  List<Workout> copyWorkoutsList = [];
  List<Week> copyWeeksList = [];

  List<Week> weeksList = [];

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
          _bloc
              .createNewWeek(workoutPlanUid, weeksList.length + 1)
              .whenComplete(
                () => _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 1),
                ),
              )
              .whenComplete(() =>
                  _bloc.updateNumberOfWeeks(workoutPlanUid, weeksList.length));
        },
        label: Text(kAddWeek),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: isWorkoutCopyMode == true || isWeekCopyMode == true
          ? copyModeAppBar()
          : AppBar(
              actions: [
                FlatButton(
                  child: Text(kNext),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoverPhoto(
                          workoutPlanUid: workoutPlanUid,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
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
          weeksList = buildWeeksList(snapshot.data.docs);
          return ListView.builder(
            controller: _scrollController,
            itemCount: weeksList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 24,
                  child: WeekCard(
                    checkBoxOnChanged: (value) {
                      if (checkIfWeekIsAddedToCopyList(weeksList[index]) ==
                          true) {
                        //remove workout from  copy list
                        setState(() {
                          copyWeeksList.remove(copyWeeksList.firstWhere(
                              (weekToCheck) =>
                                  weekToCheck.uid == weeksList[index].uid));
                        });
                      } else {
                        //add workout to copy list
                        setState(() {
                          copyWeeksList.add(weeksList[index]);
                        });
                      }
                    },
                    parentCheckBoxOnChanged: (value) {
                      setState(() {
                        turnWeekCopyModeOff();
                      });
                    },
                    isSelected: checkIfWeekIsAddedToCopyList(weeksList[index]),
                    isParentCheckbox: weekBeingCopied != null
                        ? weekBeingCopied.uid == weeksList[index].uid
                        : false,
                    isOnCopyMode: isWeekCopyMode,
                    week: weeksList[index].week,
                    workoutList: workoutsListView(weeksList[index].uid),
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
                                isWeekCopyMode = true;
                                weekBeingCopied = weeksList[index];
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
                  ),
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
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: workoutsList.length,
              itemBuilder: (context, index) {
                return WorkoutCard(
                  checkBoxOnChanged: (value) {
                    if (checkIfWorkoutIsAddedToCopyList(workoutsList[index]) ==
                        true) {
                      //remove workout from  copy list
                      setState(() {
                        copyWorkoutsList.remove(copyWorkoutsList.firstWhere(
                            (workoutToCheck) =>
                                workoutToCheck.uid == workoutsList[index].uid));
                      });
                    } else {
                      //add workout to copy list
                      setState(() {
                        copyWorkoutsList.add(workoutsList[index]);
                      });
                    }
                  },
                  isParentCheckbox: workoutBeingCopied != null
                      ? workoutBeingCopied.uid == workoutsList[index].uid
                      : false,
                  isSelected: checkIfWorkoutIsAddedToCopyList(workoutsList[
                      index]), //check if workout is on the list if it i s its checked
                  parentCheckBoxOnChanged: (value) {
                    setState(() {
                      turnWorkoutCopyModeOff();
                    });
                  },
                  isOnCopyMode: isWorkoutCopyMode,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditWorkoutName(
                                    workoutPlanUid: workoutPlanUid,
                                    weekUid: weekUid,
                                    workout: workoutsList[index]),
                              ),
                            );

                            break;

                          case 2:
                            //show copy checkboxes

                            setState(() {
                              isWorkoutCopyMode = true;
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

  void copyWorkouts() {
    copyWorkoutsList.forEach((workout) async {
      _bloc
          .copyWorkout(workoutPlanUid, workoutBeingCopied, workout)
          .whenComplete(() => turnWorkoutCopyModeOff());
    });
  }

  void copyWeeks() {
    copyWeeksList.forEach((week) async {
      _bloc
          .copyWeek(workoutPlanUid, weekBeingCopied, week)
          .whenComplete(() => turnWeekCopyModeOff());
    });
  }

  bool checkIfWorkoutIsAddedToCopyList(
    Workout workout,
  ) {
    bool workoutExists;
    Workout existingWorkout = copyWorkoutsList.firstWhere(
        (workoutToCheck) => workoutToCheck.uid == workout.uid, orElse: () {
      return null;
    });
    if (existingWorkout == null) {
      workoutExists = false;
    } else {
      workoutExists = true;
    }
    return workoutExists;
  }

  bool checkIfWeekIsAddedToCopyList(
    Week week,
  ) {
    bool weekExists;
    Week existingWeek = copyWeeksList
        .firstWhere((weekToCheck) => weekToCheck.uid == week.uid, orElse: () {
      return null;
    });
    if (existingWeek == null) {
      weekExists = false;
    } else {
      weekExists = true;
    }
    return weekExists;
  }

  AppBar copyModeAppBar() {
    AppBar appBar;
    if (isWorkoutCopyMode == true) {
      appBar = AppBar(
        title: Text(copyWorkoutsList.length.toString() + ' selected'),
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            turnWorkoutCopyModeOff();
          },
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.copy),
            onTap: () {
              copyWorkouts();
            },
          ),
        ],
        backgroundColor: Colors.black87,
      );
    } else if (isWeekCopyMode == true) {
      appBar = AppBar(
        title: Text(copyWeeksList.length.toString() + ' selected'),
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            turnWeekCopyModeOff();
          },
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.copy),
            onTap: () {
              copyWeeks();
            },
          ),
        ],
        backgroundColor: Colors.black87,
      );
    }
    return appBar;
  }

  turnWeekCopyModeOff() {
    setState(() {
      weekBeingCopied = null;
      copyWeeksList = [];
      isWeekCopyMode = false;
    });
  }

  turnWorkoutCopyModeOff() {
    setState(() {
      workoutBeingCopied = null;
      copyWorkoutsList = [];
      isWorkoutCopyMode = false;
    });
  }
}
