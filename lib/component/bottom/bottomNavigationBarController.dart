import 'package:delivery_taxi/view/useNotify/taxiNotifyController.dart';
import 'package:delivery_taxi/view/useNotify/useNotifyController.dart';
import 'package:delivery_taxi/view/userMain/userMainController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../main.dart';



class BottomNavigationBarController extends GetxController {
  // 현재 선택된 탭 아이템 번호 저장
  final RxInt selectedIndex = 0.obs;

  // 탭 이벤트가 발생할 시 selectedIndex값을 변경해줄 함수
  void changeIndex(int index,pageIndex) {
    selectedIndex(index);
    switch(index){
      case 0:
        if(isTaxiUser){
          Get.toNamed('/taxiMainView');
        } else {
          Get.delete<UserMainController>(force: true);
          Get.toNamed('/userMainView');
        }
        break;
      case 1:
        if(isTaxiUser){
          Get.delete<TaxiNotifyController>(force: true);
          Get.toNamed('/taxiNotifyView');
        } else {
          Get.delete<UseNotifyController>(force: true);
          Get.toNamed('/useNotifyView');
        }
        break;
      case 2:
        if(pageIndex != 0){
          Get.back();
        }
        Get.toNamed('/myPageView');
        break;
    }

  }
}
