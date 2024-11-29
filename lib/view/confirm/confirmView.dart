

import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:delivery_taxi/component/main_box.dart';
import 'package:delivery_taxi/view/confirm/confirmController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

import '../../global.dart';


class ConfirmView extends GetView<ConfirmController> {
  const ConfirmView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => ConfirmController());
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: GetBuilder<ConfirmController>(
            init: ConfirmController(), // 여기서 컨트롤러를 초기화
            // dispose: (_) => ConfirmController().dispose(),
            builder: (getController) {
              return Column(
                // alignment: Alignment.bottomCenter,
                children: [
                  Expanded(
                    child: NaverMap(
                      options: const NaverMapViewOptions(
                        minZoom:0,
                      ),
                      onMapReady: (controller) {
                        getController.onMapCreated(controller);
                      },
                    ),
                  ),
                  Container(
                    height: 323,
                    padding: const EdgeInsets.only(left:  16,right: 16,top: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(20),
                      //   topRight: Radius.circular(20),
                      // ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.formatted.value,style: const TextStyle(
                                  fontSize: 18,fontWeight: FontWeight.w500
                              ),),
                              Text('예상요금 ${formatNumber(controller.taxiFare.value)}',style: const TextStyle(
                                  fontSize: 18,fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                          const LineContainer(),
                          const Text('이용안내',style: TextStyle(
                              fontSize: 14,fontWeight: FontWeight.w500,color: font4343
                          ),),
                          const SizedBox(height: 10,),
                          const Text(' • 배송거리에 따라 배송요금이 부과됩니다\n • 실시간 주문량에 따라 할인 또는 할증요금이 적용될 수 있습니다\n • 호출 이후부터는 취소수수료가 1,000원이 부과됩니다\n • 기사님 배정 이후로는 취소가 불가능합니다\n • 도로 및 교통상황에 따라 안내되는 배송시간 및 배송요금과 다르게 배송될 수 있습니다',
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: gray600
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              controller.callTaxi();
                            },
                              child: MainBox(text: '호출하기', color: mainColor)
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
