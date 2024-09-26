import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:delivery_taxi/data/callHistroyData.dart';
import 'package:delivery_taxi/data/payments.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/callHistory.dart';



class TaxiMainController extends GetxController {

  RxBool isDone = true.obs;
  RxBool newCall = false.obs;
  RxBool delivery = false.obs;
  RxBool nowPay = false.obs;

  RxString inquiryType = ''.obs;
  List<String> inquiryTypeList = ['일반유저', '택시유저'];

  RxList<CallHistory> callHistory = <CallHistory>[].obs;
  CallHistoryData callHistoryData = CallHistoryData();
  TextEditingController price = TextEditingController();
  CallHistory lastCallItem = CallHistory(startingPostcode: '', startingAddress: '', startingAddressDetail: '',startingName: '', startingHp: '', endingPostcode: '', endingAddress: '', endingAddressDetail: '', endingName: '', endingHp: '', selectedOption: '', caution: '',billingKey: '', price: 0, userDocumentId: '', paymentType: '', state: '', createDate: Timestamp.now(), documentId: '', taxiDocumentId: '',);
  late CallHistory callItem;
  Payments payments = Payments();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
  changeItem(item){
    try{
      if(lastCallItem.documentId == item.documentId){
        newCall.value = false;
      } else {
        newCall.value = true;
        lastCallItem = item;
      }
    } catch(e){
      print(e);
    }
  }
  getList() async {
    callHistory.value = await callHistoryData.getTaxiItem();
    Get.toNamed('/taxiCallList');
  }

  Future requestPayments() async{
    List<String> parts = price.text.split(',');
    String result = parts.join('');
    print('로그1');
    print(price.text);
    print(parts);
    print(result);
    print((int.parse(result) * 1.3).toInt());
    await payments.rePayment(callItem);
  }

  Stream<Map<String, dynamic>> getLatestDocumentStream() {
    return FirebaseFirestore.instance
        .collection('callHistory')
        .orderBy('createDate', descending: true) // timestamp 필드로 정렬
        .limit(1) // 최신 문서 하나만 가져옴
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data();
        data['documentId'] = snapshot.docs.first.id;
        return data;
      } else {
        return {}; // 문서가 없을 때 빈 맵 반환
      }
    });
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
              Text(pay ? '최종 ${formatNumber(int.parse(result))}을\n결제요청 하시겠습니까?':isDoneDelivery ?'화물 전달 후 배송을\n완료하시겠습니까?':'화물 수령후 배송을\n시작하시겠습니까?', style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600, color: font3030
              ),),
              const SizedBox(height: 10),
              isDoneDelivery?Container():const Text(
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
                          nowPay.value = false;
                          callItem.price = (int.parse(result) * 1.3).toInt();
                          requestPayments();
                          price.text = '';
                          callHistoryData.updateItem(callItem,false);
                          Get.back();
                        } else {
                          /// 여가서 callitme db 업데이트 해주세융
                          if(isDoneDelivery){
                            callItem.state = '배송완료';
                            callHistoryData.updateItem(callItem,false);
                            nowPay.value = true;
                            Get.back();
                          } else {
                            callItem.state = '배송중';
                            callHistoryData.updateItem(callItem,false);
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
                            callItem.state ='배정완료';
                            callHistoryData.updateItem(callItem,true);
                            lastCallItem = callItem;
                            Get.back();
                            if(isList){
                              Get.back();
                            }
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
