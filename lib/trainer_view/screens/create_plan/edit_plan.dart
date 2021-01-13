import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/edit_plan_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/cover_photo.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_details.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_workouts.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/promo_video.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPlan extends StatefulWidget {
  final String workoutPlanUid;

  const EditPlan({Key key, this.workoutPlanUid}) : super(key: key);
  @override
  _EditPlanState createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  EditPlanBloc _bloc = EditPlanBloc();

  WorkoutPlan workoutPlan;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plan'),
      ),
      body: StreamBuilder(
          stream: _bloc.getPlanDetailsStream(widget.workoutPlanUid),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              workoutPlan = WorkoutPlan(
                trainerName: snapshot.data.get('trainerName'),
                isBeenPaidFor: snapshot.data.get('isBeenPaidFor'),
                weeks: snapshot.data.get('weeks'),
                description: snapshot.data.get('description'),
                title: snapshot.data.get('title'),
                userUid: snapshot.data.get('userUid'),
                coverPhotoUrl: snapshot.data.get('coverPhotoUrl'),
                isPublished: snapshot.data.get('isPublished'),
                isFree: snapshot.data.get('isFree'),
                promoVideoUrl: snapshot.data.get('promoVideoUrl'),
                price: snapshot.data.get('price'),
              );

              return Wrap(
                children: [
                  Column(
                    children: [
                      EditWidget(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanDetails(
                                workoutPlan: workoutPlan,
                                isEdit: true,
                                workoutPlanUid: widget.workoutPlanUid,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.description),
                        title: 'Plan Details',
                      ),
                      EditWidget(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanWorkouts(
                                isEdit: true,
                                workoutPlanUid: widget.workoutPlanUid,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.fitness_center),
                        title: 'Workouts',
                      ),
                      EditWidget(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoverPhoto(
                                isEdit: true,
                                workoutPlanUid: widget.workoutPlanUid,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.photo),
                        title: 'Cover Photo',
                      ),
                      EditWidget(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PromoVideo(
                                isEdit: true,
                                workoutPlanUid: widget.workoutPlanUid,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.videocam),
                        title: 'Promo Video',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                            child: Text('Exit'),
                            onPressed: () {
                              Navigator.of(context).popUntil(
                                  ModalRoute.withName(HomeTrainer.id));
                            },
                          ),
                        ),
                        workoutPlan.isPublished == false
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    color: kPrimaryColor,
                                    child: Text(
                                      'Publish',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      _bloc.updatePublishedStatus(
                                          widget.workoutPlanUid, true);
                                    }),
                              )
                            : RaisedButton(
                                color: kPrimaryColor,
                                child: Text(
                                  kUnpublish,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  _bloc.updatePublishedStatus(
                                      widget.workoutPlanUid, false);
                                }),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class EditWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  final Widget leading;
  const EditWidget({
    Key key,
    this.title,
    this.leading,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ListTile(
            leading: leading,
            title: Text(title),
            trailing: Icon(Icons.edit),
          ),
        ),
        Divider()
      ],
    );
  }
}
