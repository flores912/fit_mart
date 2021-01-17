import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/login_signup/blocs/sign_up_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  SignUpBloc _bloc = SignUpBloc();

  String email;

  String password;

  String name;

  String username;

  bool isUsernameTaken;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.none,
                maxLength: 30,
                onChanged: (value) {
                  username = value;
                },
                validator: (username) {
                  Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(username)) return 'Invalid username';
                  if (isUsernameTaken == true) {
                    return 'Username taken';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  alignLabelWithHint: true,
                ),
              ),
              TextFormField(
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
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                validator: (email) => EmailValidator.validate(email)
                    ? null
                    : "Invalid email address",
                onSaved: (email) => this.email = email,
                decoration: InputDecoration(
                  labelText: kEmail,
                  alignLabelWithHint: true,
                ),
              ),
              TextFormField(
                obscureText: true,
                maxLength: 40,
                enableSuggestions: false,
                autocorrect: false,
                validator: (password) {
                  if (password.isEmpty) {
                    return kRequired;
                  } else if (password.length < 10) {
                    return 'Password needs to be at least 10 characters long';
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: kPassword,
                  alignLabelWithHint: true,
                ),
              ),
              RaisedButton(
                child: (Text(
                  kSignUp,
                )),
                onPressed: () async {
                  checkUsername(username).whenComplete(() async {
                    if (_formKey.currentState.validate()) {
                      await _bloc.signUp(email, password).whenComplete(
                          () async => await _bloc
                                  .addUserDetails(name, username)
                                  .whenComplete(() async {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  print(password);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      HomeTrainer.id,
                                      (Route<dynamic> route) => false);
                                }
                              })

                          //go to home page
                          );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkUsername(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    isUsernameTaken = result.docs.isNotEmpty;
    return isUsernameTaken;
  }
}
