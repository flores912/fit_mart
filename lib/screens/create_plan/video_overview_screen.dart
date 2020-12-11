import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/workouts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoOverviewScreen extends StatefulWidget {
  static const String title = ' Step 7 of 7: Video Overview';
  static const String id = 'video_overview_screen';

  @override
  VideoOverviewScreenState createState() => VideoOverviewScreenState();
}

class VideoOverviewScreenState extends State<VideoOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(VideoOverviewScreen.title),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, WorkoutsScreen.id);
            },
            textColor: Colors.white,
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
