import 'package:delivery_taxi/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'LoginController.dart';





class LoginView extends GetView<LoginController> {
  const LoginView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => LoginController());
    bool isiOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      body: Obx(() => SizedBox(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('images/logo.png'),width: 123,fit: BoxFit.fitWidth),
              const Text('Delivery T',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700),),
              SizedBox(height: isiOS ? 80 : 120,),
              GestureDetector(
                onTap: (){
                  controller.getKakaoLogin();
                  },
                  child: const Image(image: AssetImage('images/kakao_login.png'),height: 50,fit: BoxFit.fitHeight)
              ),
              const SizedBox(height: 16),
              isiOS ? GestureDetector(
                  onTap: (){
                    controller.getAppleLogin();
                    },
                  child: const Image(image: AssetImage('images/apple_login.png'),height: 50,fit: BoxFit.fitHeight)) : SizedBox(),
              const SizedBox(height: 16),
              controller.isTestAccountVisible.value ? GestureDetector(
                  onTap: (){
                      Get.toNamed('/nomalLoginView');
                    },
                  child: Container(
                    height: 50,
                    width: size.width * 0.91,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Center(child: Text('일반 로그인',style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold),)),
                  )) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
