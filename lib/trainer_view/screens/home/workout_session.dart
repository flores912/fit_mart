import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  String exerciseName = '';

  Timer restTimer;

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
                      exerciseName = exercisesList[index].exerciseName;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  exerciseName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
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
                                height: MediaQuery.of(context).size.height,
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
                CountDownController _countDownController =
                    CountDownController();
                bool isTimerPaused = false;
                bool showRestTimer = false;
                return StreamBuilder(
                    stream: _blocWorkoutSession.getSetIsDone(
                        widget.workoutPlanUid,
                        widget.weekUid,
                        widget.workoutUid,
                        exerciseUid,
                        setsList[index].setUid),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      bool isDone = false;
                      if (snapshot.hasData) {
                        snapshot.data.docs.forEach((element) {
                          isDone = element.get('isDone');
                        });
                      } else {
                        isDone = false;
                      }
                      return WorkoutSessionSetCard(
                        onChanged: (isDone) {
                          _blocWorkoutSession.updateIsDoneSet(
                              isDone,
                              widget.workoutPlanUid,
                              widget.weekUid,
                              widget.workoutUid,
                              exerciseUid,
                              setsList[index].setUid);
                          if (isDone == true) {
                            showRestTimer = true;
                          } else {
                            showRestTimer = false;
                          }
                        },
                        countDownController: _countDownController,
                        onTimerPressed: () {
                          if (isTimerPaused == false) {
                            isTimerPaused = true;
                            _countDownController.pause();
                          } else {
                            isTimerPaused = false;
                            _countDownController.restart(
                                duration: setsList[index].rest);
                          }
                        },
                        onRestTimerComplete: () async {
                          showSnackBar();
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

  void showSnackBar() {
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        content: Text(
          'Rest Complete!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        )));
  }

  @override
  void dispose() {
    restTimer.cancel();
    super.dispose();
  }
}
