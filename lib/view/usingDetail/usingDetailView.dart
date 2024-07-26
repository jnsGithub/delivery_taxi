import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:delivery_taxi/main.dart';
import 'package:delivery_taxi/view/usingDetail/usingDetailController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/main_box.dart';
import '../../global.dart';





class UsingDetailView extends GetView<UsingDetailController> {
  const UsingDetailView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => UsingDetailController());
    return Scaffold(
      backgroundColor: gray100,
      appBar: AppBar(
        backgroundColor: gray100,
        iconTheme: const IconThemeData(color: gray400),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('퀵 택시 이용 상세',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                      Text(formatTimestamp(controller.callHistory.createDate),style: const TextStyle(fontSize: 16,color: gray500),),
                    ],
                  )
              ),
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('주문 정보',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                    const SizedBox(height: 17,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('주문상태',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text(controller.callHistory.state,style: TextStyle(color: controller.isDone.value? gray500:mainColor),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('출발지 주소',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text('${controller.callHistory.startingAddress} ${controller.callHistory.startingAddressDetail}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('배송자 이름',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text(controller.callHistory.startingName),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('배송자 전화번호',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text(controller.callHistory.startingHp),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('인수자 이름',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text(controller.callHistory.endingName),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('인수자 전화번호',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text(controller.callHistory.endingHp),
                        ),
                      ],
                    ),
                    LineContainer(),
                    const Text('요금 정보',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                    const SizedBox(height: 17,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('배송요금',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text(formatNumber(controller.callHistory.price) ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('결제 수단',style: TextStyle(color: gray500),),
                        ),
                        Expanded(
                          child: Text(controller.callHistory.paymentType),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              isTaxiUser ? Container():GestureDetector(
                onTap: (){},
                child:MainBox(text: '결제 취소',color:controller.callHistory.state == '호출중'?  mainColor :gray200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
