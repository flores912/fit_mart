import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/create_plan/cover_screen_bloc.dart';
import 'package:fit_mart/blocs/edit_workout_plan_screen_bloc.dart';
import 'package:fit_mart/blocs/edit_workout_plan_screen_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/create_plan/categories_screen.dart';
import 'package:fit_mart/screens/create_plan/cover_screen.dart';
import 'package:fit_mart/screens/create_plan/details_screen.dart';
import 'package:fit_mart/screens/create_plan/plan_length_screen.dart';
import 'package:fit_mart/screens/create_plan/price_screen.dart';
import 'package:fit_mart/screens/create_plan/promo_video_screen.dart';
import 'package:fit_mart/screens/create_plan/workouts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditWorkoutPlanScreen extends StatefulWidget {
  static const String title = 'Edit Workout Plan';
  static const String id = 'edit_workout_plan_screen';

  final String workoutPlanUid;

  const EditWorkoutPlanScreen({
    Key key,
    this.workoutPlanUid,
  }) : super(key: key);

  @override
  EditWorkoutPlanScreenState createState() => EditWorkoutPlanScreenState();
}

class EditWorkoutPlanScreenState extends State<EditWorkoutPlanScreen> {
  EditWorkoutPlanScreenBloc _bloc;
  String workoutPlanTitle;

  String description;

  String category;

  String location;

  String skillLevel;

  int length;

  double price;
  String coverPhotoUrl;

  String promoVideoUrl;

  bool isWorkoutsComplete;

  bool isPlanComplete;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = EditWorkoutPlanScreenBlocProvider.of(context);
    super.didChangeDependencies();
  }

  bool isDetailsComplete() {
    bool isComplete;
    if (workoutPlanTitle == null || description == null) {
      isComplete = false;
    } else {
      isComplete = true;
    }
    return isComplete;
  }

  bool isCategoriesComplete() {
    if (category == null || description == null || location == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isLengthComplete() {
    if (length == null) {
      return false;
    } else {
      return true;
    }
  }

  checkIfWorkoutsComplete(AsyncSnapshot<QuerySnapshot> snapshot) {
    isWorkoutsComplete = true;
    if (snapshot.hasData) {
      //check if workouts completed
      if (snapshot.data.docs.isEmpty) {
        isWorkoutsComplete = false;
      } else if (snapshot.data.docs.isNotEmpty) {
        snapshot.data.docs.forEach((element) {
          if (element.get('title') == null) {
            isWorkoutsComplete = false;
          }
        });
      } else {
        isWorkoutsComplete = true;
      }
    }
  }

  bool isPriceComplete() {
    if (price == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isCoverPhotoComplete() {
    if (coverPhotoUrl == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isPromoVideoComplete() {
    if (promoVideoUrl == null) {
      return false;
    } else {
      return true;
    }
  }

  checkIfPlanIsComplete() {
    if (isDetailsComplete() == true &&
        isCategoriesComplete() == true &&
        isLengthComplete() == true &&
        isWorkoutsComplete == true &&
        isPriceComplete() == true &&
        isCoverPhotoComplete() == true &&
        isPromoVideoComplete() == true) {
      isPlanComplete = true;
    } else {
      isPlanComplete = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EditWorkoutPlanScreen.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                checkIfPlanIsComplete();
                if (isPlanComplete) {
                  //publish plan
                } else {
                  //correct all other fields
                }
              },
              color: Colors.white,
              textColor: kPrimaryColor,
              child: Text('Publish'),
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _bloc.getWorkoutPlanInfo(widget.workoutPlanUid),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              workoutPlanTitle = snapshot.data.get('title');
              description = snapshot.data.get('description');
              category = snapshot.data.get('category');
              location = snapshot.data.get('location');
              skillLevel = snapshot.data.get('skillLevel');
              length = snapshot.data.get('numberOfDays');
              price = snapshot.data.get('pricing');
              coverPhotoUrl = snapshot.data.get('coverPhotoUrl');
              promoVideoUrl = snapshot.data.get('promoVideoUrl');
            }

            return StreamBuilder(
                stream: _bloc.myWorkoutsQuerySnapshot(widget.workoutPlanUid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  checkIfWorkoutsComplete(snapshot);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  isEdit: true,
                                  workoutPlanUid: widget.workoutPlanUid,
                                  workoutPlanTitle: workoutPlanTitle,
                                  description: description,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DetailsScreen.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  isDetailsComplete() == false
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Not Complete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Complete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoriesScreen(
                                  workoutPlanUid: widget.workoutPlanUid,
                                  isEdit: true,
                                  category: category,
                                  location: location,
                                  skillLevel: skillLevel,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        CategoriesScreen.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  isCategoriesComplete() == false
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Not Complete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Complete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanLengthScreen(
                                  isEdit: true,
                                  length: length,
                                  workoutPlanUid: widget.workoutPlanUid,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        PlanLengthScreen.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  isLengthComplete() == false
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Not Complete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Complete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutsScreen(
                                  isEdit: true,
                                  workoutPlanUid: widget.workoutPlanUid,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        WorkoutsScreen.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  isWorkoutsComplete == false
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Not Complete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Complete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PriceScreen(
                                  isEdit: true,
                                  price: price,
                                  workoutPlanUid: widget.workoutPlanUid,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        PriceScreen.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  isPriceComplete() == false
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Not Complete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Complete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoverScreen(
                                  isEdit: true,
                                  workoutPlanUid: widget.workoutPlanUid,
                                  coverPhotoUrl: coverPhotoUrl,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        CoverScreen.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  isCoverPhotoComplete() == false
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Not Complete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Complete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PromoVideoScreen(
                                  isEdit: true,
                                  workoutPlanUid: widget.workoutPlanUid,
                                  promoVideoUrl: promoVideoUrl,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        PromoVideoScreen.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  isPromoVideoComplete() == false
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Not Complete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Complete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
