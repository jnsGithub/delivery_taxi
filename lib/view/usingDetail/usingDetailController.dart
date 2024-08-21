
import 'package:delivery_taxi/data/payments.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
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
      title: const Text('택시 이용 취소'),
      content: const Text('택시 이용을 취소하시겠습니까?'),
      actions: [
        CupertinoDialogAction(
          child: const Text('취소',style: TextStyle(color: mainColor),),
          onPressed: () {
            Get.back();
          },
        ),
        CupertinoDialogAction(
          child: const Text('확인',style: TextStyle(color: mainColor)),
          onPressed: () async {
            await cancel(callHistory);
            callHistory.state = '호출 취소';
            Get.back();
          },
        ),
      ],
    );
  }
}
