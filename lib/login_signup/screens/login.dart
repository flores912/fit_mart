import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/login_signup/blocs/login_bloc.dart';
import 'package:fit_mart/login_signup/screens/sign_up.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Login extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _bloc = LoginBloc();

  String password;

  String email;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  labelText: kEmail,
                  alignLabelWithHint: true,
                ),
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: kPassword,
                  alignLabelWithHint: true,
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Text(kForgotPassword),
              ),
              RaisedButton(
                child: (Text(
                  kLogin,
                )),
                onPressed: () {
                  _bloc.login(email, password).whenComplete(() async {
                    if (FirebaseAuth.instance.currentUser != null) {
                      // signed in
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeTrainer(),
                        ),
                      );
                    } else {}
                  });
                },
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Text(kSignUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
