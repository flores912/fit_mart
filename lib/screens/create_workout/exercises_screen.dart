import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/add_exercises_screen_bloc.dart';
import 'package:fit_mart/blocs/add_exercises_screen_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_exercise/new_exercise_screen.dart';
import 'package:fit_mart/widgets/exercise_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ExercisesScreen extends StatefulWidget {
  static const String id = 'exercises_screen';

  final String workoutTitle;
  final String workoutPlanUid;
  final String workoutUid;
  final bool isEdit;

  const ExercisesScreen(
      {Key key,
      this.workoutTitle,
      this.workoutPlanUid,
      this.workoutUid,
      this.isEdit})
      : super(key: key);

  @override
  ExercisesScreenState createState() => ExercisesScreenState();
}

class ExercisesScreenState extends State<ExercisesScreen> {
  FirestoreProvider firestoreProvider = FirestoreProvider();

  String exerciseUid;

  AddExercisesScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = AddExercisesScreenBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext dialogContext) {
                  return SimpleDialog(
                    title: Text(
                      'Add Exercises',
                    ),
                    children: [
                      SimpleDialogOption(
                        // onPressed: () {
                        //   Navigator.pushNamed(
                        //           context, AddExercisesListScreen.id)
                        //       .whenComplete(
                        //     () => Navigator.pop(dialogContext),
                        //   );
                        // },
                        child: const Text(
                          'Add exercises from library',
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          firestoreProvider
                              .addNewExerciseToWorkout(widget.workoutPlanUid,
                                  widget.workoutUid, null, null)
                              .then((value) {
                            exerciseUid = value.id;
                          }).whenComplete(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewExerciseScreen(
                                  workoutPlanUid: widget.workoutPlanUid,
                                  workoutUid: widget.workoutUid,
                                  exerciseUid: exerciseUid,
                                ),
                              ),
                            ).whenComplete(
                              () => Navigator.pop(dialogContext),
                            );
                          });
                        },
                        child: const Text('Create new exercise'),
                      ),
                    ],
                  );
                });
          },
          label: Text('ADD EXERCISE'),
          icon: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.workoutTitle),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: firestoreProvider.exercisesQuerySnapshot(
                widget.workoutPlanUid, widget.workoutUid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> docs = snapshot.data.docs;
                List<Exercise> exercisesList =
                    _bloc.convertToExercisesList(docList: docs);

                if (exercisesList.isNotEmpty) {
                  return buildList(exercisesList);
                } else {
                  return Center(child: Text('Start adding exercises'));
                }
              } else {
                return Center(child: Text('Start adding exercises'));
              }
            }),
      ),
    );
  }

  ListView buildList(List<Exercise> myExercisesList) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
      itemCount: myExercisesList.length,
      itemBuilder: (context, index) {
        File thumbnailFile;
        Uint8List bytes;
        getThumbnailPath(myExercisesList[index].videoUrl).then((value) {
          thumbnailFile = File(value);
          bytes = thumbnailFile.readAsBytesSync();
          print(bytes.isEmpty);
        });
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewExerciseScreen(
                  workoutPlanUid: widget.workoutPlanUid,
                  workoutUid: widget.workoutUid,
                  exerciseUid: myExercisesList[index].uid,
                  exerciseTitle: myExercisesList[index].title,
                  exerciseVideoUrl: myExercisesList[index].videoUrl,
                ),
              ),
            );
          },
          child: ExerciseCardWidget(
            title: myExercisesList[index].title,
            videoUrl: myExercisesList[index].videoUrl,
          ),
        );
      },
    );
  }

  //TODO IMPLEMENT THUMBNAILS INSTEAD OF VIDEOS TO AVOID EXOPLAYER FORM CRASHING BECAUSE OF TO MANY RESOURCES OPENED
  Future<String> getThumbnailPath(String videoUrl) async {
    return await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
  }
}
