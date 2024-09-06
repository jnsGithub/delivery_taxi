
import 'package:delivery_taxi/data/payments.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/callHistory.dart';



class UsingDetailController extends GetxController {

  CallHistory callHistory = Get.arguments;
  RxBool isDone = false.obs;
  @override
  void onInit() {
    super.onInit();
    isDone.value = callHistory.state == '완료';
  }
  @override
  void onClose(){

    super.onClose();
  }

  Future cancel(CallHistory callHistory) async {
    //TODO - 결제 취소 로직
    Payments payments = Payments();
    payments.cancelPayments(callHistory);
  }

  Widget checkDialog(){
    return CupertinoAlertDialog(
      // title: const Text('택시 이용 취소'),

      content: Text('결제 취소시 1,000원의\n취소 수수료가 발생합니다\n취소하시겠습니까?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),

      actions: [
        CupertinoDialogAction(
          child: const Text('확인',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          onPressed: () async {
            await cancel(callHistory);
            callHistory.state = '호출 취소';
            callHistory.price = 1000;
            Get.back();
          },
        ),
        CupertinoDialogAction(
          child: const Text('취소',style: TextStyle(color: Colors.black)),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
