import 'package:fit_mart/custom_widgets/chewie_player_widget.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plan_overview_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    getVideoUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.workoutPlan.trainerName + " 's",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.workoutPlan.title,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.workoutPlan.weeks.toString() + ' Weeks',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.workoutPlan.description,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
