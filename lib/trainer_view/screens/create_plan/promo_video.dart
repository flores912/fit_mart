import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/chewie_player_widget.dart';
import 'package:fit_mart/trainer_view/blocs/promo_video_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../constants.dart';

class PromoVideo extends StatefulWidget {
  final String workoutPlanUid;

  const PromoVideo({Key key, this.workoutPlanUid}) : super(key: key);
  @override
  _PromoVideoState createState() => _PromoVideoState();
}

class _PromoVideoState extends State<PromoVideo> {
  PromoVideoBloc _bloc = PromoVideoBloc();
  VideoPlayerController _controller;
  String videoUrl;

  File videoFile;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: _controller != null ? Text(kNext) : Text(kSkip),
            onPressed: () async {
              videoUrl = await _bloc
                  .downloadURL(videoFile, widget.workoutPlanUid + '/promoVideo',
                      'video/mp4')
                  .whenComplete(
                    () =>
                        _bloc.updatePlanPromo(widget.workoutPlanUid, videoUrl),
                  )
                  .whenComplete(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPlan(
                          workoutPlanUid: widget.workoutPlanUid,
                        ),
                      ),
                    ),
                  );
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _bloc.getPlanDetails(widget.workoutPlanUid),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  videoUrl = snapshot.data.get('promoVideoUrl');
                  if (videoUrl != null) {
                    _controller = VideoPlayerController.network(videoUrl);
                  }
                  return Column(
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
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 1.78,
                              color: CupertinoColors.placeholderText,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text(
                              _controller == null ? kAddVideo : kChangeVideo),
                          onPressed: () {
                            showAddVideoDialog();
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
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
              child: const Text('Camera'),
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
}