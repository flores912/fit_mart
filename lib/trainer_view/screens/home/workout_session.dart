import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/custom_widgets/workout_session_set_card.dart';
import 'package:fit_mart/custom_widgets/workout_session_widget.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/trainer_view/blocs/exercise_details_bloc.dart';
import 'package:fit_mart/trainer_view/blocs/workout_exercises_bloc.dart';
import 'package:fit_mart/trainer_view/blocs/workout_session_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class WorkoutSession extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final String workoutName;

  const WorkoutSession(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.workoutName})
      : super(key: key);
  @override
  _WorkoutSessionState createState() => _WorkoutSessionState();
}

class _WorkoutSessionState extends State<WorkoutSession> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WorkoutSessionBloc _blocWorkoutSession = WorkoutSessionBloc();
  WorkoutExercisesBloc _bloc = WorkoutExercisesBloc();

  ExerciseDetailsBloc _blocSets = ExerciseDetailsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.workoutName),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
            stream: _bloc.getExercises(
                widget.workoutPlanUid, widget.weekUid, widget.workoutUid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<Exercise> exercisesList =
                    buildExerciseList(snapshot.data.docs);

                return ListView.builder(
                    primary: true,
                    physics: PageScrollPhysics(),
                    itemExtent: MediaQuery.of(context).size.width,
                    itemCount: exercisesList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                          stream: _blocWorkoutSession.getExerciseIsDone(
                              widget.workoutPlanUid,
                              widget.weekUid,
                              widget.workoutUid,
                              exercisesList[index].exerciseUid),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            bool isExerciseDone;
                            if (snapshot.hasData) {
                              snapshot.data.docs.forEach((element) async {
                                isExerciseDone = element.get('isDone');
                              });
                            } else {
                              isExerciseDone = false;
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                              value: isExerciseDone == null
                                                  ? false
                                                  : isExerciseDone,
                                              onChanged: (isDone) {
                                                _blocWorkoutSession
                                                    .updateIsDoneExercise(
                                                        isDone,
                                                        widget.workoutPlanUid,
                                                        widget.weekUid,
                                                        widget.workoutUid,
                                                        exercisesList[index]
                                                            .exerciseUid)
                                                    .whenComplete(() {
                                                  if (exercisesList[index]
                                                              .exerciseUid ==
                                                          exercisesList.last
                                                              .exerciseUid &&
                                                      isDone == true) {
                                                    _blocWorkoutSession
                                                        .updateIsDoneWorkout(
                                                      isDone,
                                                      widget.workoutPlanUid,
                                                      widget.weekUid,
                                                      widget.workoutUid,
                                                    );
                                                  }
                                                });
                                              }),
                                          Text(
                                            exercisesList[index].exerciseName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('(Exercise ' +
                                            exercisesList[index]
                                                .exerciseIndex
                                                .toString() +
                                            ' of ' +
                                            exercisesList.length.toString() +
                                            ')'),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: WorkoutSessionWidget(
                                        videoUrl: exercisesList[index].videoUrl,
                                        setsList: setsListView(
                                            exercisesList[index].exerciseUid),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    });
              }
              return Text('No Data');
            },
          ),
        ),
      ),
    );
  }

  List<Exercise> buildExerciseList(
    List<DocumentSnapshot> docList,
  ) {
    List<Exercise> exerciseList = [];
    docList.forEach((element) {
      Exercise exercise = Exercise(
          exerciseName: element.get('exerciseName'),
          exerciseIndex: element.get('exercise'),
          videoUrl: element.get('videoUrl'),
          sets: element.get('sets'),
          exerciseUid: element.id);
      exerciseList.add(exercise);
    });
    return exerciseList;
  }

  List<Set> buildSetsList(List<DocumentSnapshot> docList) {
    List<Set> setsList = [];
    docList.forEach((element) {
      Set set = Set(
          isTimed: element.get('isTimed'),
          isFailure: element.get('isFailure'),
          reps: element.get('reps'),
          rest: element.get('rest'),
          set: element.get('set'),
          setUid: element.id);
      setsList.add(set);
    });
    return setsList;
  }

  Widget setsListView(String exerciseUid) {
    return StreamBuilder(
        stream: _blocSets.getSets(widget.workoutPlanUid, widget.weekUid,
            widget.workoutUid, exerciseUid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
            List<Set> setsList = buildSetsList(
              snapshot.data.docs,
            );

            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: setsList.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                CountDownController _restCountDownController =
                    CountDownController();
                CountDownController _setCountDownController =
                    CountDownController();
                bool isRestTimerPaused = false;
                bool isSetTimerPaused = false;
                bool showRestTimer = false;
                if (setsList[index].isTimed == true) {}
                return StreamBuilder(
                    stream: _blocWorkoutSession.getSetIsDone(
                        widget.workoutPlanUid,
                        widget.weekUid,
                        widget.workoutUid,
                        exerciseUid,
                        setsList[index].setUid),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      bool isDone;
                      if (snapshot.hasData) {
                        snapshot.data.docs.forEach((element) {
                          isDone = element.get('isDone');
                        });
                      } else {
                        isDone = false;
                      }

                      return WorkoutSessionSetCard(
                        onChanged: (isDone) {
                          if (isDone == true) {
                            showRestTimer = true;
                          } else {
                            showRestTimer = false;
                          }
                          _blocWorkoutSession.updateIsDoneSet(
                              isDone,
                              widget.workoutPlanUid,
                              widget.weekUid,
                              widget.workoutUid,
                              exerciseUid,
                              setsList[index].setUid);
                        },
                        setCountDownController: _setCountDownController,
                        restCountDownController: _restCountDownController,
                        onSetTimerPressed: () {
                          if (isSetTimerPaused == false &&
                              setsList[index].isTimed) {
                            isSetTimerPaused = true;
                            _setCountDownController.pause();
                          } else if (isSetTimerPaused == true &&
                              setsList[index].isTimed) {
                            isSetTimerPaused = false;
                            _setCountDownController.restart(
                                duration: setsList[index].reps);
                          }
                        },
                        onRestTimerPressed: () {
                          if (isRestTimerPaused == false) {
                            isRestTimerPaused = true;
                            _restCountDownController.pause();
                          } else {
                            isRestTimerPaused = false;
                            _restCountDownController.restart(
                                duration: setsList[index].rest);
                          }
                        },
                        onTimedSetTimerComplete: () async {
                          isDone = true;

                          showRestTimer = true;
                          showRepsCompleteSnackBar();
                          if (await Vibration.hasCustomVibrationsSupport()) {
                            Vibration.vibrate(duration: 5000);
                          } else {
                            Vibration.vibrate();
                            await Future.delayed(Duration(seconds: 5));
                            Vibration.vibrate();
                          }
                        },
                        onRestTimerComplete: () async {
                          if (setsList[index].setUid == setsList.last.setUid) {
                            _blocWorkoutSession.updateIsDoneExercise(
                                true,
                                widget.workoutPlanUid,
                                widget.weekUid,
                                widget.workoutUid,
                                exerciseUid);
                          }
                          showRestCompleteSnackBar();
                          if (await Vibration.hasCustomVibrationsSupport()) {
                            Vibration.vibrate(duration: 5000);
                          } else {
                            Vibration.vibrate();
                            await Future.delayed(Duration(seconds: 5));
                            Vibration.vibrate();
                          }
                        },
                        showRestTimer: showRestTimer,
                        isDone: isDone,
                        isFailure: setsList[index].isFailure,
                        isTimed: setsList[index].isTimed,
                        set: setsList[index].set,
                        reps: setsList[index].reps,
                        rest: setsList[index].rest,
                      );
                    });
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('No Sets.')),
            );
          }
        });
  }

  void showRestCompleteSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: kAccentColor,
        content: Text(
          'Rest Complete!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        )));
  }

  void showRepsCompleteSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: kAccentColor,
        content: Text(
          'Set Complete! Time to Rest!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        )));
  }
}
