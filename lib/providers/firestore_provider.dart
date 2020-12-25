import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

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

  Stream<QuerySnapshot> myWorkoutPlansQuerySnapshot(String userUid) {
    CollectionReference collectionReference =
        _firestore.collection('users').doc(userUid).collection('myPlans');
    return collectionReference.snapshots();
  }

  Stream<QuerySnapshot> myWorkoutPlansLibraryQuerySnapshot() {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    return collectionReference
        .where('userUid', isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> workoutPlansQuerySnapshot(String category) {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    return collectionReference
        .where('isPublished', isEqualTo: true)
        .where('category', isEqualTo: category)
        .snapshots();
  }

  Stream<QuerySnapshot> currentPlanWorkoutsQuerySnapshot(
      String userUid, String workoutPlanUid) {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts');

    return collectionReference.orderBy('day', descending: false).snapshots();
  }

  Stream<QuerySnapshot> exercisesQuerySnapshot(
      String workoutPlanUid, String workoutUid) {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');

    return collectionReference.snapshots();
  }

  Stream<QuerySnapshot> setsQuerySnapshot(String userUid, String workoutPlanUid,
      String workoutUid, String exerciseUid) {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');

    return collectionReference
        .orderBy('numOfSet', descending: false)
        .snapshots();
  }

  Future<void> updateExerciseSelection(String userUid, String workoutPlanUid,
      String workoutUid, String exerciseUid, bool isSelected) async {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');
    await collectionReference
        .doc(exerciseUid)
        .update({'isSelected': isSelected});
  }

  Future<void> updateSetProgress(
      String userUid,
      String workoutPlanUid,
      String workoutUid,
      String exerciseUid,
      String setUid,
      bool isSetDone) async {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    await collectionReference.doc(setUid).update({'isSetDone': isSetDone});
  }

  Future<void> updateWorkoutProgress(String userUid, String workoutPlanUid,
      String workoutUid, bool isDone) async {
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('myPlans')
        .doc(workoutPlanUid)
        .collection('workouts');
    await collectionReference.doc(workoutUid).update({'isDone': isDone});
  }

  Future<DocumentReference> createNewWorkoutPlan(
    String title,
    String description,
  ) async {
    String userUid = _firebaseAuth.currentUser.uid;
    String userName = _firebaseAuth.currentUser.displayName;
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    return await collectionReference.add({
      //this will create a new plan on step 1 and update the remaining steps as you go
      'userUid': userUid,
      'trainer': userName,
      'title': title,
      'description': description,
      'isPublished':
          null, // if not published it will be saved as draft //TODO: remember to update this field at the last step!

      //if null it will be updated later on next steps
      'category': null,
      'location': null,
      'skillLevel': null,
      'isFree': null,
      'pricing': null,
      'numberOfDays': null,
      'coverPhotoUrl': null,
      'rating': null,
      'promoVideoUrl': null,
      'numberOfReviews': null,
    });
  }

  Future<void> updateWorkoutPlanCategories(String workoutPlanUid,
      String category, String location, String skillLevel) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.doc(workoutPlanUid).update(
        {'category': category, 'location': location, 'skillLevel': skillLevel});
  }

  Future<void> updateWorkoutPlanDetails(
    String workoutPlanUid,
    String title,
    String description,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.doc(workoutPlanUid).update({
      'title': title,
      'description': description,
    });
  }

  Future<void> updateWorkoutPlanPrice(
    String workoutPlanUid,
    double price,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.doc(workoutPlanUid).update({
      'pricing': price,
    });
  }

  Future<void> addDaysToPlan(int days, String workoutPlanUid) async {
    CollectionReference workoutPlansReference =
        _firestore.collection('workoutPlans');
    await workoutPlansReference
        .doc(workoutPlanUid)
        .update({'numberOfDays': days});

    CollectionReference workoutsReference =
        workoutPlansReference.doc(workoutPlanUid).collection('workouts');
    workoutsReference.get().then((value) async {
      if (value.size >= days) {
        for (int i = days + 1; i < value.size + 1; i++) {
          await workoutsReference.doc('day ' + i.toString()).delete();
        }
      } else if (value.size <= days) {
        for (int i = value.size + 1; i <= days; i++) {
          await workoutsReference.doc('day ' + i.toString()).set({
            'day': i,
            'numberOfExercises': null,
            'title': null,
          });
        }
      }
    });
  }

  Stream<QuerySnapshot> myWorkoutsQuerySnapshot(String workoutPlanUid) {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts');

    return collectionReference.orderBy('day', descending: false).snapshots();
  }

  Future<void> createNewWorkout(String title) async {
    String userUid = _firebaseAuth.currentUser.uid;
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('workoutLibrary');
    await collectionReference.add({'title': title});
  }

  Future<void> updateNewWorkoutToWorkoutPlan(
      String workoutPlanUid, String workoutUid, String title) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts');
    await collectionReference.doc(workoutUid).update({'title': title});
  }

  Future<void> createNewExercise(
      String title, String videoUrl, int sets, int reps, int rest) async {
    String userUid = _firebaseAuth.currentUser.uid;
    CollectionReference collectionReference = _firestore
        .collection('users')
        .doc(userUid)
        .collection('exerciseLibrary');
    await collectionReference.add({
      'title': title,
      'videoUrl': videoUrl,
      'sets': sets,
      'reps': reps,
      'rest': rest,
    });
  }

  Future<DocumentReference> addNewExerciseToWorkout(
    String workoutPlanUid,
    String workoutUid,
    String title,
    String videoUrl,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');
    return await collectionReference.add({
      'title': title,
      'videoUrl': videoUrl,
    });
  }

  Future<void> updateNewExerciseForWorkout(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    String title,
    String videoUrl,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises');
    await collectionReference.doc(exerciseUid).update({
      'title': title,
      'videoUrl': videoUrl,
    });
  }

  Future<DocumentReference> addNewSetToExercise(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    int set,
    int reps,
    int rest,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    return await collectionReference.add({
      'set': set,
      'reps': reps,
      'rest': rest,
    });
  }

  Stream<QuerySnapshot> exerciseSetsQuerySnapshot(
      String workoutPlanUid, String workoutUid, String exerciseUid) {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');

    return collectionReference.orderBy('set', descending: false).snapshots();
  }

  Future<void> updateSetOrderForExercise(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    String setUid,
    int setNumber,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    await collectionReference.doc(setUid).update({
      'set': setNumber,
    });
  }

  Future<void> updateSetForExercise(
    String workoutPlanUid,
    String workoutUid,
    String exerciseUid,
    String setUid,
    int reps,
    int rest,
  ) async {
    CollectionReference collectionReference = _firestore
        .collection('workoutPlans')
        .doc(workoutPlanUid)
        .collection('workouts')
        .doc(workoutUid)
        .collection('exercises')
        .doc(exerciseUid)
        .collection('sets');
    await collectionReference.doc(setUid).update({
      'reps': reps,
      'rest': rest,
    });
  }

  Stream<DocumentSnapshot> getWorkoutPlanInfo(String workoutPlanUid) {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    return collectionReference.doc(workoutPlanUid).snapshots();
  }

  Future<void> updateCoverForWorkoutPlan(
    String workoutPlanUid,
    String coverPhotoUrl,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.doc(workoutPlanUid).update({
      'coverPhotoUrl': coverPhotoUrl,
    });
  }

  Future<void> updatePromoVideoForWorkoutPlan(
    String workoutPlanUid,
    String promoVideoUrl,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.doc(workoutPlanUid).update({
      'promoVideoUrl': promoVideoUrl,
    });
  }

  Future<void> updatePublishStatus(
    String workoutPlanUid,
    bool isPublished,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection('workoutPlans');
    await collectionReference.doc(workoutPlanUid).update({
      'isPublished': isPublished,
    });
  }

  Future<String> downloadURL(File file, String path, String contentType) async {
    final Reference reference = storage.ref().child(path);
    await reference.putFile(file, SettableMetadata(contentType: contentType));
    return await reference.getDownloadURL();

    // Within your widgets:
    // Image.network(downloadURL);
  }
}
