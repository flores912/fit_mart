import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/screens/account_screen.dart';
import 'package:fit_mart/screens/explore_screen.dart';
import 'package:fit_mart/screens/my_workout_plans_screen.dart';
import 'package:fit_mart/screens/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedScreen = 0;
  final tabs = [
    ExploreScreen(),
    MyWorkoutPlansScreen(),
    WishlistScreen(),
    AccountScreen(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: IndexedStack(
        index: _selectedScreen,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedScreen,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Discover')),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            title: Text('Workouts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Wishlist'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedScreen = index;
          });
        },
      ),
    ));
  }
}
