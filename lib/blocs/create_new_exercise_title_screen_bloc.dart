import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/set.dart';
import 'package:flutter/cupertino.dart';

class CreateNewExerciseTitleScreenBloc {
  List<Set> convertToSetsList({@required List<DocumentSnapshot> docList}) {
    List<Set> mySetsList = [];
    docList.forEach((document) {
      Set set = Set(
        uid: document.id,
        numOfSet: document.get('set'),
        reps: document.get('reps'),
        rest: document.get('rest'),
      );
      mySetsList.add(set);
    });
    return mySetsList;
  }
}
