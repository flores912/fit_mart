import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/exercise_card.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/trainer_view/blocs/workout_exercises_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import 'exercise_collection_list.dart';
import 'exercise_details.dart';
import 'exercise_name.dart';

class WorkoutExercises extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final String workoutName;

  const WorkoutExercises(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.workoutName})
      : super(key: key);
  @override
  _WorkoutExercisesState createState() => _WorkoutExercisesState();
}

class _WorkoutExercisesState extends State<WorkoutExercises> {
  WorkoutExercisesBloc _bloc = WorkoutExercisesBloc();

  List<Exercise> exercisesList = [];

  String workoutPlanUid;
  String workoutUid;
  String weekUid;

  Future _saving;

  Exercise oldExercise;

  Exercise newExercise;

  bool isExerciseSwapMode;
  @override
  void initState() {
    workoutPlanUid = widget.workoutPlanUid;
    weekUid = widget.weekUid;
    workoutUid = widget.workoutUid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: exercisesListView(),
    );
  }

  Widget exercisesListView() {
    return StreamBuilder(
      stream: _bloc.getExercises(workoutPlanUid, weekUid, workoutUid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          exercisesList = buildExerciseList(snapshot.data.docs);
          return Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: exercisesList.length,
              itemBuilder: (context, index) {
                return Container(
                  child: GestureDetector(
                    onTap: isExerciseSwapMode == true
                        ? () {
                            newSwapItem(index);
                          }
                        : () {
                            goToExerciseDetails(index);
                          },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              exercisesList[index].exerciseIndex.toString()),
                        ),
                        Expanded(
                          child: ExerciseCard(
                            color: isExerciseSwapMode == true &&
                                        exercisesList[index].exerciseUid ==
                                            oldExercise.exerciseUid ||
                                    isExerciseSwapMode == true &&
                                        newExercise != null &&
                                        exercisesList[index].exerciseUid ==
                                            newExercise.exerciseUid
                                ? kPrimaryColor
                                : null,
                            elevation: isExerciseSwapMode == true &&
                                    exercisesList[index].exerciseUid ==
                                        oldExercise.exerciseUid
                                ? 40
                                : isExerciseSwapMode == true &&
                                        newExercise != null &&
                                        exercisesList[index].exerciseUid ==
                                            newExercise.exerciseUid
                                    ? 0
                                    : 4,
                            more: PopupMenuButton(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 1:
                                      //Edit Name
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExerciseName(
                                            isEdit: true,
                                            exercise: exercisesList[index],
                                            exerciseIndex:
                                                exercisesList.length + 1,
                                            workoutPlanUid:
                                                widget.workoutPlanUid,
                                            weekUid: widget.weekUid,
                                            workoutUid: widget.workoutUid,
                                          ),
                                        ),
                                      );
                                      break;

                                    case 2:
                                      //swap
                                      setState(() {
                                        isExerciseSwapMode = true;
                                        oldExercise = exercisesList[index];
                                      });
                                      break;
                                    case 3:
                                      //duplicate
                                      await duplicate(index);
                                      break;

                                    case 4:
                                      //save to collection
                                      EasyLoading.show();
                                      _bloc
                                          .addNewExerciseToCollection(
                                              exercisesList[index].exerciseName,
                                              exercisesList[index].sets,
                                              exercisesList[index].videoUrl)
                                          .then((newExercise) async {
                                        await _bloc
                                            .getSetsFuture(
                                                workoutPlanUid,
                                                weekUid,
                                                workoutUid,
                                                exercisesList[index]
                                                    .exerciseUid)
                                            .then((originalSets) {
                                          originalSets.docs
                                              .forEach((originalSet) async {
                                            Set set = Set(
                                                isSetInMin: await originalSet
                                                    .get('isSetInMin'),
                                                isRestInMin: await originalSet
                                                    .get('isRestInMin'),
                                                isTimed: await originalSet
                                                    .get('isTimed'),
                                                isFailure: await originalSet
                                                    .get('isFailure'),
                                                reps: await originalSet
                                                    .get('reps'),
                                                rest: await originalSet
                                                    .get('rest'),
                                                set: await originalSet
                                                    .get('set'),
                                                setUid: await originalSet.id);

                                            await _bloc.addNewSetCollection(
                                                newExercise.id,
                                                set.set,
                                                set.reps,
                                                set.rest,
                                                set.isTimed,
                                                set.isFailure,
                                                set.isSetInMin,
                                                set.isRestInMin);
                                          });
                                        });
                                      }).whenComplete(() {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Exercise added to collection.'),
                                        ));
                                      }).whenComplete(
                                              () => EasyLoading.dismiss());
                                      break;
                                    case 5:
                                      //delete
                                      deleteExercise(index);
                                      break;
                                  }
                                },
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) =>
                                    kExerciseCardPopUpMenuList),
                            exerciseName: exercisesList[index].exerciseName,
                            sets: exercisesList[index].sets,
                            url: exercisesList[index].videoUrl,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Text('Start Adding Exercises!');
        }
      },
    );
  }

  Future<void> duplicate(int index) async {
    EasyLoading.show();
    await _bloc
        .duplicateExercise(workoutPlanUid, weekUid, workoutUid,
            exercisesList[index], exercisesList.length + 1)
        .whenComplete(() {
      updateIndexes().whenComplete(() => _bloc.updateNumberOfExercises(
          workoutPlanUid, weekUid, workoutUid, exercisesList.length));
    }).whenComplete(() => EasyLoading.dismiss());
  }

  void newSwapItem(int index) {
    setState(() {
      if (oldExercise.exerciseUid != exercisesList[index].exerciseUid) {
        newExercise = exercisesList[index];
      }
    });
  }

  void goToExerciseDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetails(
          exerciseName: exercisesList[index].exerciseName,
          workoutPlanUid: widget.workoutPlanUid,
          weekUid: widget.weekUid,
          workoutUid: widget.workoutUid,
          exerciseUid: exercisesList[index].exerciseUid,
        ),
      ),
    );
  }

  Future deleteExercise(int index) async {
    EasyLoading.show();

    await _bloc
        .deleteExerciseFromWorkout(widget.workoutPlanUid, widget.weekUid,
            widget.workoutUid, exercisesList[index].exerciseUid)
        .whenComplete(() async => await _bloc.updateNumberOfExercises(
            widget.workoutPlanUid,
            widget.weekUid,
            widget.workoutUid,
            exercisesList.length))
        .whenComplete(() async {
      await updateIndexes();
    }).whenComplete(() => EasyLoading.dismiss());
  }

  Future<void> updateIndexes() async {
    for (int i = 0; i < exercisesList.length; i++) {
      //update indexes
      await _bloc.updateExerciseIndex(widget.workoutPlanUid, widget.weekUid,
          widget.workoutUid, exercisesList[i].exerciseUid, i + 1);
    }
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

  showAddExerciseDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text(
            'Add exercise ',
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseCollectionList(
                      exercise: exercisesList.length,
                      isEdit: false,
                      workoutPlanUid: widget.workoutPlanUid,
                      weekUid: widget.weekUid,
                      workoutUid: widget.workoutUid,
                    ),
                  ),
                );
              },
              child: const Text(
                'Add from collection',
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseName(
                      exerciseIndex: exercisesList.length + 1,
                      workoutPlanUid: widget.workoutPlanUid,
                      weekUid: widget.weekUid,
                      workoutUid: widget.workoutUid,
                    ),
                  ),
                );
              },
              child: const Text('Create new exercise'),
            ),
          ],
        );
      },
    );
  }

  Future<void> swapExercises(Exercise oldExercise, Exercise newExercise) async {
    await _bloc
        .updateExerciseIndex(workoutPlanUid, weekUid, workoutUid,
            oldExercise.exerciseUid, newExercise.exerciseIndex)
        .whenComplete(() async => await _bloc.updateExerciseIndex(
            workoutPlanUid,
            weekUid,
            workoutUid,
            newExercise.exerciseUid,
            oldExercise.exerciseIndex));
  }

  turnExerciseSwapModeOff() {
    setState(() {
      oldExercise = null;
      newExercise = null;
      isExerciseSwapMode = false;
    });
  }

  Widget floatingActionButton() {
    if (isExerciseSwapMode == true) {
      return Visibility(
          visible: newExercise == null ? false : true,
          child: FloatingActionButton(
              child: Icon(Icons.swap_horiz),
              onPressed: () {
                swapExercises(oldExercise, newExercise)
                    .whenComplete(() => turnExerciseSwapModeOff());
              }));
    } else {
      return FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text(kAddExercise),
        onPressed: () {
          showAddExerciseDialog();
        },
      );
    }
  }

  AppBar appBar() {
    if (isExerciseSwapMode == true) {
      return AppBar(
        title: Row(
          children: [
            Text('Swap Exercise ' +
                oldExercise.exerciseIndex.toString() +
                ' with '),
            Text(newExercise != null
                ? 'Exercise ' + newExercise.exerciseIndex.toString()
                : '...'),
          ],
        ),
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            turnExerciseSwapModeOff();
          },
        ),
      );
    } else {
      return AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  Get.to(ExerciseCollectionList(
                    isEdit: true,
                    workoutUid: workoutUid,
                    weekUid: weekUid,
                    workoutPlanUid: workoutPlanUid,
                    exercise: exercisesList.length,
                  ));
                },
                child: Icon(Icons.collections_bookmark)),
          )
        ],
        title: Text(widget.workoutName),
      );
    }
  }
}
