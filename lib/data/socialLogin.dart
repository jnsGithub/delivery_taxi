import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakaoAuth;

class SocialLogin{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithKakao(bool isTaxi) async{
    try{
      var provider = OAuthProvider("oidc.kakao.dt");

      bool isInstalled = await kakaoAuth.isKakaoTalkInstalled();

      kakaoAuth.OAuthToken token = isInstalled
          ? await kakaoAuth.UserApi.instance.loginWithKakaoTalk()
          : await kakaoAuth.UserApi.instance.loginWithKakaoAccount();
      print(token.accessToken);
      print(token.idToken);
      final AuthCredential credential = provider.credential(accessToken: token.accessToken, idToken: token.idToken);
      print('12335');
      final UserCredential firebaseCredential = await auth.signInWithCredential(credential);
      print('12334');
      User user = await firebaseCredential.user!;
      print(user);
      if(isTaxi){
        Get.toNamed('/taxiSignUpView');
      } else {
        Get.toNamed('/signUpView');
      }

    } catch(e){
      print(e);
      print('123');
    }


  }

}