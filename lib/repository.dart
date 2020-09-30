import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> registerUser(String email, String password) =>
      _firestoreProvider.registerUser(email, password);

  Future<UserCredential> loginUser(String email, String password) =>
      _firestoreProvider.loginUser(email, password);

  User getUser() => _firestoreProvider.getUser();

  Future<QuerySnapshot> myWorkoutPlansQuerySnapshot(String email) =>
      _firestoreProvider.myWorkoutPlansQuerySnapshot(email);

  Future<QuerySnapshot> currentPlanWorkoutsQuerySnapshot(String email)=>
      _firestoreProvider.currentPlanWorkoutsQuerySnapshot(email);
}
