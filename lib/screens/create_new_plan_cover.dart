import 'dart:io';

import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/create_new_plan_video_overview.dart';
import 'package:fit_mart/widgets/workout_plan_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreateNewPlanCoverScreen extends StatefulWidget {
  static const String title = ' Step 6 of 7: Cover Photo';
  static const String id = 'create_new_plan_cover_screen';

  @override
  CreateNewPlanCoverScreenState createState() =>
      CreateNewPlanCoverScreenState();
}

class CreateNewPlanCoverScreenState extends State<CreateNewPlanCoverScreen> {
  File _pickedImage;
  final picker = ImagePicker();

  File _croppedImage;

  Future getImage(bool isCamera) async {
    final pickedFile = await picker.getImage(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    cropImage(pickedFile.path);
  }

  Future cropImage(String imagePath) async {
    _pickedImage = await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _croppedImage = _pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreateNewPlanCoverScreen.title),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateNewPlanVideoOverview.id);
            },
            textColor: Colors.white,
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            WorkoutPlanCardWidget(
              image: _croppedImage,
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: kPrimaryColor,
                    child: Text(
                      'Add From Gallery',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      getImage(false);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: kPrimaryColor,
                    child: Text(
                      'Take Photo',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      getImage(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
