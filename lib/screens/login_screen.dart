import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/custom_material_button.dart';
import 'package:fit_mart/models/authentication.dart';
import 'package:fit_mart/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fit_mart/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  Authentication authentication = Authentication();

  @override
  void initState() {
    authentication.checkIfUserIsLoggedIn(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: 'Email',
                textInputType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email),
                isObscure: false,
                onChanged: (value) {
                  email = value;
                },
              ),
              CustomTextField(
                labelText: 'Password',
                textInputType: TextInputType.text,
                prefixIcon: Icon(Icons.lock),
                isObscure: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomMaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                title: 'Login',
                onPressed: () {
                  authentication.signInWithEmail(
                      email: email,
                      password: password,
                      context: context,
                      routeName: HomeScreen.id);
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'OR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 1.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomMaterialButton(
                color: Colors.white,
                textColor: Colors.red,
                title: 'Sign Up',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
