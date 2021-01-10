import 'package:fit_mart/constants.dart';
import 'package:fit_mart/login_signup/blocs/sign_up_bloc.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpBloc _bloc = SignUpBloc();

  String email;

  String password;

  String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                labelText: kName,
                alignLabelWithHint: true,
              ),
            ),
            TextFormField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                labelText: kEmail,
                alignLabelWithHint: true,
              ),
            ),
            TextFormField(
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
                await _bloc.signUp(email, password).whenComplete(() async =>
                        await _bloc.addUserDetails(name).whenComplete(() {
                          if (FirebaseAuth.instance.currentUser != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeTrainer(),
                              ),
                            );
                          }
                        })

                    //go to home page
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
