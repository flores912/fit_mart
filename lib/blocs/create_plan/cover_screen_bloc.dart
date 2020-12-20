import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/repository.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class CoverScreenBloc {
  Repository _repository = Repository();

  Stream<DocumentSnapshot> getWorkoutPlanInfo(
    String workoutPlanUid,
  ) =>
      _repository.getWorkoutPlanInfo(workoutPlanUid);

  Future<String> downloadURL(
    File file,
    String path,
    String contentType,
  ) =>
      _repository.downloadURL(
        file,
        path,
        contentType,
      );

  Future<void> updateCoverForWorkoutPlan(
    String workoutPlanUid,
    String coverPhotoUrl,
  ) =>
      _repository.updateCoverForWorkoutPlan(workoutPlanUid, coverPhotoUrl);

  Future<File> cropImage(bool isCamera) async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    File pickedPhoto = File(pickedFile.path);
    pickedPhoto = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
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
    return pickedPhoto;
  }
}
