import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/main.dart';
import 'package:delivery_taxi/model/myInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakaoAuth;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../global.dart';
import 'myInfoData.dart';

class SocialLogin{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  MyInfomation myInfomation = MyInfomation();
  Future<void> signInWithKakao(bool isTaxi,String type) async{
    try{
      var provider = OAuthProvider("oidc.kakao");

      bool isInstalled = await kakaoAuth.isKakaoTalkInstalled();

      kakaoAuth.OAuthToken token = isInstalled
          ? await kakaoAuth.UserApi.instance.loginWithKakaoTalk()
          : await kakaoAuth.UserApi.instance.loginWithKakaoAccount();

      final AuthCredential credential = provider.credential(accessToken: token.accessToken, idToken: token.idToken);

      final UserCredential firebaseCredential = await auth.signInWithCredential(credential);

      User user = await firebaseCredential.user!;
      uid = user.uid;
      loginType = '카카오';



      //Fcm Token 발급
      FirebaseMessaging.instance.getToken().then((value) {
        setFcmToken(value ?? '');
      });
      var a = await myInfomation.getUser();
      if(a.documentId != ''){
        myInfo = a;
        if(myInfo.type == 'taxi' || myInfo.type == 'userTaxi'){
          if(a.isAuth){
            Get.toNamed('/taxiMainView');
          } else {
            Get.snackbar('로그인', '승인을 위해 검토중입니다');
          }
        } else {
          Get.toNamed('/userMainView');
        }
      } else {
        if(isTaxi){
          Get.toNamed('/taxiSignUpView',arguments: type);
        } else {
          Get.toNamed('/signUpView');
        }
      }
    } catch(e){
    }
  }

  Future<void> signInWithApple(bool isTaxi,String type) async{
    try{
      final appleCredential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final UserCredential firebaseCredential = await auth.signInWithCredential(credential);
      User user = await firebaseCredential.user!;
      uid = user.uid;
      loginType = '애플';
      FirebaseMessaging.instance.getToken().then((value) {
        setFcmToken(value ?? '');
      });

      var a = await myInfomation.getUser();
      if(a.documentId != '') {
        myInfo = a;
        if(myInfo.type == 'taxi' || myInfo.type == 'userTaxi'){
          if(a.isAuth){
            Get.toNamed('/taxiMainView');
          } else {
            Get.snackbar('로그인', '승인을 위해 검토중입니다');
          }
        } else {
          Get.toNamed('/userMainView');
        }
      } else {
        if (isTaxi) {
          Get.toNamed('/taxiSignUpView', arguments: type);
        } else {
          Get.toNamed('/signUpView');
        }
      }
    }catch(e){
    }
  }

  Future<bool> accountCheck(String uid) async {
    try{
     DocumentSnapshot snapshot = await db.collection('users').doc(uid).get();
     if(!snapshot.exists){
       await signOut();
       return false;
     }
     else{
       return true;
     }
    } catch(e){
      return false;
    }
  }

  Future<void> signOut() async{
    try{
      if(loginType == '카카오'){
        await auth.signOut();
        await kakaoAuth.UserApi.instance.logout();
      }
      else{
        await auth.signOut();
      }
      uid = '';
      myInfo = MyInfo(
        documentId: 'doc.id',
        type: '',
        name: '',
        hp: '',
        address1: '',
        address2: '',
        taxiNumber: '',
        taxiType: '',
        taxiImage: '',
        isAuth: false,
        createDate: Timestamp.now(),
      );
      Get.offAllNamed('/enterView');
    } catch(e){
    }
  }

  Future deleteAccount(BuildContext context) async{
    try{
      saving(context);
      if(loginType == '카카오'){
        await kakaoAuth.UserApi.instance.unlink();
      }
      await auth.currentUser!.delete();
      await auth.signOut();
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      uid = '';
      myInfo = MyInfo(
        documentId: 'doc.id',
        type: '',
        name: '',
        hp: '',
        address1: '',
        address2: '',
        taxiNumber: '',
        taxiType: '',
        taxiImage: '',
        isAuth: false,
        createDate: Timestamp.now(),
      );
      Get.offAllNamed('/enterView');
    } catch(e){
      Get.back();
    }
  }
}
