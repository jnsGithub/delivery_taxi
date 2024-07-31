import 'dart:async';
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
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<MyInfo> getUser(String uid) async {
    final snapshot = await db.collection('users').doc(uid).get();
    if(snapshot.exists){
      return MyInfo.fromFirestore(snapshot);
    }else{
      return MyInfo(
          documentId: '',
          type: '',
          name: '',
          hp: '',
          address1: '',
          address2: '',
          taxiNumber: '',
          taxiType: '',
          taxiImage: '',
          isAuth: false,
          createDate: Timestamp.now());
    }
  }

  Future setUser(a) async {
    try{
      await userCollection.doc(uid).set(a);
      return true;
    } catch(e){
      print(e);
      return false;
    }

  }
  Future login() async {
    try{
      if(uid == ''){
        return false;
      }
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      if(!documentSnapshot.exists){
        return false;
      }
      MyInfo myInfo = MyInfo.fromFirestore(documentSnapshot);
      // DocumentReference documentRef = userCollection.doc(data['documentId']);
      // documentRef.update({
      //   "fcmToken":  await FirebaseMessaging.instance.getToken(),
      // });

      if(myInfo.documentId == uid){
        return myInfo;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
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
