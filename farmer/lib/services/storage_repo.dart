import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepo {
  FirebaseStorage _storage =
      // ignore: deprecated_member_use
      FirebaseStorage(storageBucket: "gs://dairy-36666.appspot.com");

  Future<String> uploadFile(File file) async {
    var userId = FirebaseAuth.instance.currentUser.uid;

    Reference storageRef = _storage.ref().child("users/profile/$userId");
    UploadTask uploadTask = storageRef.putFile(file);
    String downloadUrl;
    await uploadTask.then((TaskSnapshot completedTask) async {
      downloadUrl = await completedTask.ref.getDownloadURL();
    });
    return downloadUrl;
  }

  Future<String> getUserProfileImage(String uid) async {
    return await _storage.ref().child("users/profile/$uid").getDownloadURL();
  }
}
