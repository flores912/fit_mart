import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/screens/home/plan_overview.dart';
import 'package:fit_mart/trainer_view/screens/home/workouts_preview.dart';
import 'package:flutter/material.dart';

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
      icon: Icon(Icons.preview),
    ),
    Tab(icon: Icon(Icons.fitness_center)),
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
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                height: kToolbarHeight,
                child: TabBar(
                  tabs: list,
                ),
              )),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              PlanOverview(
                workoutPlan: widget.workoutPlan,
              ),
              WorkoutsPreview(
                workoutPlan: widget.workoutPlan,
              )
            ],
          ),
        ),
      ),
    );
  }
}
