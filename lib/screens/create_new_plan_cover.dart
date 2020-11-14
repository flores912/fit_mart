import 'dart:io';

import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'create_new_plan_pricing.dart';

//TODO : EDIT INFO.PLIST FOR ON XCODE FOR CAMERA PERMISSIONS AND ALSO ANDROID
class CreateNewPlanCoverScreen extends StatefulWidget {
  static const String title = ' Step 3 of 4: Cover Photo';
  static const String id = 'create_new_plan_cover_screen';

  @override
  CreateNewPlanCoverScreenState createState() =>
      CreateNewPlanCoverScreenState();
}

class CreateNewPlanCoverScreenState extends State<CreateNewPlanCoverScreen> {
  PickedFile imageUri;
  final ImagePicker _picker = ImagePicker();

  Future getImageFromCameraGallery(bool isCamera) async {
    var image = await _picker.getImage(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      imageUri = image;
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
              Navigator.pushNamed(context, CreateNewPlanPricingScreen.id);
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageUri == null
                ? Icon(
                    Icons.image,
                    size: 200,
                  )
                : Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(imageUri.path),
                      ),
                    ),
                  ),
            SizedBox(
              height: 16,
            ),
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
                  getImageFromCameraGallery(false);
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
                  getImageFromCameraGallery(true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
