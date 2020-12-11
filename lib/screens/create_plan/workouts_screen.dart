import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/create_plan_workouts_bloc.dart';
import 'package:fit_mart/blocs/create_plan_workouts_provider.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/create_workout/exercises_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/price_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_workout/workout_name_screen.dart';
import 'package:fit_mart/widgets/workout_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutsScreen extends StatefulWidget {
  static const String title = 'Step 4 of 7: Workouts';
  static const String id = 'workouts_screen';

  final String workoutPlanUid;
  final bool isEdit;

  const WorkoutsScreen({Key key, this.workoutPlanUid, this.isEdit})
      : super(key: key);

  @override
  WorkoutsScreenState createState() => WorkoutsScreenState();
}

class WorkoutsScreenState extends State<WorkoutsScreen> {
  FirestoreProvider firestoreProvider = FirestoreProvider();

  CreatePlanWorkoutsBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = CreatePlanWorkoutsBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(WorkoutsScreen.title),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateNewPlanPricingScreen.id);
            },
            textColor: Colors.white,
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: firestoreProvider
              .myWorkoutsCreatePlanQuerySnapshot(widget.workoutPlanUid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              List<Workout> myWorkoutPlansList =
                  _bloc.convertToMyWorkoutsList(docList: docs);

              if (myWorkoutPlansList.isNotEmpty) {
                return buildList(myWorkoutPlansList);
              } else {
                return Center(child: Text('No workout plans'));
              }
            } else {
              return Center(child: Text('No workout plans'));
            }
          }),
    );
  }

  // ListView buildList(List<Workout> myWorkoutsList) {
  //   return ListView.builder(
  //     itemCount: myWorkoutsList.length,
  //     itemBuilder: (context, index) {
  //       return GestureDetector(
  //         onTap: () {},
  //         child: WorkoutCardWidget(
  //           title: myWorkoutsList[index].title,
  //           day: myWorkoutsList[index].day,
  //           numberOfExercises: myWorkoutsList[index].numberOfExercises,
  //         ),
  //       );
  //     },
  //   );
  // }
  GridView buildList(List<Workout> myWorkoutsList) {
    return GridView.count(
      childAspectRatio: 1,
      crossAxisCount: 2,
      children: List.generate(myWorkoutsList.length, (index) {
        return GestureDetector(
          onTap: () {
            if (myWorkoutsList[index].title != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExercisesScreen(
                    isEdit: true,
                    workoutPlanUid: widget.workoutPlanUid,
                    workoutUid: myWorkoutsList[index].uid,
                    workoutTitle: myWorkoutsList[index].title,
                  ),
                ),
              );
            }
          },
          child: WorkoutCardWidget(
            title: myWorkoutsList[index].title,
            day: myWorkoutsList[index].day,
            addNewWorkoutFAB: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return SimpleDialog(
                      title: Text(
                        'Add Workout',
                      ),
                      children: [
                        SimpleDialogOption(
                          // onPressed: () {
                          //   Navigator.pushNamed(
                          //           context, AddWorkoutsListScreen.id)
                          //       .whenComplete(
                          //     () => Navigator.pop(dialogContext),
                          //   );
                          // },
                          child: const Text(
                            'Add workout from library',
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutNameScreen(
                                  workoutPlanUid: widget.workoutPlanUid,
                                  workoutUid: myWorkoutsList[index].uid,
                                ),
                              ),
                            ).whenComplete(
                              () => Navigator.pop(dialogContext),
                            );
                          },
                          child: const Text('Create new workout'),
                        ),
                      ],
                    );
                  });
            },
            numberOfExercises: myWorkoutsList[index].numberOfExercises,
          ),
        );
      }),
    );
  }
}
