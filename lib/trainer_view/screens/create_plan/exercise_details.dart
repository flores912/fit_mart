import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/chewie_player_widget.dart';
import 'package:fit_mart/custom_widgets/set_card.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/trainer_view/blocs/exercise_details_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../constants.dart';

class ExerciseDetails extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final String exerciseUid;

  const ExerciseDetails(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.exerciseUid})
      : super(key: key);

  @override
  _ExerciseDetailsState createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  ExerciseDetailsBloc _bloc = ExerciseDetailsBloc();
  VideoPlayerController _controller;
  String videoUrl;

  File videoFile;

  List<Set> setsList = [];
  @override
  void initState() {
    if (videoUrl != null) {
      _controller = VideoPlayerController.network(videoUrl);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text(kSave),
            onPressed: () {
              print(widget.weekUid);
              _bloc
                  .downloadURL(videoFile, widget.exerciseUid, 'video/mp4')
                  .then((value) {
                videoUrl = value;
              }).whenComplete(
                () => _bloc
                    .updateExerciseDetails(
                        videoUrl,
                        setsList.length,
                        widget.workoutPlanUid,
                        widget.weekUid,
                        widget.workoutUid,
                        widget.exerciseUid)
                    .whenComplete(
                      () => Navigator.pop(context),
                    ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Set'),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditSet(
                workoutPlanUid: widget.workoutPlanUid,
                weekUid: widget.weekUid,
                workoutUid: widget.workoutUid,
                exerciseUid: widget.exerciseUid,
                set: setsList.length + 1,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _controller != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 1.78,
                    child: ChewiePlayerWidget(
                      autoPlay: false,
                      looping: false,
                      showControls: true,
                      videoPlayerController: _controller,
                    ),
                  )
                : Container(),
            OutlineButton(
              child: Text(_controller == null ? kAddVideo : kChangeVideo),
              onPressed: () {
                showAddVideoDialog();
              },
            ),
            Card(
              child: ListTile(
                title: Text(kSets),
                subtitle: setsListView(),
              ),
            )
          ],
        ),
      ),
    );
  }

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

  showAddVideoDialog() {
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
  }

  Future getVideo(bool isCamera) async {
    final picker = ImagePicker();

    final pickedVideo = await picker.getVideo(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      videoFile = File(pickedVideo.path);
    });
    //cropImage(pickedFile.path);
  }

  List<Set> buildSetsList(List<DocumentSnapshot> docList) {
    List<Set> setsList = [];
    docList.forEach((element) {
      Set set = Set(
        reps: element.get('reps'),
        rest: element.get('rest'),
        set: element.get('set'),
      );
      setsList.add(set);
    });
    return setsList;
  }

  Widget setsListView() {
    return StreamBuilder(
        stream: _bloc.getSets(widget.workoutPlanUid, widget.weekUid,
            widget.workoutUid, widget.exerciseUid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            setsList = buildSetsList(
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
                return SetCard(
                  set: setsList[index].set,
                  reps: setsList[index].reps,
                  rest: setsList[index].rest,
                  more: PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            //Edit exercise name

                            break;
                          case 2:
                            //Edit exercise sets

                            break;
                          case 3:
                            // swap exercise

                            break;
                          case 4:
                            //delete exercise

                            break;
                        }
                      },
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) =>
                          kExerciseCardPopUpMenuList),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}