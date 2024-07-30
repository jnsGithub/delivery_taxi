import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/model/myInfo.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../global.dart';

class MyInfomation{
  final db = FirebaseFirestore.instance;

  Future setUser(MyInfo a) async {
    await db.collection('users').doc(uid).set(a.toMap());
    Get.back();
  }

  Future<String> licenseUploadImage(XFile _image) async {
    try {
      final storage = FirebaseStorage.instance;

      final fileName = 'license/${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = storage.ref().child(fileName);

      final file = File(_image.path);
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'image/png'),
      );

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadURL = await snapshot.ref.getDownloadURL();

      print('File uploaded successfully: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Failed to upload image: $e');
      return '';
    }
  }
}