import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/data/callHistroyData.dart';
import 'package:delivery_taxi/data/getUsage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/callHistory.dart';
import '../../model/notify.dart';
import '../../model/usage.dart';



class TaxiNotifyController extends GetxController {


  RxList<CallHistory> callHistory = <CallHistory>[].obs;
  RxList item = [].obs;
  CallHistoryData getUsage = CallHistoryData();
  @override
  void onInit() {
    super.onInit();
    init();
  }
  @override
  void onClose(){
    super.onClose();
  }

  init() async{
    callHistory.value = await getUsage.getTaxiNotify();
  }
}
