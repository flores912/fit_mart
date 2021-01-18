import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/providers/dynamic_link_provider.dart';
import 'package:fit_mart/trainer_view/screens/home/plan_overview.dart';
import 'package:fit_mart/trainer_view/screens/home/trainer_account.dart';
import 'package:fit_mart/trainer_view/screens/home/workouts_preview.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class WorkoutPlanPreview extends StatefulWidget {
  final WorkoutPlan workoutPlan;
  const WorkoutPlanPreview({
    Key key,
    this.workoutPlan,
  }) : super(key: key);

  @override
  _WorkoutPlanPreviewState createState() => _WorkoutPlanPreviewState();
}

class _WorkoutPlanPreviewState extends State<WorkoutPlanPreview>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(
      icon: Icon(
        Icons.preview,
      ),
      child: Text('Overview'),
    ),
    Tab(
      icon: Icon(Icons.fitness_center),
      child: Text('Workouts'),
    ),
    Tab(
      icon: Icon(Icons.account_circle),
      child: Text('Trainer'),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: list.length,
        initialIndex: _selectedIndex,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Plan Preview'),
            actions: [
              GestureDetector(
                  onTap: () {
                    DynamicLinkProvider dynamicLinkProvider =
                        DynamicLinkProvider();
                    dynamicLinkProvider
                        .createWorkoutPlanLink(widget.workoutPlan)
                        .then((link) => Share.share(link));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.share),
                  ))
            ],
            bottom: TabBar(
              tabs: list,
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              PlanOverview(
                workoutPlan: widget.workoutPlan,
              ),
              WorkoutsPreview(
                workoutPlan: widget.workoutPlan,
              ),
              TrainerAccount(
                userUid: widget.workoutPlan.userUid,
              )
            ],
          ),
        ),
      ),
    );
  }
}
