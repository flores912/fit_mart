import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/exercise_sets_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:fit_mart/widgets/video_player_workout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

class CreateNewExerciseTitleScreen extends StatefulWidget {
  static const String title = 'New Exercise';
  static const String id = 'create_new_exercise_title_screen';

  final String workoutPlanUid;
  final String workoutUid;

  const CreateNewExerciseTitleScreen(
      {Key key, this.workoutPlanUid, this.workoutUid})
      : super(key: key);

  @override
  CreateNewExerciseTitleScreenState createState() =>
      CreateNewExerciseTitleScreenState();
}

class CreateNewExerciseTitleScreenState
    extends State<CreateNewExerciseTitleScreen> {
  int rest;

  var videoUrl;

  int reps;

  int sets;

  String title;

  final picker = ImagePicker();

  File videoFile;

  VideoPlayerController _controller;

  File newVideoFile;

  FirestoreProvider firestoreProvider = FirestoreProvider();

  String exerciseUid;

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(CreateNewExerciseTitleScreen.title),
        actions: [
          FlatButton(
            onPressed: () {
              print(widget.workoutUid);
              firestoreProvider.uploadVideoFile(videoFile).whenComplete(() {
                firestoreProvider.downloadURL(videoFile.path).then((value) {
                  videoUrl = value;
                  firestoreProvider
                      .addNewExerciseToWorkout(
                        widget.workoutPlanUid,
                        widget.workoutUid,
                        title,
                        videoUrl,
                      )
                      .then((value) => exerciseUid = value.id)
                      .whenComplete(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseSetsScreen(
                                workoutPlanUid: widget.workoutPlanUid,
                                workoutUid: widget.workoutUid,
                                exerciseUid: exerciseUid,
                                exerciseTitle: title,
                              ),
                            ),
                          ));
                });
              });
              //next step
            },
            child: Text(
              'Next',
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
                    child: this._controller != null
                        ? Container(
                            height: MediaQuery.of(context).size.width / 1.78,
                            child: VideoPlayerWorkoutWidget(
                              looping: false,
                              videoPlayerController: _controller,
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade300,
                            height: MediaQuery.of(context).size.width / 1.78,
                            child: Icon(
                              Icons.play_circle_outline_rounded,
                              color: Colors.white,
                              size: 100,
                            ))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: kPrimaryColor,
                      child: Text(
                        'Add video demo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                                    getVideo(false).whenComplete(
                                        () => _onControllerChange(videoFile));
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text(
                                    'Gallery',
                                  ),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    getVideo(true).whenComplete(
                                        () => _onControllerChange(videoFile));
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
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
