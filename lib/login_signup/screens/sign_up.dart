import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/login_signup/blocs/sign_up_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SignUpBloc _bloc = SignUpBloc();

  String email;

  String password;

  String name;

  String username;

  bool isUsernameTaken;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.none,
                      maxLength: 30,
                      onChanged: (value) {
                        username = value;
                      },
                      validator: (username) {
                        Pattern pattern =
                            r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(username))
                          return 'Invalid username';
                        if (isUsernameTaken == true) return 'Username taken';
                        if (username.length > 30 == true)
                          return 'Username too long';
                        else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (name) {
                        if (name.isEmpty) {
                          return kRequired;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: InputDecoration(
                        labelText: kName,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (email) => EmailValidator.validate(email)
                          ? null
                          : "Invalid email address",
                      decoration: InputDecoration(
                        labelText: kEmail,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (password) {
                        if (password.isEmpty) {
                          return kRequired;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        labelText: kPassword,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      child: (Text(
                        kSignUp,
                      )),
                      onPressed: () async {
                        await signUp(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp(BuildContext context) async {
    checkUsername(username).whenComplete(() async {
      if (_formKey.currentState.validate()) {
        EasyLoading.show();
        try {
          UserCredential userCredential = await _bloc.signUp(email, password);
          if (userCredential != null)
            return await _bloc
                .addUserDetails(name, username)
                .whenComplete(() async {
              if (FirebaseAuth.instance.currentUser != null) {
                EasyLoading.dismiss()
                    .whenComplete(() => Get.offAll(HomeTrainer()));
              }
            });
        } on FirebaseAuthException catch (error) {
          EasyLoading.dismiss();
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(getMessageFromErrorCode(error))));
        }

        //go to home page
      }
    });
  }

  Future<bool> checkUsername(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    isUsernameTaken = result.docs.isNotEmpty;
    return isUsernameTaken;
  }

  String getMessageFromErrorCode(FirebaseAuthException error) {
    switch (error.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
        break;
      default:
        return "Login failed. Please try again.";
        break;
    }
  }
}
