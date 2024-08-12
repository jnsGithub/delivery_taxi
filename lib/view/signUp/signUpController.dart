import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/myInfoData.dart';
import '../../global.dart';
import '../../model/myInfo.dart';



class SignUpController extends GetxController {
  RxBool check1 = false.obs;
  RxBool check2 = false.obs;
  RxBool check3 = false.obs;
  RxBool check4 = false.obs;
  RxBool check5 = false.obs;
  RxBool allCheckBool = false.obs;



  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose(){

    super.onClose();
  }

  allCheck(){
    allCheckBool.value = !allCheckBool.value;
    if(allCheckBool.value){
      check1.value = true;
      check2.value = true;
      check3.value = true;
      check4.value = true;
      check5.value = true;
    } else {
      check1.value = false;
      check2.value = false;
      check3.value = false;
      check4.value = false;
      check5.value = false;
    }
  }
  check(index){
    if(index == 1){
      check1.value = !check1.value;
    } else if(index == 2){
      check2.value = !check2.value;
    } else if(index == 3){
      check3.value = !check3.value;
    } else if(index == 4){
      check4.value = !check4.value;
    } else if(index == 5){
      check5.value = !check5.value;
    }
    if(check1.value && check2.value && check3.value && check4.value && check5.value){
      allCheckBool.value = true;
    } else {
      allCheckBool.value = false;
    }
  }

}
