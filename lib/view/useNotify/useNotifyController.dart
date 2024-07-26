import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/callHistory.dart';
import '../../model/notify.dart';
import '../../model/usage.dart';



class UseNotifyController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController ;
  RxInt tabIndex = 0.obs;
  RxList<CallHistory> callHistory = <CallHistory>[].obs;
  RxList<Notify> notify = <Notify>[].obs;
  RxList item = [].obs;
  @override
  void onInit() {
    super.onInit();
    init();
    tabController = TabController(
      length: 2,
      vsync: this,
      /// 탭 변경 애니메이션 시간
    );
  }
  @override
  void onClose(){
    super.onClose();
  }
  changeTab(i) {
    tabIndex.value = i;
    if (i == 0) {
      update();
    } else {
      update();
    }
  }
  init() {
    notify.add(Notify(
      documentId: '',
      title: '퀵 배송 택시 호출중',
      content: '결제가 완료되어, 주변 택시를 호출중입니다',
      pay: 0,
      createDate: Timestamp.now(),
    ));
    notify.add(Notify(
      documentId: '',
      title: '배차 완료',
      content: '택시 배차가 완료되었습니다\n택시번호 : 10가 1234\n전화번호 : 010-xxxx-xxxx',
      pay: 0,
      createDate: Timestamp.now(),
    ));
    notify.add(Notify(
      documentId: '',
      title: '이용 완료',
      content: '물품 배달이 완료되었습니다',
      pay: 8800,
      createDate: Timestamp.now(),
    ));
    callHistory.add(CallHistory(
      startingPostcode: '06112',
      startingAddress: '서울 강남구 논현로123길 4-1',
      startingAddressDetail:'101호',
      startingName: '김깡똥',
      startingHp:'01096005193',
      endingPostcode: '07705',
      endingAddress:'서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp:'01012345678',
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
      startingAddressDetail:'101호',
      startingName: '김깡똥',
      startingHp:'01096005193',
      endingPostcode: '07705',
      endingAddress:'서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp:'01012345678',
      selectedOption: 'large',
      caution: '깨짐 주의',
      price: 30000,
      userDocumentId: '',
      paymentType: '카카오페이',
      state: '배정완료',
      createDate: Timestamp.now(),
    ));
    callHistory.add(CallHistory(
      startingPostcode: '06112',
      startingAddress: '서울 강남구 논현로123길 4-1',
      startingAddressDetail:'101호',
      startingName: '김깡똥',
      startingHp:'01096005193',
      endingPostcode: '07705',
      endingAddress:'서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp:'01012345678',
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
      startingAddressDetail:'101호',
      startingName: '김깡똥',
      startingHp:'01096005193',
      endingPostcode: '07705',
      endingAddress:'서울 강서구 강서로45다길 12-12',
      endingAddressDetail: '102호',
      endingName: '이야오',
      endingHp:'01012345678',
      selectedOption: 'large',
      caution: '깨짐 주의',
      price: 5000,
      userDocumentId: '',
      paymentType: '카카오페이',
      state: '배송완료',
      createDate: Timestamp.now(),
    ));
  }
}
