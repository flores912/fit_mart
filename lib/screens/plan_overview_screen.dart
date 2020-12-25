import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/plan_overview_screen_bloc.dart';
import 'package:fit_mart/blocs/plan_overview_screen_bloc_provider.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/widgets/better_player_widget.dart';
import 'package:fit_mart/widgets/chewie_player_widget.dart';
import 'package:fit_mart/widgets/workout_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

class PlanOverviewScreen extends StatefulWidget {
  static const String title = 'Plan Overview';

  final String workoutPlanUid;

  const PlanOverviewScreen({Key key, this.workoutPlanUid}) : super(key: key);

  @override
  PlanOverviewScreenState createState() => PlanOverviewScreenState();
}

class PlanOverviewScreenState extends State<PlanOverviewScreen> {
  PlanOverviewScreenBloc _bloc;

  String workoutPlanTitle;

  String description;

  String category;

  String location;

  String skillLevel;

  int length;

  double price;
  String coverPhotoUrl;

  String promoVideoUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = PlanOverviewScreenBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          PlanOverviewScreen.title,
        ),
      ),
      body: StreamBuilder(
          stream: _bloc.getWorkoutPlanInfo(widget.workoutPlanUid),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            workoutPlanTitle = snapshot.data.get('title');
            description = snapshot.data.get('description');
            category = snapshot.data.get('category');
            location = snapshot.data.get('location');
            skillLevel = snapshot.data.get('skillLevel');
            length = snapshot.data.get('numberOfDays');
            price = snapshot.data.get('pricing');
            coverPhotoUrl = snapshot.data.get('coverPhotoUrl');
            promoVideoUrl = snapshot.data.get('promoVideoUrl');
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 1.78,
                        child: ChewiePlayerWidget(
                          videoPlayerController:
                              VideoPlayerController.network(promoVideoUrl),
                          showControls: true,
                          looping: false,
                          autoPlay: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("trainer's name"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          workoutPlanTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(length.toString() + ' Days'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(description)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: Text('Level',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Text(
                                          skillLevel,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: Text('Type',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Text(
                                          category,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: Text('Location',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Text(
                                          location,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {},
                            color: kPrimaryColor,
                            textColor: Colors.white,
                            child: Text('Buy Now'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: RaisedButton(
                                    onPressed: () {},
                                    color: Colors.white,
                                    textColor: kPrimaryColor,
                                    child: Text('ADD TO CART'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                  child: RaisedButton(
                                    onPressed: () {},
                                    color: Colors.white,
                                    textColor: kPrimaryColor,
                                    child: Text('ADD TO WISHLIST'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //TODO:insert list of all days of workout plan
                      buildList(),
                      //TODO:insert list of reviews of workout plan
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget buildList() {
    return StreamBuilder(
        stream: _bloc.workoutsQuerySnapshot(widget.workoutPlanUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.docs;
            List<Workout> workoutsList =
                _bloc.convertToWorkoutsList(docList: docs);
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: workoutsList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: WorkoutCardWidget(
                      title: workoutsList[index].title,
                      day: workoutsList[index].day,
                      numberOfExercises: workoutsList[index].numberOfExercises,
                    ),
                  ),
                );
              },
            );
          } else {
            return Text('No Workouts');
          }
        });
  }
}
