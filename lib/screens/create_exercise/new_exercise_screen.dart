import 'dart:io';
import 'package:better_player/better_player.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fit_mart/blocs/create_new_exercise_title_screen_bloc.dart';
import 'package:fit_mart/blocs/create_new_exercise_title_screen_bloc_provider.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/widgets/better_player_widget.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:fit_mart/widgets/edit_set_widget.dart';
import 'package:fit_mart/widgets/chewie_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';

class NewExerciseScreen extends StatefulWidget {
  static const String title = 'Edit Exercise';
  static const String id = 'new_exercise_title_screen';

  final String workoutPlanUid;
  final String workoutUid;
  final String exerciseUid;
  final String exerciseTitle;
  final String exerciseVideoUrl;

  const NewExerciseScreen(
      {Key key,
      this.workoutPlanUid,
      this.workoutUid,
      this.exerciseUid,
      this.exerciseTitle,
      this.exerciseVideoUrl})
      : super(key: key);

  @override
  NewExerciseScreenState createState() => NewExerciseScreenState();
}

class NewExerciseScreenState extends State<NewExerciseScreen> {
  int rest;

  var videoUrl;

  int reps;

  int sets;

  String title;

  final picker = ImagePicker();

  File videoFile;

  VideoPlayerController _controller;

  FirestoreProvider firestoreProvider = FirestoreProvider();

  CreateNewExerciseTitleScreenBloc _bloc;

  List<Set> mySetsList;
  List<int> updatedSetsReps = [];
  List<int> updatedSetsRest = [];

  bool isKeyboardVisible = false;

  bool autoFocus = false;

  void _initController(File file) {
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> _onControllerChange(File file) async {
    if (_controller == null) {
      // If there was no controller, just create a new one
      _initController(file);
    } else {
      // If there was a controller, we need to dispose of the old one first
      final oldController = _controller;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController.dispose();

        // Initiating new controller
        _initController(file);
      });

      // Making sure that controller is not used by setting it to null
      setState(() {
        _controller = null;
      });
    }
  }

  Future getVideo(bool isCamera) async {
    final pickedVideo = await picker.getVideo(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      videoFile = File(pickedVideo.path);
    });
    //cropImage(pickedFile.path);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = CreateNewExerciseTitleScreenBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
    title = widget.exerciseTitle;
    videoUrl = widget.exerciseVideoUrl;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            firestoreProvider.addNewSetToExercise(
                widget.workoutPlanUid,
                widget.workoutUid,
                widget.exerciseUid,
                mySetsList.length + 1,
                null,
                null);
          },
          label: Text('Add new set'),
          icon: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text(NewExerciseScreen.title),
        actions: [
          FlatButton(
            onPressed: () {
              if (videoFile != null) {
                firestoreProvider
                    .downloadURL(videoFile, widget.exerciseUid, 'video/mp4')
                    .then((value) {
                  videoUrl = value;
                  firestoreProvider
                      .updateNewExerciseForWorkout(
                    widget.workoutPlanUid,
                    widget.workoutUid,
                    widget.exerciseUid,
                    title,
                    videoUrl,
                  )
                      .whenComplete(() {
                    //save
                    for (var i = 0; i < mySetsList.length; i++) {
                      firestoreProvider.updateSetForExercise(
                          widget.workoutPlanUid,
                          widget.workoutUid,
                          widget.exerciseUid,
                          mySetsList[i].uid,
                          updatedSetsReps[i],
                          updatedSetsRest[i]);
                    }
                  }).whenComplete(() => Navigator.pop(context));
                });
              } else {
                firestoreProvider
                    .updateNewExerciseForWorkout(
                  widget.workoutPlanUid,
                  widget.workoutUid,
                  widget.exerciseUid,
                  title,
                  videoUrl,
                )
                    .whenComplete(() {
                  //save
                  for (var i = 0; i < mySetsList.length; i++) {
                    firestoreProvider.updateSetForExercise(
                        widget.workoutPlanUid,
                        widget.workoutUid,
                        widget.exerciseUid,
                        mySetsList[i].uid,
                        updatedSetsReps[i],
                        updatedSetsRest[i]);
                  }
                }).whenComplete(() => Navigator.pop(context));
              }

              //next step
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: videoUrl == null
                        ? Container(
                            color: Colors.grey.shade300,
                            height: MediaQuery.of(context).size.width / 1.78,
                            child: this._controller != null
                                ? ChewiePlayerWidget(
                                    looping: false,
                                    autoPlay: false,
                                    showControls: true,
                                    videoPlayerController: _controller)
                                : Container(
                                    height: MediaQuery.of(context).size.width /
                                        1.78,
                                    child: Icon(
                                      Icons.play_circle_outline_rounded,
                                      color: Colors.white,
                                    ),
                                  ))
                        : Container(
                            height: MediaQuery.of(context).size.width / 1.78,
                            child: BetterPlayerWidget(
                              showControls: true,
                              autoPlay: false,
                              aspectRatio: 1,
                              looping: false,
                              betterPlayerDataSource:
                                  BetterPlayerDataSource.network(videoUrl),
                            ),
                          )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      textColor: kPrimaryColor,
                      child: Text(
                        'Add video demo',
                      ),
                      onPressed: () {
                        // getVideo(false).whenComplete(() {
                        //   // final StorageReference storageRef =
                        //   //     FirebaseStorage.instance.ref().child('exerciseUid');
                        //   // final StorageUploadTask task = storageRef.putFile(
                        //   //     videoFile,
                        //   //     StorageMetadata(contentType: 'video/mp4'));
                        //   _onControllerChange(videoFile);
                        // });
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext dialogContext) {
                            return SimpleDialog(
                              title: Text(
                                'Add video from...',
                              ),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    getVideo(false).whenComplete(() {
                                      if (videoFile != null) {
                                        _onControllerChange(videoFile);
                                      }
                                    });
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text(
                                    'Gallery',
                                  ),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    getVideo(true).whenComplete(() {
                                      if (videoFile != null) {
                                        _onControllerChange(videoFile);
                                      }
                                    });
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('Record from camera'),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextForm(
                    textInputType: TextInputType.text,
                    labelText: 'Title',
                    obscureText: false,
                    initialValue: widget.exerciseTitle,
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sets',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: StreamBuilder(
                        stream: firestoreProvider.exerciseSetsQuerySnapshot(
                            widget.workoutPlanUid,
                            widget.workoutUid,
                            widget.exerciseUid),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> docs = snapshot.data.docs;
                            mySetsList = _bloc.convertToSetsList(docList: docs);

                            if (mySetsList.isNotEmpty) {
                              return Scrollbar(child: buildList(mySetsList));
                            } else {
                              return Center(child: Text('Start adding sets!'));
                            }
                          } else {
                            return Center(child: Text('Start adding sets!'));
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ReorderableListView buildList(List<Set> mySetsList) {
    return ReorderableListView(
      children: List.generate(mySetsList.length, (index) {
        reps = mySetsList[index].reps;
        updatedSetsReps.add(reps);
        rest = mySetsList[index].rest;
        updatedSetsRest.add(rest);
        return EditSetWidget(
          key: ValueKey(mySetsList[index].uid),
          set: index + 1,
          reps: mySetsList[index].reps,
          rest: mySetsList[index].rest,
          onChangedReps: (reps) {
            setState(() {
              updatedSetsReps[index] = int.parse(reps);
            });
          },
          onChangedRest: (rest) {
            setState(() {
              updatedSetsRest[index] = int.parse(rest);
            });
          },
        );
      }),
      onReorder: (int oldIndex, int newIndex) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        setState(() {
          firestoreProvider
              .updateSetOrderForExercise(
            widget.workoutPlanUid,
            widget.workoutUid,
            widget.exerciseUid,
            mySetsList[oldIndex].uid,
            newIndex + 1,
          )
              .whenComplete(() {
            firestoreProvider.updateSetOrderForExercise(
              widget.workoutPlanUid,
              widget.workoutUid,
              widget.exerciseUid,
              mySetsList[newIndex].uid,
              oldIndex + 1,
            );
          });
        });
      },
    );
  }
}
