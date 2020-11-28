import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/models/my_workout_plan.dart';

class FirestoreProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    //TODO : IMPLEMENT LOGIC TO REGISTER WITH COLLECTION  DB SO WE CAN ADD A USERNAME!
  }

  Future<UserCredential> loginUser(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    //TODO : IMPLEMENT LOGIC TO REGISTER WITH COLLECTION  DB SO WE CAN LOGIN WITH USERNAME!
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }

  Stream<QuerySnapshot> myWorkoutPlansQuerySnapshot(String userUid) {
    CollectionReference collectionReference =
        _firestore.collection('users').doc(userUid).collection('myPlans');
    return collectionReference.snapshots();
  }

  Stream<QuerySnapshot> currentPlanWorkoutsQuerySnapshot(
      String userUid, String workoutPlanUid) {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts');

    return collectionReference.orderBy('day', descending: false).snapshots();
  }

  Stream<QuerySnapshot> exercisesQuerySnapshot(
      String userUid, String workoutPlanUid, String workoutUid) {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');

    return collectionReference.snapshots();
  }

  Stream<QuerySnapshot> setsQuerySnapshot(String userUid, String workoutPlanUid,
      String workoutUid, String exerciseUid) {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');

    return collectionReference
        .orderBy('numOfSet', descending: false)
        .snapshots();
  }

  Future<void> updateExerciseSelection(String userUid, String workoutPlanUid,
      String workoutUid, String exerciseUid, bool isSelected) async {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');
    await collectionReference
        .doc(exerciseUid)
        .update({'isSelected': isSelected});
  }

  Future<void> updateSetProgress(
      String userUid,
      String workoutPlanUid,
      String workoutUid,
      String exerciseUid,
      String setUid,
      bool isSetDone) async {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    await collectionReference.doc(setUid).update({'isSetDone': isSetDone});
  }

  Future<void> updateWorkoutProgress(String userUid, String workoutPlanUid,
      String workoutUid, bool isDone) async {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts');
    await collectionReference.doc(workoutUid).update({'isDone': isDone});
  }

  Future<void> createNewWorkoutPlan(
    String userUid,
    String trainer,
    String title,
    String description,
    String category,
    String location,
    String skillLevel,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.add({
      //this will create a new plan on step 1 and update the remaining steps as you go
      'userUid': userUid,
      'trainer': trainer,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'skillLevel': skillLevel,
      'isPublished':
          false, // if not published it will be saved as draft //TODO: remember to update this field at the last step!

      //TODO: remember to update all fields as you go to each step
      //if null it will be updated later on next steps
      'isFree': null,
      'pricing': null,
      'numberOfDays': null,
      'coverPhotoUrl': null,
      'rating': null,
      'videoOverviewUrl': null,
    });
  }
}
