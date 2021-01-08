import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/exercise_card.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/trainer_view/blocs/workout_exercises_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/exercise_details_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ExerciseCollectionList extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final int exercise;
  final int numberOfExercises;

  const ExerciseCollectionList(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.exercise,
      this.numberOfExercises})
      : super(key: key);
  @override
  _ExerciseCollectionListState createState() => _ExerciseCollectionListState();
}

class _ExerciseCollectionListState extends State<ExerciseCollectionList> {
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
                    onTap: () {
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
                                .getSetsCollection(
                                    exercisesList[index].exerciseUid)
                                .forEach((element) {
                              element.docs.forEach((element) async {
                                int set = await element.get('set');
                                int reps = await element.get('reps');
                                int rest = await element.get('rest');

                                _bloc.addNewSet(
                                    widget.workoutPlanUid,
                                    widget.weekUid,
                                    widget.workoutUid,
                                    value.id,
                                    set,
                                    reps,
                                    rest);
                              });
                            });
                          })
                          .whenComplete(() => _bloc.updateNumberOfExercises(
                              widget.workoutPlanUid,
                              widget.weekUid,
                              widget.workoutUid,
                              widget.exercise))
                          .whenComplete(() => Navigator.pop(context));
                    },
                    exerciseName: exercisesList[index].exerciseName,
                    sets: exercisesList[index].sets,
                    thumbnail: exercisesList[index].videoUrl != null
                        ? Container(
                            height: 100,
                            width: 100,
                            child: BetterPlayerListVideoPlayer(
                              BetterPlayerDataSource(
                                  BetterPlayerDataSourceType.network,
                                  exercisesList[index].videoUrl),
                              configuration: BetterPlayerConfiguration(
                                controlsConfiguration:
                                    BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 1,
                              ),
                              betterPlayerListVideoPlayerController: controller,
                              autoPlay: false,
                            ),
                          )
                        : Container(
                            color: CupertinoColors.placeholderText,
                            height: 100,
                            width: 100,
                          )),
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
          videoUrl: element.get('videoUrl'),
          sets: element.get('sets'),
          exerciseUid: element.id);
      exerciseList.add(exercise);
    });
    return exerciseList;
  }
}
