import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlansBloc {
  FirestoreProvider firestoreProvider = FirestoreProvider();

  Stream<QuerySnapshot> getTrainerPlans() =>
      firestoreProvider.getTrainerPlans();
}
