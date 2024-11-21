import 'package:delivery_taxi/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/textfield.dart';
import 'TaxiAccountController.dart';





class TaxiAccountView extends GetView<TaxiAccountController> {
  const TaxiAccountView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TaxiAccountController());
    return Scaffold(
      appBar: AppBar(
        title:const Text('계좌등록 및 정산'),
        centerTitle: true,
        actions: [
          TextButton(onPressed:(){
            controller.save();
          }, child: const Text('저장',style: TextStyle(color: mainColor),))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextFieldComponent(
              text: '예금주', multi: false, color: Colors.black, typeNumber: false, controller: controller.nameController,
            ),
            TextFieldComponent(
              text: '계좌번호', multi: false, color: Colors.black, typeNumber: false, controller: controller.accountController,
            ),
            TextFieldComponent(
              text: '은행', multi: false, color: Colors.black, typeNumber: false, controller: controller.bankController,
            ),
            SizedBox(height: 50,),
            Text('계좌 등록 시\n예금주와 계좌번호는 정확히 입력해주세요.\n잘못입력해서 발생한 손해는 책임지지 않습니다.\n\n* 정산일은 매월21일이며, 자동 정산됩니다.',style: TextStyle(color: Colors.red,fontWeight:FontWeight.w600,fontSize: 17),),
          ],

        ),
      ),
    );
  }
}
