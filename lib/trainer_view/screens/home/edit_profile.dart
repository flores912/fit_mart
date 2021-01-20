import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/trainer_view/blocs/trainer_account_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  final String photoUrl;
  final String username;
  final String name;
  final String bio;
  final String tipUrl;

  const EditProfile(
      {Key key, this.photoUrl, this.name, this.bio, this.username, this.tipUrl})
      : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

String photoUrl;

class _EditProfileState extends State<EditProfile> {
  TrainerAccountBloc _bloc = TrainerAccountBloc();
  String name;
  String username;
  String photoUrl;
  String bio;

  File _pickedImage;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  File _croppedImage;

  bool isUsernameTaken;

  String tipUrl;

  bool isPhotoRemoved;

  @override
  void initState() {
    name = widget.name;
    photoUrl = widget.photoUrl;
    bio = widget.bio;
    username = widget.username;
    tipUrl = widget.tipUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.close),
            onTap: () => Navigator.pop(context),
          ),
          title: Text('Edit Profile'),
          actions: [
            TextButton(
              child: Text(kSave),
              onPressed: () {
                EasyLoading.show();
                checkUsername(username).whenComplete(() {
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
                              .updateProfile(
                                  name, username, bio, photoUrl, tipUrl)
                              .whenComplete(() => EasyLoading.dismiss())
                              .whenComplete(() => Navigator.pop(context)));
                    } else if (isPhotoRemoved == true) {
                      _bloc
                          .updateProfile(name, username, bio, photoUrl, tipUrl)
                          .whenComplete(() => EasyLoading.dismiss())
                          .whenComplete(() => Navigator.pop(context));
                    } else {
                      _bloc
                          .updateProfile(name, username, bio, photoUrl, tipUrl)
                          .whenComplete(() => EasyLoading.dismiss())
                          .whenComplete(() => Navigator.pop(context));
                    }
                  }
                });
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
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 200,
                          ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: username,
                    maxLines: 1,
                    maxLength: 30,
                    validator: (username) {
                      Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(username)) return 'Invalid username';
                      if (isUsernameTaken == true &&
                          widget.username != username) return 'Username taken';
                      if (username.length > 30 == true)
                        return 'Username too long';
                      else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Username' + '*',
                        alignLabelWithHint: true,
                        counterText: ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: name,
                    keyboardType: TextInputType.name,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: tipUrl,
                    keyboardType: TextInputType.url,
                    maxLines: 1,
                    onChanged: (value) {
                      tipUrl = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Tip Url ' + kOptional,
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
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
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  isPhotoRemoved = true;
                  photoUrl = null;
                  _croppedImage = null;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkUsername(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    isUsernameTaken = result.docs.isNotEmpty;
    print(isUsernameTaken);
    return isUsernameTaken;
  }
}
