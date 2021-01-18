import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email;
  final _formKey = GlobalKey<FormState>();

  bool isUserExistent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (email) {
                  if (isUserExistent == false) return "User doesn't exist";
                  if (email.isEmpty) return 'Required';
                  if (EmailValidator.validate(email))
                    return null;
                  else
                    return "Invalid email address";
                },
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  labelText: kEmail,
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Send password reset to this email',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            RaisedButton(
              child: Text('Send email'),
              onPressed: sendPasswordReset,
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkIfUserExists(String email) async {
    await FirebaseAuth.instance.fetchSignInMethodsForEmail(email).then((value) {
      if (isUserExistent = value.isNotEmpty) {
      } else {}
    });
  }

  sendPasswordReset() async {
    await checkIfUserExists(email).whenComplete(() async {
      if (_formKey.currentState.validate()) {
        EasyLoading.show();
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email)
            .whenComplete(() =>
                EasyLoading.showSuccess('Password reset link sent to:$email'));
      }
    });
  }
}
