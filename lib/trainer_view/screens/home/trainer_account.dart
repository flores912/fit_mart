import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/custom_widgets/set_card.dart';
import 'package:fit_mart/custom_widgets/workout_plan_card.dart';
import 'package:fit_mart/custom_widgets/workout_session_widget.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/trainer_account_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_plan.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_plan_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'edit_profile.dart';

class TrainerAccount extends StatefulWidget {
  static const String title = kAccount;

  @override
  _TrainerAccountState createState() => _TrainerAccountState();
}

class _TrainerAccountState extends State<TrainerAccount> {
  String name;
  String username;
  String photoUrl;
  String bio;

  TrainerAccountBloc _bloc = TrainerAccountBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: StreamBuilder(
            stream: _bloc.getUserDetails(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                name = snapshot.data.get('name');
                username = snapshot.data.get('username');
                photoUrl = snapshot.data.get('photoUrl');
                bio = snapshot.data.get('bio');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //TODO:ADD PLACEHOLDER
                  photoUrl != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(photoUrl),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: CupertinoColors.placeholderText,
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bio != null ? Text(bio) : Text(''),
                  ),
                  OutlineButton(
                      child: Text('Edit Profile'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(
                              name: name,
                              username: username,
                              bio: bio,
                              photoUrl: photoUrl,
                            ),
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Divider(),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: plansListView(),
                  ),
                ],
              );
            }),
      ),
    );
  }

  List<WorkoutPlan> buildWorkoutPlansList(List<DocumentSnapshot> docList) {
    List<WorkoutPlan> workoutsList = [];
    docList.forEach((element) {
      WorkoutPlan workoutPlan = WorkoutPlan(
        uid: element.id,
        trainerName: element.get('trainerName'),
        location: element.get('location'),
        weeks: element.get('weeks'),
        level: element.get('level'),
        type: element.get('type'),
        description: element.get('description'),
        promoVideoUrl: element.get('promoVideoUrl'),
        isPublished: element.get('isPublished'),
        coverPhotoUrl: element.get('coverPhotoUrl'),
        userUid: element.get('userUid'),
        title: element.get('title'),
      );
      workoutsList.add(workoutPlan);
    });
    return workoutsList;
  }

  Widget plansListView() {
    return StreamBuilder(
        stream: _bloc.getPublishedTrainerPlans(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<WorkoutPlan> workoutPlansList =
                buildWorkoutPlansList(snapshot.data.docs);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                snapshot.data.docs.isNotEmpty == true
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Workout Plans by ' + name),
                      )
                    : Container(),
                Container(
                  height: 250,
                  child: ListView.builder(
                      primary: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: workoutPlansList.length,
                      itemBuilder: (context, index) {
                        return WorkoutPlanCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutPlanPreview(
                                  workoutPlan: workoutPlansList[index],
                                ),
                              ),
                            );
                          },
                          title: workoutPlansList[index].title,
                          weeks: workoutPlansList[index].weeks,
                          image: workoutPlansList[index].coverPhotoUrl != null
                              ? Image.network(
                                  workoutPlansList[index].coverPhotoUrl)
                              : Container(
                                  color: CupertinoColors.placeholderText,
                                ),
                        );
                      }),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
