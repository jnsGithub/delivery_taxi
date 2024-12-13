import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/main.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{

  int padding = 40;
  @override
  void onInit() {
    super.onInit();
    init();
  }
  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }


  init() async {
    await Future.delayed(Duration(seconds: 2), (){
      if(isLogin){
        if(myInfo.type == 'taxi'){
          Get.offAllNamed('/taxiMainView');
        } else {
          Get.offAllNamed('/userMainView');
        }
      } else {
        Get.offAllNamed('/enterView');
      }
    });
  }
}