import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';

class Authentication {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String email;
  String password;

  Future<void> signInWithEmail(
      {email, password, BuildContext context, String routeName}) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, routeName);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkIfUserIsLoggedIn(BuildContext context) async {
    if (await FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
  }
}
