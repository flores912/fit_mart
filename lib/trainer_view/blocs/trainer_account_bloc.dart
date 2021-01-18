import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firebase_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class TrainerAccountBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  FirebaseProvider _firebaseProvider = FirebaseProvider();
  Stream<DocumentSnapshot> getUserDetails(String userUid) =>
      _firestoreProvider.getUserDetails(userUid);

  Stream<QuerySnapshot> getTrainerPlans() =>
      _firestoreProvider.getTrainerPlans();
  Stream<QuerySnapshot> getPublishedTrainerPlans(String userUid) =>
      _firestoreProvider.getPublishedTrainerPlans(userUid);
  Future<void> deletePlan(String workoutPlanUid) =>
      _firestoreProvider.deletePlan(
        workoutPlanUid,
      );
  Future<String> downloadURL(File file, String path, String contentType) =>
      _firebaseProvider.downloadURL(file, path, contentType);
  Future<void> updateProfile(String name, String username, String bio,
          String photoUrl, String tipUrl) =>
      _firestoreProvider.updateProfile(name, username, bio, photoUrl, tipUrl);
}
