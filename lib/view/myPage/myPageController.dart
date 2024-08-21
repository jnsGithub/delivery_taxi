import 'package:delivery_taxi/data/socialLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../global.dart';



class MyPageController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose(){

    super.onClose();
  }

  Widget checkDeleteAccount(){
    return CupertinoAlertDialog(
      title: const Text('정말로 회원탈퇴를 하시겠습니까?'),
      content: const Text('회원탈퇴시 즉시 회원정보가 삭제되며 복구가 불가능합니다.'),
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
            SocialLogin().deleteAccount();
          },
        ),
      ],
    );
  }
}
