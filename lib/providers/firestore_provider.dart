import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

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
      String workoutPlanUid, String workoutUid) {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
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

  Future<DocumentReference> createNewWorkoutPlan(
    String userUid,
    String trainer,
    String title,
    String description,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    return await collectionReference.add({
      //this will create a new plan on step 1 and update the remaining steps as you go
      'userUid': userUid,
      'trainer': trainer,
      'title': title,
      'description': description,
      'isPublished':
          false, // if not published it will be saved as draft //TODO: remember to update this field at the last step!

      //TODO: remember to update all fields as you go to each step
      //if null it will be updated later on next steps
      'category': null,
      'location': null,
      'skillLevel': null,
      'isFree': null,
      'pricing': null,
      'numberOfDays': null,
      'coverPhotoUrl': null,
      'rating': null,
      'videoOverviewUrl': null,
    });
  }

  Future<void> updateWorkoutPlanCategoriesStep(String workoutPlanUid,
      String category, String location, String skillLevel) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.doc(workoutPlanUid).update(
        {'category': category, 'location': location, 'skillLevel': skillLevel});
  }

  Future<void> addDaysToPlan(int days, String workoutPlanUid) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts');
    for (int i = 1; i <= days; i++) {
      await collectionReference.doc('day ' + i.toString()).set({
        'day': i,
        'numberOfExercises': null,
        'title': null,
      });
    }
  }

  Stream<QuerySnapshot> myWorkoutsCreatePlanQuerySnapshot(
      String workoutPlanUid) {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts');

    return collectionReference.orderBy('day', descending: false).snapshots();
  }

  Future<void> createNewWorkout(String title) async {
    String userUid = _firebaseAuth.currentUser.uid;
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('workoutLibrary');
    await collectionReference.add({'title': title});
  }

  Future<void> updateNewWorkoutToWorkoutPlan(
      String workoutPlanUid, String workoutUid, String title) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts');
    await collectionReference.doc(workoutUid).update({'title': title});
  }

  Future<void> createNewExercise(
      String title, String videoUrl, int sets, int reps, int rest) async {
    String userUid = _firebaseAuth.currentUser.uid;
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('exerciseLibrary');
    await collectionReference.add({
      'title': title,
      'videoUrl': videoUrl,
      'sets': sets,
      'reps': reps,
      'rest': rest,
    });
  }

  Future<DocumentReference> addNewExerciseToWorkout(
    String workoutPlanUid,
    String workoutUid,
    String title,
    String videoUrl,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');
    return await collectionReference.add({
      'title': title,
      'videoUrl': videoUrl,
    });
  }

  Future<void> updateNewExerciseForWorkout(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    String title,
    String videoUrl,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');
    await collectionReference.doc(exerciseUid).update({
      'title': title,
      'videoUrl': videoUrl,
    });
  }

  Future<DocumentReference> addNewSetToExercise(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    int set,
    int reps,
    int rest,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    return await collectionReference.add({
      'set': set,
      'reps': reps,
      'rest': rest,
    });
  }

  Stream<QuerySnapshot> exerciseSetsQuerySnapshot(
      String workoutPlanUid, String workoutUid, String exerciseUid) {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');

    return collectionReference.orderBy('set', descending: false).snapshots();
  }

  Future<void> updateSetOrderForExercise(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    String setUid,
    int setNumber,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    await collectionReference.doc(setUid).update({
      'set': setNumber,
    });
  }

  Future<void> updateSetForExercise(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    String setUid,
    int reps,
    int rest,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    await collectionReference.doc(setUid).update({
      'reps': reps,
      'rest': rest,
    });
  }

  Future<String> downloadURL(File file, String path) async {
    final Reference reference = storage.ref().child(path);
    await reference.putFile(file, SettableMetadata(contentType: 'video/mp4'));
    return await reference.getDownloadURL();

    // Within your widgets:
    // Image.network(downloadURL);
  }
}
