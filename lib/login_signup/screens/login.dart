import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/login_signup/blocs/login_bloc.dart';
import 'package:fit_mart/login_signup/screens/sign_up.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
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
                  print(password);
                  _bloc.login(email, password).then((value) {
                    if (value.user != null) {
                      Navigator.popAndPushNamed(context, HomeTrainer.id);
                    }
                  });

                  // _bloc.login(email, password).whenComplete(() async {
                  //   if (FirebaseAuth.instance.currentUser != null) {
                  //     // signed in
                  //
                  //   } else {}
                  // });
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
