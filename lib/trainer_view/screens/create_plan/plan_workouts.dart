import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/week_card.dart';
import 'package:fit_mart/custom_widgets/workout_card.dart';
import 'package:fit_mart/trainer_view/blocs/plan_workouts_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/cover_photo.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_workout_name.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/workout_exercises.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_plan_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../constants.dart';
import '../../../models/week.dart';
import '../../../models/workout.dart';

class PlanWorkouts extends StatefulWidget {
  final String workoutPlanUid;
  final bool isEdit;

  const PlanWorkouts({Key key, this.workoutPlanUid, this.isEdit})
      : super(key: key);
  @override
  _PlanWorkoutsState createState() => _PlanWorkoutsState();
}

class _PlanWorkoutsState extends State<PlanWorkouts> {
  PlanWorkoutsBloc _bloc = PlanWorkoutsBloc();

  String workoutPlanUid;

  bool isWorkoutCopyMode;
  bool isWeekCopyMode;
  bool isWeekSwapMode;

  Workout workoutBeingCopied;
  Week weekBeingCopied;
  bool isWorkoutSwapMode;

  List<Workout> copyWorkoutsList = [];
  List<Week> copyWeeksList = [];

  List<Week> weeksList = [];

  Week oldWeek;
  Week newWeek;

  Workout oldWorkout;
  Workout newWorkout;
  AutoScrollController controller;

  @override
  void initState() {
    workoutPlanUid = widget.workoutPlanUid;

    controller = AutoScrollController(
        //add this for advanced viewport boundary. e.g. SafeArea
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),

        //choose vertical/horizontal
        axis: Axis.horizontal,

        //this given value will bring the scroll offset to the nearest position in fixed row height case.
        //for variable row height case, you can still set the average height, it will try to get to the relatively closer offset
        //and then start searching.
        suggestedRowHeight: 200);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: floatingActionButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: isWorkoutCopyMode == true ||
              isWeekCopyMode == true ||
              isWeekSwapMode == true ||
              isWorkoutSwapMode == true
          ? appBarMode()
          : AppBar(
              title: Text('Workouts'),
              actions: [
                widget.isEdit == null
                    ? FlatButton(
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
                    : Container() //nothing
              ],
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: weeksListView()),
        ),
      ),
    );
  }

  Widget weeksListView() {
    return StreamBuilder(
      stream: _bloc.getWeeks(workoutPlanUid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          weeksList = buildWeeksList(snapshot.data.docs);
          return ListView.builder(
            itemCount: weeksList.length,
            controller: controller,
            physics: isWorkoutSwapMode == true
                ? NeverScrollableScrollPhysics()
                : null,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return AutoScrollTag(
                controller: controller,
                key: ValueKey(weeksList[index].uid),
                index: index,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: isWeekSwapMode == true &&
                            oldWeek.uid != weeksList[index].uid
                        ? () {
                            if (weeksList[index].uid != oldWeek.uid) {
                              setState(() {
                                newWeek = weeksList[index];
                              });
                            }
                          }
                        : () {},
                    child: Center(
                      child: WeekCard(
                        elevation: isWeekSwapMode == true &&
                                weeksList[index].uid == oldWeek.uid
                            ? 40
                            : isWeekSwapMode == true &&
                                    newWeek != null &&
                                    weeksList[index].uid == newWeek.uid
                                ? 0
                                : 4,
                        swapMode: isWeekSwapMode == true &&
                                weeksList[index].uid == oldWeek.uid
                            ? true
                            : isWeekSwapMode == true &&
                                    newWeek != null &&
                                    weeksList[index].uid == newWeek.uid
                                ? true
                                : false,
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
                        isSelected:
                            checkIfWeekIsAddedToCopyList(weeksList[index]),
                        isParentCheckbox: weekBeingCopied != null
                            ? weekBeingCopied.uid == weeksList[index].uid
                            : false,
                        isOnCopyMode: isWeekCopyMode,
                        week: weeksList[index].week,
                        workoutList: workoutsListView(
                            weeksList[index].uid, weeksList[index].week),
                        more: isWorkoutSwapMode == true ||
                                isWorkoutCopyMode == true ||
                                isWeekSwapMode == true ||
                                isWeekCopyMode == true
                            ? null
                            : PopupMenuButton(
                                child: Icon(Icons.more_vert),
                                onSelected: (value) {
                                  switch (value) {
                                    case 1:
                                      //show copy checkboxes

                                      setState(() {
                                        isWeekCopyMode = true;
                                        weekBeingCopied = weeksList[index];
                                      });
                                      break;
                                    //swap mode
                                    case 2:
                                      if (weeksList.length > 1) {
                                        setState(() {
                                          isWeekSwapMode = true;
                                          oldWeek = weeksList[index];
                                        });
                                      }

                                      break;
                                    case 3:
                                      //delete
                                      deleteWeek(index);
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    kWeekCardPopUpMenuList),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Start Adding Weeks!'));
        }
      },
    );
  }

  Future<void> deleteWeek(int index) async {
    //delete
    await _bloc.deleteWeek(workoutPlanUid, weeksList[index].uid).whenComplete(
        () async =>
            //update number of total weeks
            await _bloc
                .updateNumberOfWeeks(workoutPlanUid, weeksList.length)
                .whenComplete(() async {
              for (int i = 0; i <= weeksList.length; i++) {
                //update indexes
                await _bloc.updateWeekIndex(
                    workoutPlanUid, weeksList[i].uid, i + 1);
              }
            }));
  }

  Widget workoutsListView(String weekUid, int week) {
    return StreamBuilder(
        stream: _bloc.getWorkouts(workoutPlanUid, weekUid),
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
                  elevation: isWorkoutSwapMode == true &&
                          workoutsList[index].uid == oldWorkout.uid
                      ? 40
                      : isWorkoutSwapMode == true &&
                              newWorkout != null &&
                              workoutsList[index].uid == newWorkout.uid
                          ? 0
                          : 4,
                  isWorkoutSwapMode: isWorkoutSwapMode == true &&
                          workoutsList[index].uid == oldWorkout.uid
                      ? true
                      : isWorkoutSwapMode == true &&
                              newWorkout != null &&
                              workoutsList[index].uid == newWorkout.uid
                          ? true
                          : false,

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
                  onTap: isWorkoutSwapMode == true
                      ? () {
                          if (workoutsList[index].uid != oldWorkout.uid) {
                            setState(() {
                              newWorkout = workoutsList[index];
                            });
                          }
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutExercises(
                                workoutName: workoutsList[index].workoutName,
                                workoutPlanUid: workoutPlanUid,
                                weekUid: weekUid,
                                workoutUid: workoutsList[index].uid,
                              ),
                            ),
                          );
                        },
                  more: isWorkoutSwapMode == true ||
                          isWorkoutCopyMode == true ||
                          isWeekSwapMode == true ||
                          isWeekCopyMode == true
                      ? null
                      : PopupMenuButton(
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
                                //swap
                                setState(() {
                                  oldWorkout = workoutsList[index];
                                  controller.scrollToIndex(week - 1);
                                  isWorkoutSwapMode = true;
                                });
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              kWorkoutCardPopUpMenuList),
                );
              },
            );
          } else {
            return Container(
                height: 48, width: 48, child: CircularProgressIndicator());
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
      await _bloc
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

  AppBar appBarMode() {
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
      );
    } else if (isWeekSwapMode == true) {
      appBar = AppBar(
        title: Row(
          children: [
            Text('Swap Week ' + oldWeek.week.toString() + ' with '),
            Text(newWeek != null ? 'Week ' + newWeek.week.toString() : '...'),
          ],
        ),
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            turnWeekSwapModeOff();
          },
        ),
        backgroundColor: Colors.black87,
      );
    } else if (isWorkoutSwapMode == true) {
      appBar = AppBar(
        title: Row(
          children: [
            Text('Swap Day ' + oldWorkout.day.toString() + ' with '),
            Text(newWorkout != null
                ? 'Day ' + newWorkout.day.toString()
                : '...'),
          ],
        ),
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            turnWorkoutSwapModeOff();
          },
        ),
      );
    }
    return appBar;
  }

  swapWeeks(Week oldWeek, Week newWeek) async {
    await _bloc
        .updateWeekIndex(workoutPlanUid, oldWeek.uid, newWeek.week)
        .whenComplete(() async => await _bloc.updateWeekIndex(
            workoutPlanUid, newWeek.uid, oldWeek.week))
        .whenComplete(() => turnWeekSwapModeOff());
  }

  swapWorkouts(Workout oldWorkout, Workout newWorkout) async {
    await _bloc
        .updateWorkoutIndex(
            workoutPlanUid, oldWorkout.weekUid, oldWorkout.uid, newWorkout.day)
        .whenComplete(() => _bloc.updateWorkoutIndex(
            workoutPlanUid, newWorkout.weekUid, newWorkout.uid, oldWorkout.day))
        .whenComplete(() => turnWorkoutSwapModeOff());
  }

  turnWorkoutSwapModeOff() {
    setState(() {
      oldWorkout = null;
      newWorkout = null;
      isWorkoutSwapMode = false;
    });
  }

  turnWeekSwapModeOff() {
    setState(() {
      oldWeek = null;
      newWeek = null;
      isWeekSwapMode = false;
    });
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

  Widget floatingActionButton() {
    if (isWorkoutSwapMode == true) {
      return Visibility(
        visible: newWorkout == null ? false : true,
        child: FloatingActionButton(
          onPressed: () {
            swapWorkouts(
              oldWorkout,
              newWorkout,
            );
          },
          child: Icon(Icons.swap_horiz),
        ),
      );
    } else if (isWeekSwapMode == true) {
      return Visibility(
        visible: newWeek == null ? false : true,
        child: FloatingActionButton(
          onPressed: () {
            swapWeeks(
              oldWeek,
              newWeek,
            );
          },
          child: Icon(Icons.swap_horiz),
        ),
      );
    } else if (isWeekCopyMode == true) {
      return Visibility(
        visible: copyWeeksList.isEmpty ? false : true,
        child: FloatingActionButton(
          onPressed: () {
            copyWeeks();
          },
          child: Icon(Icons.copy),
        ),
      );
    } else if (isWorkoutCopyMode == true) {
      return Visibility(
        visible: copyWorkoutsList.isEmpty ? false : true,
        child: FloatingActionButton(
          onPressed: () {
            copyWorkouts();
          },
          child: Icon(Icons.copy),
        ),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          _bloc
              .createNewWeek(workoutPlanUid, weeksList.length + 1)
              .whenComplete(
                () => controller.animateTo(
                  controller.position.maxScrollExtent,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 1),
                ),
              )
              .whenComplete(() =>
                  _bloc.updateNumberOfWeeks(workoutPlanUid, weeksList.length));
        },
        label: Text(kAddWeek),
        icon: Icon(Icons.add),
      );
    }
  }
}
