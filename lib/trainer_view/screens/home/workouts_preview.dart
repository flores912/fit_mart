import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/custom_widgets/week_card.dart';
import 'package:fit_mart/custom_widgets/workout_card.dart';
import 'package:fit_mart/models/week.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plan_workouts_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: weeksListView(),
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
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: StreamBuilder(
                        stream: _bloc.getWeekIsDone(
                            widget.workoutPlan.uid, weeksList[index].uid),
                        builder: (context, snapshot) {
                          bool isDone;
                          if (snapshot.hasData) {
                            snapshot.data.docs.forEach((element) {
                              isDone = element.get('isDone');
                            });
                          } else {
                            isDone = false;
                          }
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                            child: WeekCard(
                              isInWorkoutsPreview: true,
                              isWeekDoneCheckBox: Checkbox(
                                  value: isDone == null ? false : isDone,
                                  onChanged: (isDone) {
                                    _bloc.updateIsDoneWeek(
                                        isDone,
                                        widget.workoutPlan.uid,
                                        weeksList[index].uid);
                                  }),
                              week: weeksList[index].week,
                              workoutList: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: workoutsListView(weeksList[index].uid),
                              ),
                            ),
                          );
                        }),
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
                return StreamBuilder(
                    stream: _bloc.getWorkoutIsDone(widget.workoutPlan.uid,
                        weekUid, workoutsList[index].uid),
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
                      return Row(
                        children: [
                          Checkbox(
                              value: isDone == null ? false : isDone,
                              onChanged: (isDone) {
                                _bloc.updateIsDoneWorkout(
                                    isDone,
                                    widget.workoutPlan.uid,
                                    weekUid,
                                    workoutsList[index].uid);
                                //update isDone value
                              }),
                          Expanded(
                            child: WorkoutCard(
                              onTap: () {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WorkoutSession(
                                              workoutName: workoutsList[index]
                                                  .workoutName,
                                              workoutUid:
                                                  workoutsList[index].uid,
                                              weekUid:
                                                  workoutsList[index].weekUid,
                                              workoutPlanUid:
                                                  widget.workoutPlan.uid,
                                            )),
                                  );
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          'You need an account to open workouts.')));
                                }
                              },
                              day: workoutsList[index].day,
                              workoutName: workoutsList[index].workoutName,
                              exercises: workoutsList[index].exercises,
                            ),
                          ),
                        ],
                      );
                    });
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
