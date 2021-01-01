import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/trainer_view/screens/home/plans.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/trainer_view/screens/home/trainer_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class HomeTrainer extends StatefulWidget {
  @override
  _HomeTrainerState createState() => _HomeTrainerState();
}

class _HomeTrainerState extends State<HomeTrainer> {
  final _tabs = [
    //ADD SCREENS FOR TABS HERE
    Plans(),
    TrainerAccount(),
  ];
  String _title;
  int _currentIndex = 0;
  @override
  void initState() {
    _title = Plans.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: kWorkoutPlans,
            icon: Icon(Icons.list_alt),
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
            _title = Plans.title;
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
