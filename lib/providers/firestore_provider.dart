import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> updateSet(
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
}
