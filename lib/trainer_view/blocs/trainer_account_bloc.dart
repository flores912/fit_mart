import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firebase_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class TrainerAccountBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  FirebaseProvider _firebaseProvider = FirebaseProvider();
  Stream<DocumentSnapshot> getUserDetails() =>
      _firestoreProvider.getUserDetails();

  Stream<QuerySnapshot> getTrainerPlans() =>
      _firestoreProvider.getTrainerPlans();
  Stream<QuerySnapshot> getPublishedTrainerPlans() =>
      _firestoreProvider.getPublishedTrainerPlans();
  Future<void> deletePlan(String workoutPlanUid) =>
      _firestoreProvider.deletePlan(
        workoutPlanUid,
      );
  Future<String> downloadURL(File file, String path, String contentType) =>
      _firebaseProvider.downloadURL(file, path, contentType);
  Future<void> updateProfile(
    String name,
    String bio,
    String photoUrl,
  ) =>
      _firestoreProvider.updateProfile(name, bio, photoUrl);
}
