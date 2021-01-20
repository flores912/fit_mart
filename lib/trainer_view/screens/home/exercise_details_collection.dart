import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/chewie_player_widget.dart';
import 'package:fit_mart/custom_widgets/set_card.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/trainer_view/blocs/exercise_details_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_set.dart';
import 'package:fit_mart/trainer_view/screens/home/edit_set_collection.dart';
import 'package:fit_mart/trainer_view/screens/home/exercise_name_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../constants.dart';

class ExerciseDetailsCollection extends StatefulWidget {
  final String exerciseUid;
  final String exerciseName;

  const ExerciseDetailsCollection(
      {Key key, this.exerciseUid, this.exerciseName})
      : super(key: key);
  @override
  _ExerciseDetailsCollectionState createState() =>
      _ExerciseDetailsCollectionState();
}

class _ExerciseDetailsCollectionState extends State<ExerciseDetailsCollection> {
  ExerciseDetailsBloc _bloc = ExerciseDetailsBloc();
  VideoPlayerController _controller;
  String videoUrl;

  File videoFile;

  List<Set> setsList = [];

  int duration;

  bool isVideoRemoved;

  @override
  void initState() {
    getVideoUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.exerciseName),
          actions: [
            FlatButton(
              child: Text(kSave),
              onPressed: () {
                {
                  if (videoFile != null) {
                    _bloc
                        .downloadURL(videoFile, widget.exerciseUid, 'video/mp4')
                        .then((value) {
                      videoUrl = value;
                    }).whenComplete(
                      () => _bloc
                          .updateExerciseDetailsCollection(
                              videoUrl, setsList.length, widget.exerciseUid)
                          .whenComplete(
                            () => Navigator.pop(context),
                          ),
                    );
                  } else {
                    _bloc
                        .updateExerciseDetailsCollection(
                            videoUrl, setsList.length, widget.exerciseUid)
                        .whenComplete(() => Navigator.pop(context));
                  }
                }
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
                builder: (context) => EditSetCollection(
                  exerciseUid: widget.exerciseUid,
                  numberOfSet: setsList.length + 1,
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _controller != null
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Recommended Aspect Ratio : 16:9'),
                          ),
                          Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 9 / 16,
                            child: ChewiePlayerWidget(
                              autoPlay: false,
                              looping: false,
                              showControls: true,
                              videoPlayerController: _controller,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                OutlineButton(
                  child: Text(_controller == null ? kAddVideo : kChangeVideo),
                  onPressed: () {
                    showAddVideoDialog();
                  },
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sets',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        setsListView(),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  Future getVideoUrl() async {
    await _bloc
        .getExerciseDetailsFromCollection(widget.exerciseUid)
        .then((value) async {
      videoUrl = await value.get('videoUrl');
    }).whenComplete(() {
      if (videoUrl != null) {
        if (mounted) {
          setState(() {
            _controller = VideoPlayerController.network(videoUrl);
          });
        }
      }
    });
  }

  void _initController(File file) {
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          duration = _controller.value.duration.inSeconds;
          validateDurationOfVideo();
        });
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
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  isVideoRemoved = true;
                  videoUrl = null;
                  videoFile = null;
                  _onControllerChange(videoFile);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Remove Video',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future getVideo(bool isCamera) async {
    final picker = ImagePicker();

    final pickedVideo = await picker.getVideo(
        maxDuration: Duration(seconds: 60),
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
          isSetInMin: element.get('isSetInMin'),
          isRestInMin: element.get('isRestInMin'),
          isTimed: element.get('isTimed'),
          isFailure: element.get('isFailure'),
          reps: element.get('reps'),
          rest: element.get('rest'),
          set: element.get('set'),
          setUid: element.id);
      setsList.add(set);
    });
    return setsList;
  }

  Widget setsListView() {
    return StreamBuilder(
        stream: _bloc.getSetsCollection(widget.exerciseUid),
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
                  isFailure: setsList[index].isFailure,
                  isTimed: setsList[index].isTimed,
                  set: setsList[index].set,
                  reps: setsList[index].reps,
                  rest: setsList[index].rest,
                  more: PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            Get.to(EditSetCollection(
                              exerciseUid: widget.exerciseUid,
                              set: setsList[index],
                              isEdit: true,
                              numberOfSet: setsList[index].set,
                            ));

                            break;
                          case 2:
                            deleteSet(index);

                            break;
                        }
                      },
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) =>
                          kMyCreatedWorkoutPlanCardPopUpMenuList),
                );
              },
            );
          } else {
            return Center(child: Text('Start Adding Sets!'));
          }
        });
  }

  Future<void> deleteSet(int index) async {
    await _bloc
        .deleteSetFromCollectionExercise(
            widget.exerciseUid, setsList[index].setUid)
        .whenComplete(() async =>
            await _bloc.updateExerciseDetailsNumberOfSetsCollection(
                setsList.length, widget.exerciseUid))
        .whenComplete(() async {
      for (int i = 0; i <= setsList.length; i++) {
        await _bloc.updateSetIndexCollection(
            widget.exerciseUid, setsList[i].setUid, i + 1);
      }
    });
  }

  Future validateDurationOfVideo() async {
    if (duration != null && duration > 60) {
      //dont save
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text('Video Duration'),
            content: Text('Video cannot exceed 60 seconds.')),
      ).whenComplete(() {
        setState(() async {
          //reset controller to null
          duration = null;
          videoFile = null;
          await _onControllerChange(videoFile);
        });
      });
    }
  }
}
