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

  Future<QuerySnapshot> myWorkoutPlansQuerySnapshot(String email) async {
    Future<QuerySnapshot> qs;
    await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((result) {
        qs = _firestore
            .collection('users')
            .doc(result.id)
            .collection('myPlans')
            .get();
      });
    });
    return qs;
  }

//TODO: fix query
  Future<QuerySnapshot> currentPlanWorkoutsQuerySnapshot(String email) async {
    Future<QuerySnapshot> qs;
    await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((result) {
        _firestore
            .collection('users')
            .doc(result.id)
            .collection('myPlans')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            qs = _firestore
                .collection('myPlans')
                .doc(element.id)
                .collection('workouts')
                .get();
          });
        });
      });
    });
    return qs;
  }
}
