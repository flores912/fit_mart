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
}
