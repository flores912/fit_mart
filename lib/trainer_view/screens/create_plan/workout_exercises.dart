import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/exercise_card.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/trainer_view/blocs/workout_exercises_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/exercise_collection_list.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/exercise_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'exercise_details.dart';

class WorkoutExercises extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;

  const WorkoutExercises(
      {Key key, this.workoutPlanUid, this.weekUid, this.workoutUid})
      : super(key: key);
  @override
  _WorkoutExercisesState createState() => _WorkoutExercisesState();
}

class _WorkoutExercisesState extends State<WorkoutExercises> {
  WorkoutExercisesBloc _bloc = WorkoutExercisesBloc();
  BetterPlayerListVideoPlayerController controller =
      BetterPlayerListVideoPlayerController();
  BetterPlayerConfiguration betterPlayerConfiguration =
      BetterPlayerConfiguration(autoPlay: false);
  List<Exercise> exercisesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text(kAddExercise),
        onPressed: () {
          showAddPhotoDialog();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: exercisesListView(),
    );
  }

  Widget exercisesListView() {
    return StreamBuilder(
      stream: _bloc.getExercises(
          widget.workoutPlanUid, widget.weekUid, widget.workoutUid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          exercisesList = buildExerciseList(snapshot.data.docs);
          return ListView.builder(
            itemCount: exercisesList.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width - 24,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetails(
                          workoutPlanUid: widget.workoutPlanUid,
                          weekUid: widget.weekUid,
                          workoutUid: widget.workoutUid,
                          exerciseUid: exercisesList[index].exerciseUid,
                        ),
                      ),
                    );
                  },
                  child: ExerciseCard(
                      more: PopupMenuButton(
                          onSelected: (value) {
                            switch (value) {
                              case 1:
                                //Edit Name

                                break;
                              case 2:
                                //delete
                                _bloc
                                    .deleteExerciseFromWorkout(
                                        widget.workoutPlanUid,
                                        widget.weekUid,
                                        widget.workoutUid,
                                        exercisesList[index].exerciseUid)
                                    .whenComplete(() =>
                                        _bloc.updateNumberOfExercises(
                                            widget.workoutPlanUid,
                                            widget.weekUid,
                                            widget.workoutUid,
                                            exercisesList.length));
                                break;
                            }
                          },
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) =>
                              kExerciseCardPopUpMenuList),
                      exerciseName: exercisesList[index].exerciseName,
                      sets: exercisesList[index].sets,
                      thumbnail: exercisesList[index].videoUrl != null
                          ? Container(
                              height: 100,
                              width: 100,
                              child: BetterPlayerListVideoPlayer(
                                BetterPlayerDataSource(
                                    BetterPlayerDataSourceType.NETWORK,
                                    exercisesList[index].videoUrl),
                                configuration: BetterPlayerConfiguration(
                                  controlsConfiguration:
                                      BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 1,
                                ),
                                betterPlayerListVideoPlayerController:
                                    controller,
                                autoPlay: false,
                              ),
                            )
                          : Container(
                              color: CupertinoColors.placeholderText,
                              height: 100,
                              width: 100,
                            )),
                ),
              );
            },
          );
        } else {
          return Text('Start Adding Exercises!');
        }
      },
    );
  }

  List<Exercise> buildExerciseList(
    List<DocumentSnapshot> docList,
  ) {
    List<Exercise> exerciseList = [];
    docList.forEach((element) {
      Exercise exercise = Exercise(
          exerciseName: element.get('exerciseName'),
          exercise: element.get('exercise'),
          videoUrl: element.get('videoUrl'),
          sets: element.get('sets'),
          exerciseUid: element.id);
      exerciseList.add(exercise);
    });
    return exerciseList;
  }

  showAddPhotoDialog() {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseCollectionList(
                      exercise: exercisesList.length + 1,
                      workoutPlanUid: widget.workoutPlanUid,
                      weekUid: widget.weekUid,
                      workoutUid: widget.workoutUid,
                    ),
                  ),
                ).whenComplete(() => Navigator.pop(context));
              },
              child: const Text(
                'Add from collection',
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseName(
                      exercise: exercisesList.length + 1,
                      workoutPlanUid: widget.workoutPlanUid,
                      weekUid: widget.weekUid,
                      workoutUid: widget.workoutUid,
                    ),
                  ),
                ).whenComplete(() => Navigator.pop(context));
              },
              child: const Text('Create new exercise'),
            ),
          ],
        );
      },
    );
  }
}
