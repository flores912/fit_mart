import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/trainer_view/blocs/trainer_account_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainerAccount extends StatefulWidget {
  static const String title = kAccount;

  @override
  _TrainerAccountState createState() => _TrainerAccountState();
}

class _TrainerAccountState extends State<TrainerAccount> {
  String name;

  String photoUrl;

  TrainerAccountBloc _bloc = TrainerAccountBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _bloc.getUserDetails(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              name = snapshot.data.get('name');
              photoUrl = snapshot.data.get('photoUrl');
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //TODO:ADD PLACEHOLDER
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(photoUrl),
                        ),
                      ),
                    ),
                  ),
                  Text(name),
                  FlatButton(
                    child: Text(kChangeToClientView),
                    onPressed: () {},
                  ),
                  Text(kWorkoutPlans),
                  //TODO:insert List here
                ],
              ),
            );
          }),
    );
  }
}
