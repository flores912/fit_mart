import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/library_screen_bloc.dart';
import 'package:fit_mart/blocs/library_screen_bloc_provider.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/screens/edit_workout_plan_screen.dart';
import 'package:fit_mart/widgets/workout_plan_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  static const String title = 'Library';
  static const String id = 'library_screen';

  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  LibraryScreenBloc _bloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LibraryScreenBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LibraryScreen.title),
      ),
      body: StreamBuilder(
          stream: _bloc.myWorkoutPlansLibraryQuerySnapshot(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              List<WorkoutPlan> myWorkoutPlansList =
                  _bloc.convertToWorkoutPlansList(docList: docs);

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

  ListView buildList(List<WorkoutPlan> myWorkoutPlansList) {
    return ListView.builder(
      itemCount: myWorkoutPlansList.length,
      itemBuilder: (context, index) {
        String workoutPlanUid = myWorkoutPlansList[index].uid;
        String description = myWorkoutPlansList[index].description;
        String coverPhotoUrl = myWorkoutPlansList[index].coverPhotoUrl;
        String videoOverviewUrl = myWorkoutPlansList[index].videoOverviewUrl;

        int length = myWorkoutPlansList[index].numberOfDays;

        String title = myWorkoutPlansList[index].title;
        int rating = myWorkoutPlansList[index].rating;
        int price = myWorkoutPlansList[index].price;
        bool isFree = myWorkoutPlansList[index].isFree;
        String category = myWorkoutPlansList[index].category;
        String location = myWorkoutPlansList[index].location;
        int numberOfReviews = myWorkoutPlansList[index].numberOfReviews;
        String skillLevel = myWorkoutPlansList[index].skillLevel;
        Image image = coverPhotoUrl != null
            ? Image.network(
                coverPhotoUrl,
                fit: BoxFit.fill,
              )
            : null;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditWorkoutPlanScreen(
                  workoutPlanUid: workoutPlanUid,
                  workoutPlanTitle: title,
                  description: description,
                  category: category,
                  location: location,
                  skillLevel: skillLevel,
                  length: length,
                  price: price,
                  coverPhotoUrl: coverPhotoUrl,
                  videoOverviewUrl: videoOverviewUrl,
                ),
              ),
            );
          },
          child: WorkoutPlanCardWidget(
            title: title,
            rating: rating,
            price: price,
            isFree: isFree,
            category: category,
            location: location,
            numberOfReviews: numberOfReviews,
            skillLevel: skillLevel,
            image: image,
          ),
        );
      },
    );
  }
}
