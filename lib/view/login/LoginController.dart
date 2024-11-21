import 'package:delivery_taxi/data/socialLogin.dart';
import 'package:delivery_taxi/data/testAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../main.dart';



class LoginController extends GetxController {
  RxBool isTestAccountVisible = false.obs;

  bool isTaxi = false;
  SocialLogin socialLogin = SocialLogin();

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments == 'taxi'){
      isTaxi = true;
    }
    getTestAccountVisible();
    print(isTestAccountVisible.value);
  }
  @override
  void onClose(){
    super.onClose();
  }

  getKakaoLogin() async {
    if(isTaxi){
      socialLogin.signInWithKakao(isTaxi);
      // Get.toNamed('/taxiSignUpView');
    } else {
      socialLogin.signInWithKakao(isTaxi);
      // Get.toNamed('/signUpView');
    }
  }
  getAppleLogin() async {
    if(isTaxi){
      socialLogin.signInWithApple(isTaxi);
      // Get.toNamed('/taxiSignUpView');
    } else {
      socialLogin.signInWithApple(isTaxi);
      // Get.toNamed('/signUpView');
    }
    // Get.toNamed('/signUpView');
  }

  getTestAccountVisible() async {
    isTestAccountVisible.value = await TestAccount().isTestAccountVisible();
  }
}
