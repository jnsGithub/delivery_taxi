import 'package:delivery_taxi/splash/splashController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SplashController());
    // controller.init();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: controller.padding.toDouble()),
          child: Image(image: AssetImage('images/splash.png',),),
        ),
      ),
    );
  }
}
