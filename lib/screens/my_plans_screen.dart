import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPlansScreen extends StatefulWidget {
  static const String title = 'My Plans';

  @override
  MyPlansScreenState createState() => MyPlansScreenState();
}

class MyPlansScreenState extends State<MyPlansScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
    );
  }
}
