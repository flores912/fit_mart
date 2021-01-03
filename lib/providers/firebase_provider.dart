import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseProvider {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> downloadURL(File file, String path, String contentType) async {
    final Reference reference = storage.ref().child(path);
    await reference.putFile(file, SettableMetadata(contentType: contentType));
    return await reference.getDownloadURL();
  }
}
