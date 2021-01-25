import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/exercise_card.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/trainer_view/blocs/workout_exercises_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../constants.dart';

class ExerciseCollectionList extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final int exercise;
  final int numberOfExercises;
  final bool isEdit;

  const ExerciseCollectionList(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.exercise,
      this.numberOfExercises,
      this.isEdit})
      : super(key: key);
  @override
  _ExerciseCollectionListState createState() => _ExerciseCollectionListState();
}

class _ExerciseCollectionListState extends State<ExerciseCollectionList> {
  WorkoutExercisesBloc _bloc = WorkoutExercisesBloc();

  List<Exercise> exercisesList = [];

  bool isTimed;

  bool isFailure;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Collection'),
      ),
      body: exercisesListView(),
    );
  }

  Widget exercisesListView() {
    return StreamBuilder(
      stream: _bloc.getExercisesCollection(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          exercisesList = buildExerciseList(snapshot.data.docs);
          return ListView.builder(
            itemCount: exercisesList.length,
            itemBuilder: (context, index) {
              return Container(
                  width: MediaQuery.of(context).size.width - 24,
                  child: ExerciseCard(
                    onTap: () async {
                      await addExerciseToWorkout(index);
                    },
                    exerciseName: exercisesList[index].exerciseName,
                    sets: exercisesList[index].sets,
                    url: exercisesList[index].videoUrl,
                    more: widget.isEdit == true
                        ? PopupMenuButton(
                            onSelected: (value) async {
                              switch (value) {
                                case 1:
                                  addExerciseToWorkout(index);
                                  break;

                                case 2:
                                  deleteExercise(index);
                                  break;
                              }
                            },
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) =>
                                kExerciseCardCollectionPopUpMenuList)
                        : null,
                  ));
            },
          );
        } else {
          return Text('Start Adding Exercises!');
        }
      },
    );
  }

  void deleteExercise(int index) {
    EasyLoading.show();
    _bloc
        .deleteExerciseFromCollection(exercisesList[index].exerciseUid)
        .whenComplete(() => EasyLoading.dismiss());
  }

  Future addExerciseToWorkout(
    int index,
  ) async {
    EasyLoading.show();
    _bloc
        .addNewExercise(
            exercisesList[index].exerciseName,
            widget.exercise,
            exercisesList[index].sets,
            exercisesList[index].videoUrl,
            widget.workoutPlanUid,
            widget.weekUid,
            widget.workoutUid)
        .then((value) {
          _bloc
              .getSetsCollection(exercisesList[index].exerciseUid)
              .forEach((element) {
            element.docs.forEach((element) async {
              int set = await element.get('set');
              int reps = await element.get('reps');
              int rest = await element.get('rest');
              bool isSetInMin = await element.get('isSetInMin');
              bool isRestInMin = await element.get('isRestInMin');

              _bloc.addNewSet(
                  widget.workoutPlanUid,
                  widget.weekUid,
                  widget.workoutUid,
                  value.id,
                  set,
                  reps,
                  rest,
                  isTimed,
                  isFailure,
                  isSetInMin,
                  isRestInMin);
            });
          });
        })
        .whenComplete(() => _bloc.updateNumberOfExercises(widget.workoutPlanUid,
            widget.weekUid, widget.workoutUid, widget.exercise))
        .whenComplete(() => EasyLoading.dismiss())
        .whenComplete(() => Navigator.pop(context));
  }

  List<Exercise> buildExerciseList(
    List<DocumentSnapshot> docList,
  ) {
    List<Exercise> exerciseList = [];
    docList.forEach((element) {
      Exercise exercise = Exercise(
          exerciseName: element.get('exerciseName'),
          videoUrl: element.get('videoUrl'),
          sets: element.get('sets'),
          exerciseUid: element.id);
      exerciseList.add(exercise);
    });
    return exerciseList;
  }
}
