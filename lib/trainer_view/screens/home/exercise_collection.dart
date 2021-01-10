import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/exercise_card.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/trainer_view/blocs/workout_exercises_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/exercise_details_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'exercise_name_collection.dart';

class ExerciseCollection extends StatefulWidget {
  static const String title = kExerciseCollection;

  @override
  _ExerciseCollectionState createState() => _ExerciseCollectionState();
}

class _ExerciseCollectionState extends State<ExerciseCollection> {
  WorkoutExercisesBloc _bloc = WorkoutExercisesBloc();
  BetterPlayerListVideoPlayerController controller =
      BetterPlayerListVideoPlayerController();
  BetterPlayerConfiguration betterPlayerConfiguration =
      BetterPlayerConfiguration(autoPlay: false);
  List<Exercise> exercisesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: ExerciseCollection,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExerciseNameCollection()),
          );
        },
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseDetailsCollection(
                                  exerciseName:
                                      exercisesList[index].exerciseName,
                                  exerciseUid: exercisesList[index].exerciseUid,
                                )),
                      );
                    },
                    more: PopupMenuButton(
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              //Edit name
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseNameCollection(
                                    isEdit: true,
                                    exercise: exercisesList[index],
                                    exerciseIndex: exercisesList.length + 1,
                                  ),
                                ),
                              );
                              break;
                            case 2:
                              //duplicate
                              _bloc.duplicateExerciseCollection(
                                exercisesList[index],
                              );
                              break;
                            case 3:
                              //delete
                              _bloc.deleteExerciseFromCollection(
                                  exercisesList[index].exerciseUid);
                              break;
                          }
                        },
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) =>
                            kExerciseCardCollectionPopUpMenuList),
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
