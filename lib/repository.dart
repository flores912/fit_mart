import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> registerUser(String email, String password) =>
      _firestoreProvider.registerUser(email, password);

  Future<UserCredential> loginUser(String email, String password) =>
      _firestoreProvider.loginUser(email, password);

  User getUser() => _firestoreProvider.getUser();

  Future<void> myWorkoutPlansList(String email) =>
      _firestoreProvider.myWorkoutPlansList(email);
}
