import 'package:fit_mart/screens/account_screen.dart';
import 'package:fit_mart/screens/discover_screen.dart';
import 'package:fit_mart/screens/my_plans_screen.dart';
import 'package:fit_mart/screens/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _title;
  int _selectedScreen = 0;
  final tabs = [
    DiscoverScreen(),
    MyPlansScreen(),
    WishlistScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    //default value fro title
    _title = DiscoverScreen.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedScreen,
          children: tabs,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedScreen,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text(DiscoverScreen.title)),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            title: Text(MyPlansScreen.title),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text(WishlistScreen.title),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(AccountScreen.title),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedScreen = index;

            switch (index) {
              case 0:
                {
                  _title = DiscoverScreen.title;
                }
                break;
              case 1:
                {
                  _title = MyPlansScreen.title;
                }
                break;
              case 2:
                {
                  _title = WishlistScreen.title;
                }
                break;
              case 3:
                {
                  _title = AccountScreen.title;
                }
                break;
            }
          });
        },
      ),
    ));
  }
}
