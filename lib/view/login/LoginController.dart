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
  }
  @override
  void onClose(){
    super.onClose();
  }

  getKakaoLogin() async {
    if(isTaxi){
      socialLogin.signInWithKakao(isTaxi);
    } else {
      socialLogin.signInWithKakao(isTaxi);
    }
  }
  getAppleLogin() async {
    if(isTaxi){
      socialLogin.signInWithApple(isTaxi);
    } else {
      socialLogin.signInWithApple(isTaxi);
    }
  }

  getTestAccountVisible() async {
    isTestAccountVisible.value = await TestAccount().isTestAccountVisible();
  }
}
