
import 'package:cloud_firestore/cloud_firestore.dart';
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
    Payments payments = Payments();
    payments.cancelPayments(callHistory);
  }

  Widget checkDialog(BuildContext context){
    return CupertinoAlertDialog(

      content: Text('결제 취소시 1,000원의\n취소 수수료가 발생합니다\n취소하시겠습니까?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),

      actions: [
        CupertinoDialogAction(
          child: const Text('확인',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          onPressed: () async {
            Get.back();
            saving(context);
            Payments payments = Payments();
            await payments.rePayment(callHistory, cancel: 1000);
            await FirebaseFirestore.instance.collection('callHistory').doc(callHistory.documentId).update({
              'price': 1000,
              'state': '호출취소'
            });
            callHistory.state = '호출 취소';
            callHistory.price = 1000;
            Get.back();
            Get.back(result: true);
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
