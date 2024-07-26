import 'package:delivery_taxi/view/signUp/taxiImageUploadController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class TaxiImageUploadView extends GetView<TaxiImageUploadController> {
  const TaxiImageUploadView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TaxiImageUploadController());
    return Scaffold(
      appBar: AppBar(
        title: Text('택시 기사 회원가입'),
        centerTitle: true,
      ),
    );
  }
}
