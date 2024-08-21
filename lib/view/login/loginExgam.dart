import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/myInfo.dart';

class LoginExgam{
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> loginCheck(String id, String pw) async{
    try{
      bool isCheck = false;
      await db.collection('users').doc('hAO4dLUZWzbGlUz3fJ4f').get().then((value) {
         if(value.data()!['hp'] == id && value.data()!['name'] == pw){
           myInfo = MyInfo.fromFirestore(value);
           uid = value.id;
           auth.signInAnonymously();
           loginType = '애플';
           isCheck =  true;
         } else {
           isCheck = false;
         }
      });
      return isCheck;
    } catch(e){
      print(e);
      return false;
    }

  }
}