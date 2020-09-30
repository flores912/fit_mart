import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/current_plan_workouts_bloc.dart';
import 'package:fit_mart/blocs/current_plan_workouts_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/widgets/current_plan_workout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentWorkoutPlanWorkoutsScreen extends StatefulWidget {
  static const String id = 'current_workout_plan_workouts_screen';

  @override
  CurrentWorkoutPlanWorkoutsScreenState createState() =>
      CurrentWorkoutPlanWorkoutsScreenState();
}

class CurrentWorkoutPlanWorkoutsScreenState
    extends State<CurrentWorkoutPlanWorkoutsScreen> {
  CurrentPlanWorkoutsBloc _bloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _bloc = CurrentPlanWorkoutsBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: _bloc.currentPlanWorkoutsQuerySnapshot(_bloc.getEmail()),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> docs = snapshot.data.docs;
                List<Workout> currentPlanWorkoutsList =
                    _bloc.convertToCurrentPlanWorkoutsList(docList: docs);

                if (currentPlanWorkoutsList.isNotEmpty) {
                  return buildList(currentPlanWorkoutsList);
                } else {
                  return Center(child: Text('No workouts'));
                }
              } else {
                return Center(child: Text('No workouts'));
              }
            }),
      ),
    );
  }

  ListView buildList(List<Workout> currentPlanWorkoutsList) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: currentPlanWorkoutsList.length,
      itemBuilder: (context, index) {
        Color isDoneColor;
        if (currentPlanWorkoutsList[index].isDone == true) {
          isDoneColor = kPrimaryColor;
        } else {
          isDoneColor = Colors.grey.shade500;
        }

        return CurrentPlanWorkoutWidget(
          title: currentPlanWorkoutsList[index].title,
          checkMarkButtonColor: isDoneColor,
          isDone: currentPlanWorkoutsList[index].isDone,
          day: currentPlanWorkoutsList[index].day,
        );
      },
    );
  }
}
