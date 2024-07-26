
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/callHistory.dart';



class UsingDetailController extends GetxController {

  CallHistory callHistory = Get.arguments;
  RxBool isDone = false.obs;
  @override
  void onInit() {
    super.onInit();
    isDone.value = callHistory.state == '완료';
  }
  @override
  void onClose(){

    super.onClose();
  }
}
