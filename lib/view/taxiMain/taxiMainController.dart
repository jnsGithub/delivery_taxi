import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/callHistory.dart';



class TaxiMainController extends GetxController {

  RxBool isDone = false.obs;
  RxBool newCall = false.obs;
  RxBool delivery = false.obs;

  RxList<CallHistory> callHistory = <CallHistory>[].obs;

  TextEditingController price = TextEditingController();

  late CallHistory callItem;
  @override
  void onInit() {
    super.onInit();
    callHistory.add(CallHistory(
      startingPostcode: '06112',
      startingAddress: '서울 강남구 논현로123길 4-1',
      startingAddressDetail: '101호',
      startingName: '김깡똥',
      startingHp: '01096005193',
      endingPostcode: '07705',
      endingAddress: '서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp: '01012345678',
      selectedOption: 'large',
      caution: '깨짐 주의',
      price: 10000,
      userDocumentId: '',
      paymentType: '네이버페이',
      state: '호출중',
      createDate: Timestamp.now(),
    ));

    callHistory.add(CallHistory(
      startingPostcode: '06112',
      startingAddress: '서울 강남구 논현로123길 4-1',
      startingAddressDetail: '101호',
      startingName: '김깡똥',
      startingHp: '01096005193',
      endingPostcode: '07705',
      endingAddress: '서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp: '01012345678',
      selectedOption: 'large',
      caution: '깨짐 주의',
      userDocumentId: '',
      paymentType: '카카오페이',
      price: 345000,
      state: '배송중',
      createDate: Timestamp.now(),
    ));
    callHistory.add(CallHistory(
      startingPostcode: '06112',
      startingAddress: '서울 강남구 논현로123길 4-1',
      startingAddressDetail: '101호',
      startingName: '김깡똥',
      startingHp: '01096005193',
      endingPostcode: '07705',
      endingAddress: '서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp: '01012345678',
      selectedOption: 'large',
      caution: '깨짐 주의',
      price: 5000,
      userDocumentId: '',
      paymentType: '카카오페이',
      state: '배송완료',
      createDate: Timestamp.now(),
    ));
    callHistory.add(CallHistory(
      startingPostcode: '06112',
      startingAddress: '서울 강남구 논현로123길 4-1',
      startingAddressDetail: '101호',
      startingName: '김깡똥',
      startingHp: '01096005193',
      endingPostcode: '07705',
      endingAddress: '서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp: '01012345678',
      selectedOption: 'large',
      caution: '깨짐 주의',
      price: 30000,
      userDocumentId: '',
      paymentType: '카카오페이',
      state: '배정완료',
      createDate: Timestamp.now(),
    ));
  }

  @override
  void onClose() {
    super.onClose();
  }
  changeState(size,pay) {
    bool isDoneDelivery = callItem.state == '배송중'? true : false;
    List<String> parts = price.text.split(',');
    String result = parts.join('');
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.only(top: 30, bottom: 30),
          content:  Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(pay ? '최종 ${formatNumber(int.parse(result))}을\n결제요청 하시겠습니까?':isDoneDelivery ?'화물 전달 후 배송을\n완료하시겠습니까?':'화물 수령후 배송을\n시작하시겠습니까?', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600, color: font3030
              ),),
              SizedBox(height: 10),
              isDoneDelivery?Container():Text(
                '(배송 시작 이후 미터기를 켜주세요.)', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600, color: mainColor
              ),),
            ],
          ),
          actions: [
            Container(
              width: size.width,
              height: 48.1,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffe0e0e0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 48.1,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Color(0xffe0e0e0),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff303030),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if(pay){
                          isDone.value = false;
                          newCall.value = false;
                          delivery.value = false;
                          Get.back();
                        } else {
                          /// 여가서 callitme db 업데이트 해주세융
                          if(isDoneDelivery){
                            callItem.state = '배송완료';
                            Get.back();
                          } else {
                            callItem.state = '배송중';
                            update();
                            Get.back();
                          }
                        }
                      },
                      child: Container(
                        height: 48.1,
                        alignment: Alignment.center,
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
  cancelCall(size) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.only(top: 30, bottom: 30),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('해당 콜을 거절하시겠습니까?', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600, color: font3030
              ),),
              SizedBox(height: 10),
              Text(
                '거절 시, 해당 콜 배정이 안됩니다', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600, color: mainColor
              ),),
            ],
          ),
          actions: [
            Container(
              width: size.width,
              height: 48.1,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffe0e0e0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 48.1,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Color(0xffe0e0e0),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff303030),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        newCall.value = false;
                        Get.back();
                      },
                      child: Container(
                        height: 48.1,
                        alignment: Alignment.center,
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
  call(size, CallHistory item,isList) {
    String typeEng = item.selectedOption;
    String type =typeEng =='small'? '소형': typeEng == 'medium'? '중형':'대형';
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              content:SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('출발지 정보',style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 18,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('출발지 주소',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                        Expanded(
                          child: Text('${item.startingAddress} ${item.startingAddressDetail}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('이름',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                        Expanded(
                          child: Text(item.startingName,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('전화번호',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                        Expanded(
                          child: Text(item.startingHp,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                    const LineContainer(),
                    const Text('도착지 정보',style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 18,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('출발지 주소',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                        Expanded(
                          child: Text('${item.endingAddress} ${item.endingAddressDetail}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('이름',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                        Expanded(
                          child: Text(item.endingName,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 114,
                          child: Text('전화번호',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                        Expanded(
                          child: Text(item.endingHp,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                    const LineContainer(),
                    const Text('화물 정보',style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 18,),
                    Text(type,style: const TextStyle(fontSize:18,fontWeight: FontWeight.w500),),
                    const LineContainer(),
                    const Text('배송 유의 사항',style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 18,),
                    SizedBox(
                      width: size.width,
                        child: Text(
                          item.caution
                          , style: const TextStyle(fontSize:17,fontWeight: FontWeight.w500,color: gray600),)
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            width: size.width*0.3803,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: gray100
                            ),
                            child: const Text('닫기',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: gray600),),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){

                            callItem = item;
                            delivery.value = true;
                            Get.back();
                            if(isList){
                              Get.back();
                            }
                            callItem.state ='배정완료';
                            update();
                          },
                          child: Container(
                            width: size.width*0.3803,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: mainColor
                            ),
                            child: const Text('콜 잡기',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}
