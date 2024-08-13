import 'package:delivery_taxi/component/main_box.dart';
import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/view/taxiMain/taxiAreaController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class TaxiAreaView extends GetView<TaxiAreaController> {
  const TaxiAreaView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TaxiAreaController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('영업지역 선택',style: TextStyle(
          fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black
        ),),
        centerTitle: true,
      ),
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('영업지역(시,군)', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),),
                  const SizedBox(
                    height: 9,
                  ),
                  GestureDetector(
                    onTap: (){
                      controller.getCityInfo(true);
                    },
                    child: Container(
                      width: size.width,
                      height:  50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xfff6f6fa)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(()=> Text(controller.city.value)),
                            const Icon(Icons.arrow_drop_down)
                          ]
                      ),
                    ),
                  ),
                  Obx(
                        ()=> controller.city.value == '선택해주세요'?Container():
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        const Text('영업지역(구)', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),),
                        const SizedBox(
                          height: 9,
                        ),
                        GestureDetector(
                          onTap: (){
                            controller.getCityInfo(false);
                          },
                          child: Container(
                            width: size.width,
                            height:  50,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xfff6f6fa)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(()=> Text(controller.district.value)),
                                  const Icon(Icons.arrow_drop_down)
                                ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  controller.setArea();
                },
                  child: MainBox(text: '저장하기', color: mainColor)
              )
            ],
          ),
        )
    );
  }
}
