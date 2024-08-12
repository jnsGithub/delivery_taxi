import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';



class TaxiAccountController extends GetxController {

  TextEditingController accountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bankController = TextEditingController();

  final accountCollection = FirebaseFirestore.instance.collection('account');


  @override
  void onInit() {
    super.onInit();
    init();
  }
  @override
  void onClose(){
    super.onClose();
    nameController.dispose();
    accountController.dispose();
    bankController.dispose();
  }
  init() async {
    await accountCollection.doc(myInfo.documentId).get().then((value) {
      if(value.exists){
        accountController.text = value.data()?['account'] ?? '';
        nameController.text = value.data()?['name'] ?? '';
        bankController.text = value.data()?['bank'] ?? '';
      }
    });
  }
  save() async {
    await accountCollection.doc( myInfo.documentId).set({
      'account' : accountController.text,
      'name' : nameController.text,
      'bank' : bankController.text,
    });

   Get.back();
  }

}
