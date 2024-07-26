import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';



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
}
