import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../main.dart';



class LoginController extends GetxController {

  bool isTaxi = false;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments == 'taxi'){
      isTaxi = true;
    }
  }
  @override
  void onClose(){
    super.onClose();
  }

  getKakaoLogin() async {
    if(isTaxi){
      isTaxiUser= true;
      Get.toNamed('/taxiSignUpView');
    } else {
      Get.toNamed('/signUpView');
    }

  }
  getAppleLogin() async {
    Get.toNamed('/signUpView');
  }
}
