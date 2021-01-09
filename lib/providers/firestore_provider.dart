import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> addUserDetails(
    String name,
  ) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .set({
      'name': name,
      'id': _firebaseAuth.currentUser.uid,
      'photoUrl': null
    });
  }

  //TRAINER VIEW
  Stream<DocumentSnapshot> getUserDetails() {
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .snapshots();
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
    double price,
    bool isFree,
  ) async {
    return await _firestore.collection('workoutPlans').add({
      'userUid': _firebaseAuth.currentUser.uid,
      'title': title,
      'price': price,
      'isFree': isFree,
      'weeks': 0,
      'isPublished': false,
      //not necessary to create new plan
      'description': description,
      'coverPhotoUrl': null,
      'promoVideoUrl': null,
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

  Future<void> updatePlanDetails(
    String workoutPlanUid,
    String title,
    String description,
    double price,
    bool isFree,
  ) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({
      'userUid': _firebaseAuth.currentUser.uid,
      'title': title,
      'description': description,
      'price': price,
      'isFree': isFree,
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
    String exerciseName,
  ) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .add({'exerciseName': exerciseName, 'videoUrl': null, 'sets': 0});
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
      int rest) async {
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
      'set': set,
      'reps': reps,
      'rest': rest,
    });
  }

  Future<DocumentReference> addNewSetCollection(
      String exerciseUid, int set, int reps, int rest) async {
    return await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('exerciseCollection')
        .doc(exerciseUid)
        .collection('sets')
        .add({
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
            .then((value) {
          value.docs.forEach((element) async {
            await _firestore
                .collection('workoutPlans')
                .doc(workoutPlanUid)
                .collection('weeks')
                .doc(copyWorkout.weekUid)
                .collection('workouts')
                .doc(copyWorkout.uid)
                .collection('exercises')
                .add({
              'exerciseName': await element.get('exerciseName'),
              'videoUrl': await element.get('videoUrl'),
              'exercise': await element.get('exercise'),
              'sets': await element.get('sets'),
            }).then((value) async {
              await _firestore
                  .collection('workoutPlans')
                  .doc(workoutPlanUid)
                  .collection('weeks')
                  .doc(copyWorkout.weekUid)
                  .collection('workouts')
                  .doc(copyWorkout.uid)
                  .collection('exercises')
                  .doc(value.id)
                  .collection('sets')
                  .add({
                'set': await element.get('set'),
                'reps': await element.get('reps'),
                'rest': await element.get('rest'),
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
                                                    await set.get('rest'));
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
}
