import 'package:fit_mart/trainer_view/screens/home/others_plans.dart';
import 'package:fit_mart/trainer_view/screens/home/my_plans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Plans extends StatefulWidget {
  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(
      child: Text('By You'),
    ),
    Tab(
      child: Text('By Others'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: list.length,
      initialIndex: _selectedIndex,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            bottom: TabBar(
              tabs: list,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            MyPlans(),
            OthersPlans(),
          ],
        ),
      ),
    );
  }
}
