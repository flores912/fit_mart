import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/workout_session_set_card.dart';
import 'package:fit_mart/custom_widgets/workout_session_widget.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/trainer_view/blocs/exercise_details_bloc.dart';
import 'package:fit_mart/trainer_view/blocs/workout_exercises_bloc.dart';
import 'package:flutter/material.dart';

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
  WorkoutExercisesBloc _bloc = WorkoutExercisesBloc();

  ExerciseDetailsBloc _blocSets = ExerciseDetailsBloc();

  String exerciseName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                width: MediaQuery.of(context).size.width - 16,
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
                return WorkoutSessionSetCard(
                  set: setsList[index].set,
                  reps: setsList[index].reps,
                  rest: setsList[index].rest,
                );
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
}
