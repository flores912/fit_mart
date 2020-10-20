import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/my_plan_workouts_bloc.dart';
import 'package:fit_mart/blocs/my_plan_workouts_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/my_workout_plan.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/screens/workout_session_screen.dart';
import 'package:fit_mart/widgets/current_plan_workout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPlanWorkoutsScreen extends StatefulWidget {
  static const String id = 'current_workout_plan_workouts_screen';
  final MyWorkoutPlan myWorkoutPlan;

  const MyPlanWorkoutsScreen({Key key, @required this.myWorkoutPlan})
      : super(key: key);

  @override
  MyPlanWorkoutsScreenState createState() => MyPlanWorkoutsScreenState();
}

class MyPlanWorkoutsScreenState extends State<MyPlanWorkoutsScreen> {
  MyPlanWorkoutsBloc _bloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _bloc = MyPlanWorkoutsBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: _bloc.currentPlanWorkoutsQuerySnapshot(
              'flores@gmail.com', widget.myWorkoutPlan.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              List<Workout> myPlanWorkoutsList =
                  _bloc.myPlanWorkoutsList(docList: docs);

              if (myPlanWorkoutsList.isNotEmpty) {
                return buildList(myPlanWorkoutsList);
              } else {
                return Center(child: Text('No workout plans'));
              }
            } else {
              return Center(child: Text('No workout plans'));
            }
          }),
    );
  }

  ListView buildList(List<Workout> myPlanWorkoutsList) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1,
        color: Colors.black,
      ),
      itemCount: myPlanWorkoutsList.length,
      itemBuilder: (context, index) {
        bool isDone = myPlanWorkoutsList[index].isDone;
        String title = myPlanWorkoutsList[index].title;
        int day = myPlanWorkoutsList[index].day;

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkoutSessionScreen(
                          myWorkoutPlan: widget.myWorkoutPlan,
                          workout: myPlanWorkoutsList[index],
                        )));
          },
          child: CurrentPlanWorkoutWidget(
            onTapCheckmark: () {
              //TODO: UPDATE isDone status on firebase here
            },
            nestWidget: Center(
                child: Icon(
              Icons.check,
              color: Colors.white,
              size: 36,
            )),
            title: title,
            checkMarkButtonColor: isDone ? kPrimaryColor : Colors.grey,
            isDone: isDone,
            day: day,
          ),
        );
      },
    );
  }
}
