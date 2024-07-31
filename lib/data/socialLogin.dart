import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/main.dart';
import 'package:delivery_taxi/model/myInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakaoAuth;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../global.dart';
import 'myInfoData.dart';

class SocialLogin{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  MyInfomation myInfomation = MyInfomation();
  Future<void> signInWithKakao(bool isTaxi) async{
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
      var a = await myInfomation.login();
      if(a.runtimeType == MyInfo){
        myInfo = a as MyInfo;
        if(myInfo.type == 'taxi'){
          Get.toNamed('/taxiMainView');
        } else {
          Get.toNamed('/userMainView');
        }
      } else {
        if(isTaxi){
          Get.toNamed('/taxiSignUpView');
        } else {
          Get.toNamed('/signUpView');
        }
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> signInWithApple(bool isTaxi) async{
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

      print('uid : ' + uid);
      if(isTaxi){
        Get.toNamed('/taxiSignUpView');
      } else {
        Get.toNamed('/signUpView');
      }
    }catch(e){
      print(e);
    }
  }

}
