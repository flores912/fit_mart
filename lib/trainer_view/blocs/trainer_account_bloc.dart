import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class TrainerAccountBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Stream<DocumentSnapshot> getUserDetails() =>
      _firestoreProvider.getUserDetails();
}
