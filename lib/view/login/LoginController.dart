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
    if(Get.arguments == 'taxi' || Get.arguments == 'userTaxi'){
      isTaxi = true;
    }
    getTestAccountVisible();
  }
  @override
  void onClose(){
    super.onClose();
  }

  getKakaoLogin() async {
    socialLogin.signInWithKakao(isTaxi,Get.arguments);
  }
  getAppleLogin() async {
    socialLogin.signInWithApple(isTaxi,Get.arguments);
  }

  getTestAccountVisible() async {
    isTestAccountVisible.value = await TestAccount().isTestAccountVisible();
  }
}
