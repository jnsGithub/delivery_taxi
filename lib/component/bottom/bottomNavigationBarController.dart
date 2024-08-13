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
        if(pageIndex != 0){
          Get.back();
        }
        // if(isTaxiUser){
        //   Get.back();
        // } else {
        //   Get.toNamed('/userMainView');
        // }
        break;
      case 1:
        print(isTaxiUser);
        if(isTaxiUser){
          Get.toNamed('/taxiNotifyView');
        } else {
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
