import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/login_signup/screens/login.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  //todo create a user settings bloc
  FirestoreProvider firestoreProvider = FirestoreProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('Logout'),
                onPressed: showLogoutUserDialog,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  'Delete Account',
                ),
                onPressed: showDeleteUserDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logout() async {
    await FirebaseAuth.instance
        .signOut()
        .whenComplete(() => Get.offAll(Login()));
  }

  Future deleteAccount() async {
    await FirebaseAuth.instance.currentUser
        .delete()
        .whenComplete(() => firestoreProvider.deleteUser())
        .whenComplete(() => Get.offAll(Login()));
  }

  showDeleteUserDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Account?'),
            content: Text('Are you sure you want to delete account'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              TextButton(onPressed: deleteAccount, child: Text('YES'))
            ],
          );
        });
  }

  showLogoutUserDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Log out?'),
            content: Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              TextButton(onPressed: logout, child: Text('YES'))
            ],
          );
        });
  }
}
