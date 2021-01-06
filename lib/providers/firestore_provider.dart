import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/models/workout.dart';

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

  Stream<QuerySnapshot> getTrainerPlans() {
    return _firestore
        .collection('workoutPlans')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots();
  }

  Stream<DocumentSnapshot> getPlanDetails(String workoutPlanUid) {
    return _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .snapshots();
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

  Future<void> updatePublishedStatus(
      String workoutPlanUid, bool isPublished) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .update({
      'isPublished': isPublished,
    });
  }

  Future<void> updateNumberOfExercises(
      String workoutPlanUid, String workoutUid, int exercises) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
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

  Future<DocumentReference> addNewExercise(String exerciseName, int exercise,
      String workoutPlanUid, String weekUid, String workoutUid) async {
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
      'videoUrl': null,
      'exercise': exercise,
      'sets': 0
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
    await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(copyWeek.uid)
        .collection('workouts')
        .get()
        .then((value) {
      value.docs.forEach((workoutCopyDoc) async {
        Workout workoutCopy = Workout(
            uid: workoutCopyDoc.id,
            workoutName: await workoutCopyDoc.get('workoutName'),
            weekUid: await workoutCopyDoc.get('weekUid'),
            day: await workoutCopyDoc.get('day'),
            exercises: await workoutCopyDoc.get('exercises'));
        print(workoutCopy.weekUid);
        await _firestore
            .collection('workoutPlans')
            .doc(workoutPlanUid)
            .collection('weeks')
            .doc(originalWeek.uid)
            .collection('workouts')
            .get()
            .then((value) {
          value.docs.forEach((originalWorkoutDoc) async {
            Workout originalWorkout = Workout(
              uid: originalWorkoutDoc.id,
              workoutName: await originalWorkoutDoc.get('workoutName'),
              weekUid: await originalWorkoutDoc.get('weekUid'),
              day: await originalWorkoutDoc.get('day'),
              exercises: await originalWorkoutDoc.get('exercises'),
            );
            await _firestore
                .collection('workoutPlans')
                .doc(workoutPlanUid)
                .collection('weeks')
                .doc(workoutCopy.weekUid)
                .collection('workouts')
                .doc(workoutCopy.uid)
                .update({
              'day': originalWorkout.day,
              'workoutName': originalWorkout.workoutName,
              'exercises': originalWorkout.exercises,
            }).whenComplete(() async {
              await _firestore
                  .collection('workoutPlans')
                  .doc(workoutPlanUid)
                  .collection('weeks')
                  .doc(workoutCopy.weekUid)
                  .collection('workouts')
                  .doc(workoutCopy.uid)
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
                        .doc(workoutCopy.weekUid)
                        .collection('workouts')
                        .doc(workoutCopy.uid)
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
                          .doc(workoutCopy.weekUid)
                          .collection('workouts')
                          .doc(workoutCopy.uid)
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
          });
        });
      });
    });
  }
}
