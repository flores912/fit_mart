import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firebase_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class CoverPhotoBloc {
  FirebaseProvider _firebaseProvider = FirebaseProvider();
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<String> downloadURL(File file, String path, String contentType) =>
      _firebaseProvider.downloadURL(file, path, contentType);
  Future<void> updatePlanCover(
    String workoutPlanUid,
    String coverPhotoUrl,
  ) =>
      _firestoreProvider.updatePlanCover(workoutPlanUid, coverPhotoUrl);

  Future<DocumentSnapshot> getPlanDetails(String workoutPlanUid) =>
      _firestoreProvider.getPlanDetails(workoutPlanUid);
}
