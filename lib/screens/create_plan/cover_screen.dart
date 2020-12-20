import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/create_plan/cover_screen_bloc.dart';
import 'package:fit_mart/blocs/create_plan/cover_screen_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/promo_video_screen.dart';
import 'package:fit_mart/widgets/workout_plan_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CoverScreen extends StatefulWidget {
  static const String title = ' Step 6 of 7: Cover Photo';
  static const String id = 'cover_screen';

  final bool isEdit;
  final String coverPhotoUrl;
  final String workoutPlanUid;

  const CoverScreen({
    Key key,
    this.isEdit,
    this.coverPhotoUrl,
    this.workoutPlanUid,
  }) : super(key: key);
  @override
  CoverScreenState createState() => CoverScreenState();
}

class CoverScreenState extends State<CoverScreen> {
  CoverScreenBloc _bloc;

  File _croppedImage;

  double price;

  String category;

  String location;

  String skillLevel;

  String title;

  int numberOfReviews;

  int rating;

  DocumentSnapshot workoutPlan;

  @override
  void didChangeDependencies() {
    _bloc = CoverScreenBlocProvider.of(context);

    _bloc.getWorkoutPlanInfo(widget.workoutPlanUid).forEach((element) {
      setState(() {
        category = element.get('category');
        location = element.get('location');
        skillLevel = element.get('skillLevel');
        title = element.get('title');
        rating = element.get('rating');
        numberOfReviews = element.get('numberOfReviews');
        price = element.get('pricing');
      });
    });
    super.didChangeDependencies();
  }

  Widget getImage() {
    Widget imageWidget;
    if (_croppedImage != null) {
      imageWidget = Image.file(
        _croppedImage,
        fit: BoxFit.fill,
      );
    } else if (widget.coverPhotoUrl != null) {
      imageWidget = Image.network(
        widget.coverPhotoUrl,
        fit: BoxFit.fill,
      );
    } else if (widget.coverPhotoUrl == null && _croppedImage == null) {
      imageWidget = Container(
        height: MediaQuery.of(context).size.width / 1.5 / 1.78,
        child: Icon(
          Icons.image,
          color: Colors.grey.shade800,
          size: 100,
        ),
      );
    }
    return imageWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CoverScreen.title),
        centerTitle: true,
        actions: [
          widget.isEdit != true
              ? FlatButton(
                  onPressed: () {
                    _croppedImage != null
                        ? _bloc
                            .downloadURL(
                                _croppedImage,
                                widget.workoutPlanUid + '/coverPhoto',
                                'image/jpeg')
                            .then((value) {
                            _bloc
                                .updateCoverForWorkoutPlan(
                                    widget.workoutPlanUid, value)
                                .whenComplete(
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PromoVideoScreen(
                                        workoutPlanUid: widget.workoutPlanUid,
                                      ),
                                    ),
                                  ),
                                );
                          })
                        : null; //TODO: CORRECT DEFICIENCIES
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : FlatButton(
                  onPressed: () {
                    _bloc
                        .downloadURL(_croppedImage,
                            widget.workoutPlanUid + '/coverPhoto', 'image/jpeg')
                        .then((value) {
                      _bloc
                          .updateCoverForWorkoutPlan(
                              widget.workoutPlanUid, value)
                          .whenComplete(
                            () => Navigator.pop(context),
                          );
                    });
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            WorkoutPlanCardWidget(
              image: getImage(),
              price: price,
              category: category,
              location: location,
              skillLevel: skillLevel,
              title: title,
              numberOfReviews: numberOfReviews,
              rating: rating,
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
                      _bloc.cropImage(false).then((value) {
                        setState(() {
                          _croppedImage = value;
                        });
                      });
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
                      _bloc.cropImage(true).then((value) {
                        setState(() {
                          _croppedImage = value;
                        });
                      });
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
