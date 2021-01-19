import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/custom_widgets/chewie_player_widget.dart';
import 'package:fit_mart/login_signup/screens/login.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plan_overview_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

class PlanOverview extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const PlanOverview({Key key, this.workoutPlan}) : super(key: key);
  @override
  _PlanOverviewState createState() => _PlanOverviewState();
}

class _PlanOverviewState extends State<PlanOverview> {
  PlanOverviewBloc _bloc = PlanOverviewBloc();
  VideoPlayerController _controller;
  String videoUrl;

  @override
  initState() {
    getVideoUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FirebaseAuth.instance.currentUser == null ||
              widget.workoutPlan.users
                          .contains(FirebaseAuth.instance.currentUser.uid) ==
                      false &&
                  widget.workoutPlan.userUid !=
                      FirebaseAuth.instance.currentUser.uid
          ? FloatingActionButton.extended(
              heroTag: 'Add Workout Plan',
              icon: Icon(Icons.add),
              onPressed: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  Get.to(Login());
                } else {
                  EasyLoading.show();
                  _bloc
                      .addPlanToMyList(widget.workoutPlan.uid)
                      .whenComplete(() {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Workout Plan Added.')));
                      })
                      .whenComplete(() => EasyLoading.dismiss())
                      .whenComplete(() => Get.offAll((HomeTrainer())));
                }
              },
              label: Text('Add Plan'),
            )
          : Container(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: _controller != null
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  widget.workoutPlan.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
                child: Text(
                  'by ' + widget.workoutPlan.trainerName,
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: widget.workoutPlan.description != null
                    ? ReadMoreText(
                        widget.workoutPlan.description,
                        trimLines: 6,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        style: TextStyle(fontSize: 18),
                      )
                    : Text(
                        '(No description.)',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                ' Weeks',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                widget.workoutPlan.weeks.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Type',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                widget.workoutPlan.type.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Level',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                widget.workoutPlan.level.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Location',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                widget.workoutPlan.location.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getVideoUrl() async {
    await _bloc.getPlanDetails(widget.workoutPlan.uid).then((value) async {
      videoUrl = await value.get('promoVideoUrl');
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
}
