import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/data/usage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/notifyData.dart';
import '../../model/callHistory.dart';
import '../../model/notify.dart';
import '../../model/usage.dart';



class UseNotifyController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController ;
  RxInt tabIndex = 0.obs;
  RxList<CallHistory> callHistory = <CallHistory>[].obs;
  RxList<Notify> notify = <Notify>[].obs;
  RxList item = [].obs;
  GetUsage getUsage = GetUsage();
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
  init() async{
    callHistory.value = await getUsage.getCallHistory();
    notify.value = await NotifyData().getNotify();
    // notify.add(Notify(
    //   documentId: '',
    //   title: '퀵 배송 택시 호출중',
    //   content: '결제가 완료되어, 주변 택시를 호출중입니다',
    //   pay: 0,
    //   createDate: Timestamp.now(),
    // ));
    // notify.add(Notify(
    //   documentId: '',
    //   title: '배차 완료',
    //   content: '택시 배차가 완료되었습니다\n택시번호 : 10가 1234\n전화번호 : 010-xxxx-xxxx',
    //   pay: 0,
    //   createDate: Timestamp.now(),
    // ));
    // notify.add(Notify(
    //   documentId: '',
    //   title: '이용 완료',
    //   content: '물품 배달이 완료되었습니다',
    //   pay: 8800,
    //   createDate: Timestamp.now(),
    // ));
  }
}
