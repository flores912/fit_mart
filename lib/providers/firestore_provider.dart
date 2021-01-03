import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

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

  Future<DocumentSnapshot> getPlanDetails(String workoutPlanUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
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
      'description': description,
      'price': price,
      'isFree': isFree,
    });
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

  Future<QuerySnapshot> getExerciseNumber(
      String workoutPlanUid, String weekUid, String workoutUid) async {
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .get();
  }

  Future<void> updateWorkoutExerciseNumber(
      String workoutPlanUid, String weekUid, String workoutUid) async {
    int exercises;
    await getExerciseNumber(workoutPlanUid, weekUid, workoutUid).then((value) {
      exercises = value.size;
    });
    return await _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('weeks')
        .doc(weekUid)
        .collection('workouts')
        .doc(workoutUid)
        .update({'exercises': exercises});
  }
}
