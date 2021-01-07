import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/workout_plan_card.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/cover_photo_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/promo_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';

class CoverPhoto extends StatefulWidget {
  final String workoutPlanUid;
  final bool isEdit;

  const CoverPhoto({Key key, this.workoutPlanUid, this.isEdit})
      : super(key: key);

  @override
  _CoverPhotoState createState() => _CoverPhotoState();
}

class _CoverPhotoState extends State<CoverPhoto> {
  CoverPhotoBloc _bloc = CoverPhotoBloc();
  File _pickedImage;
  final picker = ImagePicker();

  File _croppedImage;

  String title;
  int weeks;
  String coverPhotoUrl;

  double price;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: _croppedImage != null || coverPhotoUrl != null
                ? Text(kNext)
                : widget.isEdit == true
                    ? Text(kSave)
                    : Text(kSkip),
            onPressed: () async {
              _bloc
                  .downloadURL(_croppedImage,
                      widget.workoutPlanUid + '/coverPhoto', 'image/jpeg')
                  .then((value) => coverPhotoUrl = value)
                  .whenComplete(() {
                _bloc.updatePlanCover(widget.workoutPlanUid, coverPhotoUrl);
              }).whenComplete(() => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PromoVideo(
                            workoutPlanUid: widget.workoutPlanUid,
                          ),
                        ),
                      ));
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: _bloc.getPlanDetails(widget.workoutPlanUid),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              title = snapshot.data.get('title');
              weeks = snapshot.data.get('weeks');
              price = snapshot.data.get('price');
              coverPhotoUrl = snapshot.data.get('coverPhotoUrl');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      WorkoutPlanCard(
                          price: price,
                          weeks: weeks,
                          title: title,
                          image: coverPhotoUrl != null && _croppedImage == null
                              ? Image.network(coverPhotoUrl)
                              : _croppedImage != null
                                  ? Image.file(_pickedImage)
                                  : Container(
                                      color: CupertinoColors.placeholderText,
                                    )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: _pickedImage == null && coverPhotoUrl == null
                              ? Text('Add Photo')
                              : Text('Change Photo'),
                          onPressed: () {
                            showAddPhotoDialog();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<void> getImage(bool isCamera) async {
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
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _croppedImage = _pickedImage;
    });
  }

  showAddPhotoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text(
            'Add photo from...',
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                getImage(false).whenComplete(() => Navigator.pop(context));
              },
              child: const Text(
                'Gallery',
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                getImage(true).whenComplete(() => Navigator.pop(context));
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );
  }
}
