import 'dart:io';

import 'package:fit_mart/blocs/create_plan/promo_video_screen_bloc.dart';
import 'package:fit_mart/blocs/create_plan/promo_video_screen_bloc_provider.dart';
import 'package:fit_mart/screens/edit_workout_plan_screen.dart';
import 'package:fit_mart/widgets/video_player_workout_widget.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/workouts_screen.dart';
import 'package:better_player/better_player.dart';
import 'package:fit_mart/widgets/better_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PromoVideoScreen extends StatefulWidget {
  static const String title = ' Step 7 of 7: Promo Video';
  static const String id = 'video_overview_screen';

  final bool isEdit;
  final String workoutPlanUid;
  final String promoVideoUrl;

  const PromoVideoScreen(
      {Key key, this.isEdit, this.workoutPlanUid, this.promoVideoUrl})
      : super(key: key);

  @override
  PromoVideoScreenState createState() => PromoVideoScreenState();
}

class PromoVideoScreenState extends State<PromoVideoScreen> {
  PromoVideoScreenBloc _bloc;
  VideoPlayerController _controller;

  File videoFile;

  final picker = ImagePicker();

  @override
  void didChangeDependencies() {
    _bloc = PromoVideoScreenBlocProvider.of(context);
    super.didChangeDependencies();
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

  Future getVideo(bool isCamera) async {
    final pickedVideo = await picker.getVideo(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      videoFile = File(pickedVideo.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PromoVideoScreen.title),
        centerTitle: true,
        actions: [
          widget.isEdit == true
              ? FlatButton(
                  onPressed: () {
                    _bloc
                        .downloadURL(videoFile,
                            widget.workoutPlanUid + '/promoVideo', 'video/mp4')
                        .then(
                          (value) => _bloc.updatePromoVideoForWorkoutPlan(
                              widget.workoutPlanUid, value),
                        )
                        .whenComplete(() => Navigator.pop(context));
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : FlatButton(
                  onPressed: () {
                    _bloc
                        .downloadURL(videoFile,
                            widget.workoutPlanUid + '/promoVideo', 'video/mp4')
                        .then(
                          (value) => _bloc.updatePromoVideoForWorkoutPlan(
                              widget.workoutPlanUid, value),
                        )
                        .whenComplete(
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditWorkoutPlanScreen(
                                workoutPlanUid: widget.workoutPlanUid,
                              ),
                            ),
                          ),
                        );
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.promoVideoUrl == null
              ? Container(
                  color: Colors.grey.shade300,
                  height: MediaQuery.of(context).size.width / 1.78,
                  child: this._controller != null
                      ? VideoPlayerWorkoutWidget(
                          looping: false,
                          autoPlay: false,
                          showControls: true,
                          videoPlayerController: _controller)
                      : Container(
                          height: MediaQuery.of(context).size.width / 1.78,
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
                        BetterPlayerDataSource.network(widget.promoVideoUrl),
                  ),
                ),
          RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              textColor: kPrimaryColor,
              child: Text(
                'Add promo video',
              ),
              onPressed: () {
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
        ],
      ),
    );
  }
}
