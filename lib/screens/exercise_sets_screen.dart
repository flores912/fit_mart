import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/exercise_sets_screen_bloc.dart';
import 'package:fit_mart/blocs/exercise_sets_screen_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/widgets/edit_set_widget.dart';
import 'package:flutter/material.dart';

class ExerciseSetsScreen extends StatefulWidget {
  final String workoutPlanUid;
  final String workoutUid;
  final String exerciseUid;
  final String exerciseTitle;

  const ExerciseSetsScreen(
      {Key key,
      this.workoutPlanUid,
      this.workoutUid,
      this.exerciseUid,
      this.exerciseTitle})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ExerciseSetsScreenState();
}

class ExerciseSetsScreenState extends State<ExerciseSetsScreen> {
  FirestoreProvider firestoreProvider = FirestoreProvider();

  ExerciseSetsScreenBloc _bloc;
  List<Set> mySetsList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = ExerciseSetsScreenBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseTitle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            firestoreProvider.addNewSetToExercise(
                widget.workoutPlanUid,
                widget.workoutUid,
                widget.exerciseUid,
                mySetsList.length + 1,
                null,
                null);
          },
          label: Text('Add new set'),
          icon: Icon(Icons.add),
        ),
      ),
      body: StreamBuilder(
          stream: firestoreProvider.exerciseSetsQuerySnapshot(
              widget.workoutPlanUid, widget.workoutUid, widget.exerciseUid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              mySetsList = _bloc.convertToSetsList(docList: docs);

              if (mySetsList.isNotEmpty) {
                return buildList(mySetsList);
              } else {
                return Center(child: Text('Start adding sets'));
              }
            } else {
              return Center(child: Text('Start adding sets'));
            }
          }),
    );
  }

  ListView buildList(List<Set> mySetsList) {
    return ListView.builder(
      itemCount: mySetsList.length,
      itemBuilder: (context, index) {
        return EditSetWidget(
          set: mySetsList[index].numOfSet,
          reps: mySetsList[index].reps,
          rest: mySetsList[index].rest,
        );
      },
    );
  }
}
