import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/login_signup/screens/login.dart';
import 'package:fit_mart/trainer_view/screens/home/my_plans.dart';
import 'package:fit_mart/trainer_view/screens/home/plans.dart';
import 'package:fit_mart/trainer_view/screens/home/trainer_account.dart';
import 'package:fit_mart/trainer_view/screens/home/user_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class HomeTrainer extends StatefulWidget {
  final String username;
  static const String id = 'home_trainer';

  const HomeTrainer({Key key, this.username}) : super(key: key);
  @override
  _HomeTrainerState createState() => _HomeTrainerState();
}

class _HomeTrainerState extends State<HomeTrainer> {
  final _tabs = [
    Plans(),
    //Sales(),
    TrainerAccount(
      userUid: FirebaseAuth.instance.currentUser.uid,
    ),
  ];
  String _title;
  int _currentIndex = 1;
  @override
  void initState() {
    _title = 'Workout Plans';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //prevent users to go back
        title: Text(_title),
        actions: [
          _currentIndex == 2
              ? GestureDetector(
                  onTap: () async {
                    Get.to(UserSettings());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.settings),
                  ))
              : Container()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Workout Plans',
            icon: Icon(Icons.fitness_center),
          ),
          BottomNavigationBarItem(
            label: kAccount,
            icon: Icon(Icons.person),
          ),
        ],
        onTap: _selectedTab,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
    );
  }

  void _selectedTab(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Workout Plans';
          }
          break;

        case 1:
          {
            _title = TrainerAccount.title;
          }
          break;
      }
    });
  }
}
