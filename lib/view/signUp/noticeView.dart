import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global.dart';
import 'noticeController.dart';





class NoticeView extends GetView<NoticeController> {
  const NoticeView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => NoticeController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: AppBar(
          title: const Text('물품 유의사항'),
          centerTitle: false,
          leadingWidth: 0,
          leading: Container(),
        ),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          children: [
            const LineContainer(),
            Container(
              width: size.width,
              margin: const EdgeInsets.only(bottom: 100),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:const Image(image: AssetImage('images/notice2.png'))
            ),
          ],
        ),
      ),
      bottomSheet: Obx(()=>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical:24),
          color: Colors.white,
          child: GestureDetector(
            onTap: (){
              if( controller.isBottom.value){
                controller.signUp();
              }
            },
            child: Container(
              width: size.width,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: controller.isBottom.value ? mainColor:gray200,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)
              ),
              child:
              Text('확인했습니다',style:  TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color:controller.isBottom.value ? Colors.white:gray500
              ),),
            ),
          ),
        ),
      ),
    );
  }
}
