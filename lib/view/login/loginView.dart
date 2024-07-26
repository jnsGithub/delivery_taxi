import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'LoginController.dart';





class LoginView extends GetView<LoginController> {
  const LoginView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => LoginController());
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('images/logo.png'),width: 123,fit: BoxFit.fitWidth),
            const Text('Delivery T',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700),),
            const SizedBox(height: 80,),
            GestureDetector(
              onTap: (){controller.getKakaoLogin();},
                child: const Image(image: AssetImage('images/kakao_login.png'),height: 50,fit: BoxFit.fitHeight)
            ),
            const SizedBox(height: 16),
            GestureDetector(
                onTap: (){controller.getAppleLogin();},
                child: const Image(image: AssetImage('images/apple_login.png'),height: 50,fit: BoxFit.fitHeight))
          ],
        ),
      ),
    );
  }
}
