import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/trainer_view/blocs/trainer_account_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String photoUrl;
  final String name;
  final String bio;

  const EditProfile({Key key, this.photoUrl, this.name, this.bio})
      : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

String photoUrl;

class _EditProfileState extends State<EditProfile> {
  TrainerAccountBloc _bloc = TrainerAccountBloc();
  String name;
  String photoUrl;
  String bio;

  File _pickedImage;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  File _croppedImage;
  @override
  void initState() {
    name = widget.name;
    photoUrl = widget.photoUrl;
    bio = widget.bio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            TextButton(
              child: Text(kSave),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (_croppedImage != null) {
                    _bloc
                        .downloadURL(
                            _croppedImage,
                            FirebaseAuth.instance.currentUser.uid +
                                '/profilePhoto',
                            'image/jpeg')
                        .then((value) => photoUrl = value)
                        .whenComplete(() => _bloc
                            .updateProfile(name, bio, photoUrl)
                            .whenComplete(() => Navigator.pop(context)));
                    print(photoUrl);
                  } else {
                    _bloc
                        .updateProfile(name, bio, photoUrl)
                        .whenComplete(() => Navigator.pop(context));
                  }
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                photoUrl != null || _croppedImage != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: new BoxDecoration(
                            color: CupertinoColors.placeholderText,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: photoUrl != null && _croppedImage == null
                                  ? NetworkImage(photoUrl)
                                  : FileImage(_croppedImage),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: CupertinoColors.placeholderText,
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    showAddPhotoDialog();
                  },
                  child: Text('Change/Add Photo'),
                ),
                TextFormField(
                  initialValue: name,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    name = value;
                    if (name.isEmpty) {
                      return kRequired;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: kName + '*',
                    alignLabelWithHint: true,
                  ),
                ),
                TextFormField(
                  initialValue: bio,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    bio = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Bio ' + kOptional,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
        aspectRatioPresets: [CropAspectRatioPreset.square],
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
