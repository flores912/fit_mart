import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> createNewPlan(
    String title,
    String description,
    double price,
    bool isFree,
  ) async {
    return await _firestore.collection('workoutPlans').add({
      'title': title,
      'description': description,
      'price': price,
      'isFree': isFree,
    });
  }
}
