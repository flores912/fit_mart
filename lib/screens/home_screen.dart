import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/account_screen.dart';
import 'package:fit_mart/screens/create_new_plan_step1_screen.dart';
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

  final tabs = [
    DiscoverScreen(),
    MyPlansScreen(),
    WishlistScreen(),
    AccountScreen(),
  ];

  int _selectedScreen = 0;

  @override
  void initState() {
    //default value fro title
    _title = DiscoverScreen.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedScreen,
          children: tabs,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create New Plan',
        onPressed: () {
          Navigator.pushNamed(context, CreateNewPlanStep1Screen.id);
        },
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        elevation: 2.0,
      ),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Create New Plan',
        color: Colors.grey,
        onTabSelected: _selectedTab,
        selectedColor: Colors.red,
        notchedShape: CircularNotchedRectangle(),
        items: [
          FABBottomAppBarItem(iconData: Icons.search, text: 'Explore'),
          FABBottomAppBarItem(iconData: Icons.fitness_center, text: 'My Plans'),
          FABBottomAppBarItem(iconData: Icons.favorite, text: 'Wishlist'),
          FABBottomAppBarItem(iconData: Icons.account_circle, text: 'Account'),
        ],
      ),
    );
  }

  void _selectedTab(int index) {
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
  }
}

/// FAB BOTTOM APP BAR LOGIC */

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, this.text});
  IconData iconData;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.items,
    this.centerItemText,
    this.height: 84.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
