import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firebase_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PromoVideoBloc {
  FirebaseProvider _firebaseProvider = FirebaseProvider();
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<String> downloadURL(File file, String path, String contentType) =>
      _firebaseProvider.downloadURL(file, path, contentType);

  Future<void> updatePlanPromo(
    String workoutPlanUid,
    String promoVideoUrl,
  ) =>
      _firestoreProvider.updatePlanPromo(workoutPlanUid, promoVideoUrl);

  Future<DocumentSnapshot> getPlanDetails(String workoutPlanUid) =>
      _firestoreProvider.getPlanDetails(workoutPlanUid);
}
