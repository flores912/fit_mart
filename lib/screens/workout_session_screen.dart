import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/exercises_bloc.dart';
import 'package:fit_mart/blocs/exercises_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/my_workout_plan.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/widgets/chewie_widget.dart';
import 'package:fit_mart/widgets/exercise_workout_session_widget.dart';
import 'package:fit_mart/widgets/round_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = ExercisesBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //TODO: place video player here!
            ChewieWidget(
              looping: true,
              videoPlayerController: VideoPlayerController.network(
                  'https://dm0qx8t0i9gc9.cloudfront.net/watermarks/video/Hc_TvUoHMjcyusz29/videoblocks-fit-woman-doing-squats_r4l97majm__52f696f9d187def3eab49eb078f2d0c5__P360.mp4'),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _bloc.exercisesQuerySnapshot('flores@gmail.com',
                    widget.myWorkoutPlan.uid, widget.workout.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshotExercise) {
                  if (snapshotExercise.hasData) {
                    print(snapshotExercise.data.size);
                    List<DocumentSnapshot> docsExercise =
                        snapshotExercise.data.docs;
                    List<Exercise> exercisesList =
                        _bloc.exercisesList(docList: docsExercise);
                    return buildExercisesList(exercisesList);
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

  ListView buildSetsList(List<Set> setsList) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: setsList.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            RoundButtonWidget(
              nestedWidget: setStatusWidget(
                  setsList[index].isSetDone, setsList[index].reps),
              color: statusColor,
              onTap: () {
                //TODO: implement on tap method
              },
            ),
            SizedBox(
              width: 8,
            )
          ],
        );
      },
    );
  }

  ListView buildExercisesList(List<Exercise> exercisesList) {
    return ListView.builder(
      //TODO: IMPLEMENT A SCROLL CONTROLLER TO GET CURRENT SCROLL POSITION AND UPDATE VIDEO ACCORDING TO THE ITEM.
      scrollDirection: Axis.vertical,
      itemCount: exercisesList.length,
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
              ListView setsListView = buildSetsList(setsList);
              return ExerciseWorkoutSessionWidget(
                title: exercisesList[index].title,
                weight: exercisesList[index].weight,
                setsList: setsListView,
              );
            });
      },
    );
  }

  Widget setStatusWidget(bool isSetDone, int reps) {
    Widget statusWidget;
    if (isSetDone == false) {
      statusColor = Colors.grey.shade500;
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
}
