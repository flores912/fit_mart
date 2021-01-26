import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:flutter/cupertino.dart';

import '../constants.dart';
import 'package:fit_mart/models/week.dart';

class FirestoreProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

//LOGIN/SIGNUP
  Future<void> registerUser(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> loginUser(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> addUserDetails(String name, String username) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .set({
      'name': name,
      'username': username,
      'tipUrl': null,
      'bio': null,
      'id': _firebaseAuth.currentUser.uid,
      'photoUrl': null,
    }).whenComplete(() async =>
            await _firebaseAuth.currentUser.updateProfile(displayName: name));
  }

  Future<void> updateProfile(
    String name,
    String username,
    String bio,
    String photoUrl,
    String tipUrl,
  ) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .update({
      'name': name,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'tipUrl': tipUrl
    }).whenComplete(() async =>
            await _firebaseAuth.currentUser.updateProfile(displayName: name));
  }

  //TRAINER VIEW
  Stream<DocumentSnapshot> getUserDetails(String userUid) {
    return _firestore.collection('users').doc(userUid).snapshots();
  }

  Future<void> deleteExerciseFromCollection(String exerciseUid) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .delete();
  }

  Future<void> deleteSetFromCollectionExercise(
      String exerciseUid, String setUid) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .delete();
  }

  Future<void> deleteSetFromExercise(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid, String setUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .delete();
  }

  Future<void> deleteWeek(String workoutPlanUid, String weekUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .delete();
  }

  Future<void> deletePlan(String workoutPlanUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .delete();
  }

  Future<void> deleteUser() async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .delete();
  }

  Future<void> deleteExerciseFromWorkout(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .delete();
  }

  Future<void> deleteSetFromWorkoutExercise(
      String workoutPlanUid,
      String weekUid,
      String workoutUid,
      String exerciseUid,
      String setUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .delete();
  }

  Stream<QuerySnapshot> getTrainerPlans() {
    return _firestore
        .collection('workoutPlans')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getOthersTrainerPlans() {
    return _firestore
        .collection('workoutPlans')
        .where(
          'users',
          arrayContains: _firebaseAuth.currentUser.uid,
        )
        .snapshots();
  }

  Future<void> addPlanToMyList(String workoutPlanUid) async {
    var uidAsList = [_firebaseAuth.currentUser.uid];
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({'users': FieldValue.arrayUnion(uidAsList)});
  }

  Future<void> removePlanFromList(String workoutPlanUid) async {
    var uidAsList = [_firebaseAuth.currentUser.uid];
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({'users': FieldValue.arrayRemove(uidAsList)});
  }

  Stream<QuerySnapshot> getPublishedTrainerPlans(String userUid) {
    return _firestore
        .collection('workoutPlans')
        .where('userUid', isEqualTo: userUid)
        .where('isPublished', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<DocumentSnapshot> getPlanDetails(String workoutPlanUid) {
    return _firestore.collection('workoutPlans').doc(workoutPlanUid).get();
  }

  Stream<DocumentSnapshot> getPlanDetailsStream(String workoutPlanUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .snapshots();
  }

  Future<DocumentSnapshot> getExerciseDetailsFromCollectionExercise(
      String exerciseUid) {
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .get();
  }

  Future<DocumentSnapshot> getExerciseDetails(String workoutPlanUid,
      String weekUid, String workoutUid, String exerciseUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .get();
  }

  Future<DocumentReference> createNewPlan(
    String title,
    String description,
    String type,
    String location,
    String level,
  ) async {
    return await _firestore.collection('workoutPlans').add({
      'userUid': _firebaseAuth.currentUser.uid,
      'trainerName': _firebaseAuth.currentUser.displayName,
      'title': title,
      'type': type,
      'level': level,
      'location': location,
      'weeks': 0,
      'isPublished': false,
      'createdAt': FieldValue.serverTimestamp(),
      //not necessary to create new plan
      'description': description,
      'coverPhotoUrl': null,
      'promoVideoUrl': null,
      'users': [],
    });
  }

  Future<void> updateNumberOfWeeks(String workoutPlanUid, int weeks) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({
      'weeks': weeks,
    });
  }

  Future<void> updateWeekIndex(
      String workoutPlanUid, String weekUid, int week) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .update({
      'week': week,
    });
  }

  Future<void> updateWorkoutIndex(
      String workoutPlanUid, String weekUid, String workoutId, int day) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutId)
        .update({
      'day': day,
    });
  }

  Future<void> updateExerciseIndex(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid, int exercise) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .update({
      'exercise': exercise,
    });
  }

  Future<void> updateSetIndex(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid, String setUid, int set) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .update({
      'set': set,
    });
  }

  Future<void> updateSetIndexCollection(
      String exerciseUid, String setUid, int set) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .update({
      'set': set,
    });
  }

  Future<void> updatePublishedStatus(
      String workoutPlanUid, bool isPublished) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({
      'isPublished': isPublished,
    });
  }

  Future<void> updateNumberOfExercises(String workoutPlanUid, String weekUid,
      String workoutUid, int exercises) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .update({
      'exercises': exercises,
    });
  }

  Future<void> updateExerciseName(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid, String exerciseName) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .update({
      'exerciseName': exerciseName,
    });
  }

  Future<void> updateExerciseNameCollection(
      String exerciseUid, String exerciseName) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .update({
      'exerciseName': exerciseName,
    });
  }

  Future<void> updatePlanDetails(
    String workoutPlanUid,
    String title,
    String description,
    String type,
    String location,
    String level,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({
      'userUid': _firebaseAuth.currentUser.uid,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'level': level,
    });
  }

  Future<void> updatePlanCover(
    String workoutPlanUid,
    String coverPhotoUrl,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({'coverPhotoUrl': coverPhotoUrl});
  }

  Future<void> updatePlanPromo(
    String workoutPlanUid,
    String promoVideoUrl,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({'promoVideoUrl': promoVideoUrl});
  }

  Future<void> updateWorkoutName(String workoutPlanUid, String weekUid,
      String workoutUid, String workoutName) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .update({'workoutName': workoutName});
  }

  Future<void> createNewWeek(String workoutPlanUid, int week) async {
    CollectionReference weeksCollection = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks');
    await weeksCollection.add({'week': week}).then((value) async {
      String weekUid = value.id;
      for (int day = 1; day <= 7; day++) {
        await weeksCollection.doc(weekUid).collection('workouts').add({
          'week': week,
          'day': day,
          'weekUid': weekUid,
          'workoutName': kRest, //default name
          'exercises': 0,
        });
      }
    });
  }

  Stream<QuerySnapshot> getWeeks(String workoutPlanUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .orderBy('week', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getWorkouts(String workoutPlanUid, String weekUid) {
    CollectionReference weeksReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks');
    return weeksReference
        .doc(weekUid)
        .collection('workouts')
        .orderBy('day', descending: false)
        .snapshots();
  }

  Future<DocumentReference> addNewExercise(
      String exerciseName,
      int exercise,
      int sets,
      String videoUrl,
      String workoutPlanUid,
      String weekUid,
      String workoutUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .add({
      'exerciseName': exerciseName,
      'videoUrl': videoUrl,
      'exercise': exercise,
      'sets': sets
    });
  }

  Future<DocumentReference> addNewExerciseToCollection(
      String exerciseName, int sets, String videoUrl) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .add({
      'exerciseName': exerciseName,
      'videoUrl': videoUrl,
      'sets': sets,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateExerciseDetailsCollection(
      String videoUrl, int sets, String exerciseUid) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .update({
      'videoUrl': videoUrl,
      'sets': sets,
    });
  }

  Future<void> updateExerciseDetailsNumberOfSetsCollection(
      int sets, String exerciseUid) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .update({
      'sets': sets,
    });
  }

  Future<void> updateExerciseDetailsNumberOfSets(
      int sets,
      String workoutPlanUid,
      String weekUid,
      String workoutUid,
      String exerciseUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .update({
      'sets': sets,
    });
  }

  Future<void> updateExerciseDetails(
      String videoUrl,
      int sets,
      String workoutPlanUid,
      String weekUid,
      String workoutUid,
      String exerciseUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .update({
      'videoUrl': videoUrl,
      'sets': sets,
    });
  }

  Future<DocumentReference> addNewSet(
      String workoutPlanUid,
      String weekUid,
      String workoutUid,
      String exerciseUid,
      int set,
      int reps,
      int rest,
      bool isTimed,
      bool isFailure,
      bool isSetInMin,
      bool isRestInMin) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .add({
      'isSetInMin': isSetInMin,
      'isRestInMin': isRestInMin,
      'isTimed': isTimed,
      'isFailure': isFailure,
      'set': set,
      'reps': reps,
      'rest': rest,
    });
  }

  Future<void> updateSet(
      String workoutPlanUid,
      String weekUid,
      String workoutUid,
      String exerciseUid,
      String setUid,
      int set,
      int reps,
      int rest,
      bool isTimed,
      bool isFailure,
      bool isSetInMin,
      bool isRestInMin) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .update({
      'isSetInMin': isSetInMin,
      'isRestInMin': isRestInMin,
      'isTimed': isTimed,
      'isFailure': isFailure,
      'set': set,
      'reps': reps,
      'rest': rest,
    });
  }

  Future<void> updateIsDoneSet(
      bool isDone,
      String workoutPlanUid,
      String weekUid,
      String workoutUid,
      String exerciseUid,
      String setUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .collection('isDone')
        .doc(_firebaseAuth.currentUser.uid)
        .set({
      'userUid': _firebaseAuth.currentUser.uid,
      'isDone': isDone,
    });
  }

  Future<void> updateIsDoneExercise(
    bool isDone,
    String workoutPlanUid,
    String weekUid,
    String workoutUid,
    String exerciseUid,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('isDone')
        .doc(_firebaseAuth.currentUser.uid)
        .set({
      'userUid': _firebaseAuth.currentUser.uid,
      'isDone': isDone,
    });
  }

  Future<void> updateIsDoneWeek(
    bool isDone,
    String workoutPlanUid,
    String weekUid,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('isDone')
        .doc(_firebaseAuth.currentUser.uid)
        .set({
      'userUid': _firebaseAuth.currentUser.uid,
      'isDone': isDone,
    });
  }

  Future<void> updateIsDoneWorkout(
    bool isDone,
    String workoutPlanUid,
    String weekUid,
    String workoutUid,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('isDone')
        .doc(_firebaseAuth.currentUser.uid)
        .set({
      'userUid': _firebaseAuth.currentUser.uid,
      'isDone': isDone,
    });
  }

  Stream<QuerySnapshot> getSetIsDone(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid, String setUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .collection('isDone')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getExerciseIsDone(
    String workoutPlanUid,
    String weekUid,
    String workoutUid,
    String exerciseUid,
  ) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('isDone')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getWeekIsDone(
    String workoutPlanUid,
    String weekUid,
  ) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('isDone')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots();
  }

  Future<QuerySnapshot> getWeekIsDoneFuture(
    String workoutPlanUid,
    String weekUid,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('isDone')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .get();
  }

  Stream<QuerySnapshot> getWorkoutIsDone(
    String workoutPlanUid,
    String weekUid,
    String workoutUid,
  ) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('isDone')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots();
  }

  Future<DocumentReference> addNewSetCollection(
      String exerciseUid,
      int set,
      int reps,
      int rest,
      bool isTimed,
      bool isFailure,
      bool isSetInMin,
      bool isRestInMin) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .collection('sets')
        .add({
      'isSetInMin': isSetInMin,
      'isRestInMin': isRestInMin,
      'isTimed': isTimed,
      'isFailure': isFailure,
      'set': set,
      'reps': reps,
      'rest': rest,
    });
  }

  Future<void> updateSetCollection(
      String exerciseUid,
      String setUid,
      int set,
      int reps,
      int rest,
      bool isTimed,
      bool isFailure,
      bool isSetInMin,
      bool isRestInMin) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .collection('sets')
        .doc(setUid)
        .update({
      'isSetInMin': isSetInMin,
      'isRestInMin': isRestInMin,
      'isTimed': isTimed,
      'isFailure': isFailure,
      'set': set,
      'reps': reps,
      'rest': rest,
    });
  }

  Stream<QuerySnapshot> getSets(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .orderBy('set', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getSetsCollection(String exerciseUid) {
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .collection('sets')
        .orderBy('set', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getExercises(
      String workoutPlanUid, String weekUid, String workoutUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .orderBy('exercise', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getExercisesCollection() {
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //LONG QUERY

  Future<void> copyWorkout(String workoutPlanUid, Workout originalWorkout,
      Workout copyWorkout) async {
    await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(copyWorkout.weekUid)
        .collection('workouts')
        .doc(copyWorkout.uid)
        .update({
      'workoutName': originalWorkout.workoutName,
      'exercises': originalWorkout.exercises,
    }).whenComplete(() async {
      await _firestore
          .collection('workoutPlans')
          .doc(workoutPlanUid)
          .collection('weeks')
          .doc(copyWorkout.weekUid)
          .collection('workouts')
          .doc(copyWorkout.uid)
          .collection('exercises')
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          await element.reference.delete();
        });
      }).whenComplete(() async {
        await _firestore
            .collection('workoutPlans')
            .doc(workoutPlanUid)
            .collection('weeks')
            .doc(originalWorkout.weekUid)
            .collection('workouts')
            .doc(originalWorkout.uid)
            .collection('exercises')
            .get()
            .then((originalWorkoutExercises) {
          originalWorkoutExercises.docs
              .forEach((originalWorkoutExercise) async {
            await _firestore
                .collection('workoutPlans')
                .doc(workoutPlanUid)
                .collection('weeks')
                .doc(copyWorkout.weekUid)
                .collection('workouts')
                .doc(copyWorkout.uid)
                .collection('exercises')
                .add({
              'exerciseName': await originalWorkoutExercise.get('exerciseName'),
              'videoUrl': await originalWorkoutExercise.get('videoUrl'),
              'exercise': await originalWorkoutExercise.get('exercise'),
              'sets': await originalWorkoutExercise.get('sets'),
            }).then((copyWorkoutExercise) async {
              await getSetsFuture(workoutPlanUid, originalWorkout.weekUid,
                      originalWorkout.uid, originalWorkoutExercise.id)
                  .then((originalWorkoutExerciseSets) {
                originalWorkoutExerciseSets.docs.forEach((originalSet) async {
                  Set set = Set(
                      isSetInMin: await originalSet.get('isSetInMin'),
                      isRestInMin: await originalSet.get('isRestInMin'),
                      isTimed: await originalSet.get('isTimed'),
                      isFailure: await originalSet.get('isFailure'),
                      reps: await originalSet.get('reps'),
                      rest: await originalSet.get('rest'),
                      set: await originalSet.get('set'),
                      setUid: originalSet.id);

                  await addNewSet(
                      workoutPlanUid,
                      copyWorkout.weekUid,
                      copyWorkout.uid,
                      copyWorkoutExercise.id,
                      set.set,
                      set.reps,
                      set.rest,
                      set.isTimed,
                      set.isFailure,
                      set.isSetInMin,
                      set.isRestInMin);
                });
              });
            });
          });
        });
      });
    });
  }
  //LONG QUERY
  //copy workout//Todo:try to shorten code

  Future<void> copyWeek(
      String workoutPlanUid, Week originalWeek, Week copyWeek) async {
    String newWeekUid;
    //delete week doc
    await deleteWeek(workoutPlanUid, copyWeek.uid).whenComplete(() async {
      //create new week
      await createNewWeekWithoutWorkouts(workoutPlanUid, copyWeek.week)
          .then((value) => newWeekUid = value.id)
          .whenComplete(() async {
        //get workouts from the week we are copying
        await getWorkoutsFuture(workoutPlanUid, originalWeek.uid)
            .then((value) => {
                  value.docs.forEach((originalWorkout) async {
                    //start adding those workouts to the new week
                    await _firestore
                        .collection('workoutPlans')
                        .doc(workoutPlanUid)
                        .collection('weeks')
                        .doc(newWeekUid)
                        .collection('workouts')
                        .add({
                      'week': copyWeek.week,
                      'day': await originalWorkout.get('day'),
                      'weekUid': newWeekUid,
                      'workoutName': await originalWorkout
                          .get('workoutName'), //default name
                      'exercises': await originalWorkout.get('exercises'),
                      //get exercises of each workout from the workout we are copying
                    }).then((newWorkout) async {
                      await getExercisesFuture(workoutPlanUid, originalWeek.uid,
                              originalWorkout.id)
                          .then((value) => {
                                value.docs.forEach((originalExercise) async {
                                  //add exercises to new workout
                                  await addNewExercise(
                                          await originalExercise
                                              .get('exerciseName'),
                                          await originalExercise
                                              .get('exercise'),
                                          await originalExercise.get('sets'),
                                          await originalExercise
                                              .get('videoUrl'),
                                          workoutPlanUid,
                                          newWeekUid,
                                          newWorkout.id)
                                      .then((newExercise) async => {
                                            //get sets from the exercise we are copying
                                            await getSetsFuture(
                                                    workoutPlanUid,
                                                    originalWeek.uid,
                                                    originalWorkout.id,
                                                    originalExercise.id)
                                                .then((value) {
                                              value.docs.forEach((set) async {
                                                //add sets to the new exercise
                                                await addNewSet(
                                                  workoutPlanUid,
                                                  newWeekUid,
                                                  newWorkout.id,
                                                  newExercise.id,
                                                  await set.get('set'),
                                                  await set.get('reps'),
                                                  await set.get('rest'),
                                                  await set.get('isTimed'),
                                                  await set.get('isFailure'),
                                                  await set.get('isSetInMin'),
                                                  await set.get('isRestInMin'),
                                                );
                                              });
                                            })
                                          });
                                })
                              });
                    });
                  })
                });
      });
    });
  }

  Future<DocumentReference> createNewWeekWithoutWorkouts(
      String workoutPlanUid, int week) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .add({'week': week});
    // await weeksCollection.add({'week': week}).then((value) async {
    //   String weekUid = value.id;
    //   for (int day = 1; day <= 7; day++) {
    //     await weeksCollection.doc(weekUid).collection('workouts').add({
    //       'week': week,
    //       'day': day,
    //       'weekUid': weekUid,
    //       'workoutName': kRest, //default name
    //       'exercises': 0,
    //     });
    //   }
    // });
  }

  Future<QuerySnapshot> getWorkoutsFuture(
      String workoutPlanUid, String weekUid) {
    CollectionReference weeksReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks');
    return weeksReference
        .doc(weekUid)
        .collection('workouts')
        .orderBy('day', descending: false)
        .get();
  }

  Future<QuerySnapshot> getExercisesFuture(
      String workoutPlanUid, String weekUid, String workoutUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .orderBy('exercise', descending: false)
        .get();
  }

  Future<QuerySnapshot> getSetsFuture(String workoutPlanUid, String weekUid,
      String workoutUid, String exerciseUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets')
        .orderBy('set', descending: false)
        .get();
  }

  Future<QuerySnapshot> getSetsCollectionFuture(String exerciseUid) {
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .collection('sets')
        .orderBy('set', descending: false)
        .get();
  }

  Future<void> duplicateExercise(String workoutPlanUid, String weekUid,
      String workoutUid, Exercise exercise, int exerciseIndex) async {
    return await addNewExercise(
            exercise.exerciseName,
            exerciseIndex,
            exercise.sets,
            exercise.videoUrl,
            workoutPlanUid,
            weekUid,
            workoutUid)
        .then((duplicateExercise) async {
      await getSetsFuture(
              workoutPlanUid, weekUid, workoutUid, exercise.exerciseUid)
          .then((sets) {
        sets.docs.forEach((set) async {
          await addNewSet(
            workoutPlanUid,
            weekUid,
            workoutUid,
            duplicateExercise.id,
            await set.get('set'),
            await set.get('reps'),
            await set.get('rest'),
            await set.get('isTimed'),
            await set.get('isFailure'),
            await set.get('isSetInMin'),
            await set.get('isRestInMin'),
          );
        });
      });
    });
  }

  Future<void> duplicateExerciseCollection(Exercise exercise) async {
    return await addNewExerciseToCollection(
            exercise.exerciseName, exercise.sets, exercise.videoUrl)
        .then((duplicateExercise) async {
      await getSetsCollectionFuture(exercise.exerciseUid).then((sets) {
        sets.docs.forEach((set) async {
          await addNewSetCollection(
            duplicateExercise.id,
            await set.get('set'),
            await set.get('reps'),
            await set.get('rest'),
            await set.get('isTimed'),
            await set.get('isFailure'),
            await set.get('isSetInMin'),
            await set.get('isRestInMin'),
          );
        });
      });
    });
  }
}
