import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/myInfoData.dart';
import '../../global.dart';
import '../../model/myInfo.dart';



class NoticeController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxBool isBottom = false.obs;
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      scrollListener();
    });
  }
  @override
  void onClose(){
    scrollController.dispose();
    super.onClose();
  }
  scrollListener()async{
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
      isBottom.value = true;
    }
  }
  signUp() async {
    MyInfomation myInfomation = MyInfomation();
    MyInfo my = MyInfo(
        documentId: uid,
        type: 'customer',
        name: '',
        hp: '',
        address1: '',
        address2: '',
        taxiNumber: '',
        taxiType: '',
        taxiImage: '',
        isAuth: false,
        createDate: Timestamp.now(), fcmToken: ''
    );
    myInfomation.setUser(my);
    myInfo = my;
    Get.toNamed('/userMainView');
    update();
  }
}
