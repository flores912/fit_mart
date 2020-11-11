import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/exercises_bloc.dart';
import 'package:fit_mart/blocs/exercises_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/my_workout_plan.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/widgets/exercise_workout_session_widget.dart';
import 'package:fit_mart/widgets/round_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutSessionScreen extends StatefulWidget {
  static const String id = 'workout_session_screen';
  final Workout workout;
  final MyWorkoutPlan myWorkoutPlan;

  const WorkoutSessionScreen(
      {Key key, @required this.workout, @required this.myWorkoutPlan})
      : super(key: key);

  @override
  WorkoutSessionScreenState createState() => WorkoutSessionScreenState();
}

class WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  ExercisesBloc _bloc;
  Color statusColor;

  final ScrollController _scrollController = ScrollController();

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = ExercisesBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.workout.title),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _bloc.exercisesQuerySnapshot('flores@gmail.com',
                    widget.myWorkoutPlan.uid, widget.workout.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshotExercise) {
                  if (snapshotExercise.hasData) {
                    List<DocumentSnapshot> docsExercise =
                        snapshotExercise.data.docs;
                    List<Exercise> exercisesList =
                        _bloc.exercisesList(docList: docsExercise);
                    return Scrollbar(
                      child: buildExercisesList(exercisesList),
                      isAlwaysShown: true,
                      controller: _scrollController,
                    );
                  } else {
                    return Text('No Exercises');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildSetsList(List<Set> setsList, String exerciseUid) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: setsList.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                'Set ${setsList[index].numOfSet.toString()}',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
              ),
            ),
            Expanded(
              flex: 0,
              child: RoundButtonWidget(
                nestedWidget: setStatusWidget(
                    setsList[index].isSetDone, setsList[index].reps),
                color: statusColor,
                onTap: () async {
                  if (setsList[index].isSetDone == false) {
                    await _bloc.updateSetProgress(
                        'flores@gmail.com',
                        widget.myWorkoutPlan.uid,
                        widget.workout.uid,
                        exerciseUid,
                        setsList[index].uid,
                        true);
                  } else {
                    await _bloc.updateSetProgress(
                        'flores@gmail.com',
                        widget.myWorkoutPlan.uid,
                        widget.workout.uid,
                        exerciseUid,
                        setsList[index].uid,
                        false);
                  }
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${setsList[index].weight.toString()} lbs',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
          ],
        );
      },
    );
  }

  Widget setStatusWidget(bool isSetDone, int reps) {
    Widget statusWidget;
    if (isSetDone == false) {
      statusColor = Colors.grey;
      statusWidget = Center(
        child: Text(
          reps.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    } else if (isSetDone == true) {
      statusColor = kPrimaryColor;
      statusWidget = Icon(
        Icons.check,
        color: Colors.white,
        size: 36,
      );
    }
    return statusWidget;
  }

  ListView buildExercisesList(List<Exercise> exercisesList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: exercisesList.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        return StreamBuilder(
            stream: _bloc.setsQuerySnapshot(
                'flores@gmail.com',
                widget.myWorkoutPlan.uid,
                widget.workout.uid,
                exercisesList[index].uid),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshotSet) {
              List<Set> setsList = [];
              if (snapshotSet.hasData) {
                List<DocumentSnapshot> docsSet = snapshotSet.data.docs;
                setsList = _bloc.setList(docList: docsSet);
              }
              ListView setsListView =
                  buildSetsList(setsList, exercisesList[index].uid);
              return ExerciseWorkoutSessionWidget(
                exerciseTitle: exercisesList[index].title,
                videoUrl: exercisesList[index].videoUrl,
                colorContainer: Colors.white,
                setsList: setsListView,
              );
            });
      },
    );
  }
}
