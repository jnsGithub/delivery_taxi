import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/main.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{

  int padding = 40;
  @override
  void onInit() {
    print('시작');
    super.onInit();
    init();
  }
  @override
  void onClose() {
    print('닫기');
    super.onClose();
  }

  @override
  void onReady() {
    print('준비');
    super.onReady();
  }


  init() async {
    print('zz');
    await Future.delayed(Duration(seconds: 2), (){
      print('22');
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