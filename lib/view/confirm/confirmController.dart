import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/data/callHistroyData.dart';
import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/model/callHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;


class ConfirmController extends GetxController {
  RxString storeAddress = ''.obs;
  RxDouble startLatitude = 0.0.obs;
  RxDouble startLongitude =  0.0.obs;
  RxDouble endLatitude =  0.0.obs;
  RxDouble endLongitude =  0.0.obs;
  RxInt duration = 0.obs;
  RxInt taxiFare = 0.obs;
  RxString formatted = ''.obs;
  late CallHistory callHistory;
  late NaverMapController mapController;
  final CallHistoryData  callHistoryData = CallHistoryData();
  @override
  void onInit() {
    super.onInit();
    callHistory = Get.arguments;
  }
  @override
  void onClose(){
    super.onClose();
  }
  onMapCreated(NaverMapController controller)async {
    try{
      await getLoad();
      mapController = controller;
      List<NLatLng> coords = [
        // NLatLng(37.5666102, 126.9783881),
        NLatLng(startLatitude.value, startLongitude.value),
        NLatLng(endLatitude.value, endLongitude.value),
      ];
      mapController.addOverlay(NPathOverlay(id: "test", coords: coords,color: mainColor,outlineWidth:0));
      mapController.updateCamera(NCameraUpdate.withParams(
        zoom: 12,
        target: NLatLng(startLatitude.value, startLongitude.value),
      ));

      update();
    }catch(e){
      print(e);
    }

  }
  /* 카카오  인증 아디이 바꾸어햐마*/
  getLoad() async {
    String url = 'https://dapi.kakao.com/v2/local/search/address.JSON?query=${callHistory.startingAddress}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'KakaoAK b3cb1c7aa1e076c60ec8156e4995d055'
      },
    );
    if(response.statusCode == 200){
      var data = response.body;
      var dataJson = jsonDecode(data) ;
      startLongitude.value =  double.parse( dataJson['documents'][0]['road_address']['x']);
      startLatitude.value = double.parse( dataJson['documents'][0]['road_address']['y']);

    }


    url = 'https://dapi.kakao.com/v2/local/search/address.JSON?query=${callHistory.endingAddress}';
    http.Response response2 = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'KakaoAK b3cb1c7aa1e076c60ec8156e4995d055'
      },
    );
    if(response2.statusCode == 200){
      var data = response2.body;
      var dataJson = jsonDecode(data) ;
      endLongitude.value =   double.parse(dataJson['documents'][0]['road_address']['x']);
      endLatitude.value =  double.parse(dataJson['documents'][0]['road_address']['y']);

    }
    url = 'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${startLongitude.value},${startLatitude.value}&goal=${endLongitude.value},${endLatitude.value}';
    http.Response response3 = await http.get(
      Uri.parse(url),
      headers: {
        'X-NCP-APIGW-API-KEY-ID':'3ds1y6zz0h',
        'X-NCP-APIGW-API-KEY':'lxxIwb4akSVDnWDBQsilsoRBpLfxb2WMKRgdUJ6g'
      },
    );
    if(response3.statusCode == 200){
      var data = response3.body;
      var dataJson = jsonDecode(data) ;
      taxiFare.value = (dataJson['route']['traoptimal'][0]['summary']['taxiFare']*1.3).toInt();

      int milliseconds = dataJson['route']['traoptimal'][0]['summary']['duration']; // 예를 들어 123456789 밀리초

      Duration duration = Duration(milliseconds: milliseconds);
      int hours = duration.inHours;
      int minutes = duration.inMinutes % 60;
      formatted.value = '예상시간 ${hours == 0?'':"${hours.toString().padLeft(2, '0')}시간"} ${minutes.toString().padLeft(2, '0')}분';
    }
  }
  naverPay() async {
    callHistory.state = '호출중';
    callHistory.price = taxiFare.value;
    callHistory.createDate = Timestamp.now();
    bool check = await callHistoryData.addItem(callHistory);
    if(check){
      Get.snackbar('알림', '호출이 완료되었습니다.');
      Get.toNamed('/useNotifyView');
      onClose();
    } else {
      Get.snackbar('알림', '호출이 실패되었습니다.');
    }

  }
  kakaoPay() async {
    callHistory.state = '호출중';
    callHistory.price = taxiFare.value;
    callHistory.createDate = Timestamp.now();
    bool check = await callHistoryData.addItem(callHistory);
    if(check){
      Get.snackbar('알림', '호출이 완료되었습니다.');
      Get.toNamed('/useNotifyView');
      onClose();
    } else {
      Get.snackbar('알림', '호출이 실패되었습니다.');
    }
  }
}
