import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/chewie_player_widget.dart';
import 'package:fit_mart/custom_widgets/set_card.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/trainer_view/blocs/exercise_details_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../constants.dart';

class ExerciseDetails extends StatefulWidget {
  final String workoutPlanUid;
  final String weekUid;
  final String workoutUid;
  final String exerciseUid;
  final String exerciseName;

  const ExerciseDetails(
      {Key key,
      this.workoutPlanUid,
      this.weekUid,
      this.workoutUid,
      this.exerciseUid,
      this.exerciseName})
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
                  //save
                  if (videoFile != null) {
                    //video was taken save to db
                    EasyLoading.show();
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
                          .whenComplete(() => EasyLoading.dismiss())
                          .whenComplete(
                            () => Navigator.pop(context),
                          ),
                    );
                  } else {
                    //else just save the other details
                    EasyLoading.show();
                    _bloc
                        .updateExerciseDetails(
                            videoUrl,
                            setsList.length,
                            widget.workoutPlanUid,
                            widget.weekUid,
                            widget.workoutUid,
                            widget.exerciseUid)
                        .whenComplete(() => EasyLoading.dismiss())
                        .whenComplete(
                          () => Navigator.pop(context),
                        );
                  }
                })
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
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future getVideoUrl() async {
    EasyLoading.show();
    await _bloc
        .getExerciseDetails(widget.workoutPlanUid, widget.weekUid,
            widget.workoutUid, widget.exerciseUid)
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
    }).whenComplete(() => EasyLoading.dismiss());
  }

  void _initController(File file) {
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          duration = _controller.value.duration.inSeconds;

          //TODO handle exception when user doesnt upload a file
          validateDurationOfVideo();
        });
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
                getVideo(false).whenComplete(() async {
                  if (videoFile != null) {
                    _onControllerChange(videoFile).whenComplete(() {});
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
                  isFailure: setsList[index].isFailure,
                  isTimed: setsList[index].isTimed,
                  set: setsList[index].set,
                  reps: setsList[index].reps,
                  rest: setsList[index].rest,
                  more: PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            Get.to(EditSet(
                              exerciseUid: widget.exerciseUid,
                              workoutPlanUid: widget.workoutPlanUid,
                              weekUid: widget.weekUid,
                              workoutUid: widget.workoutUid,
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
    EasyLoading.show();
    await _bloc
        .deleteSetFromExercise(widget.workoutPlanUid, widget.weekUid,
            widget.workoutUid, widget.exerciseUid, setsList[index].setUid)
        .whenComplete(() async => await _bloc.updateExerciseDetailsNumberOfSets(
            setsList.length,
            widget.workoutPlanUid,
            widget.weekUid,
            widget.workoutUid,
            widget.exerciseUid))
        .whenComplete(() async {
      for (int i = 0; i < setsList.length; i++) {
        await _bloc.updateSetIndex(widget.workoutPlanUid, widget.weekUid,
            widget.workoutUid, widget.exerciseUid, setsList[i].setUid, i + 1);
      }
    }).whenComplete(() => EasyLoading.dismiss());
  }
}
