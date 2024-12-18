import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:http/http.dart' as http;
import '../../model/callHistory.dart';



class UserMainController extends GetxController {
  FocusNode startAddressDetail = FocusNode();
  FocusNode endAddressDetail = FocusNode();
  RxString startingPostcode = '우편번호를 검색하세요'.obs;
  RxString startingAddress = ''.obs;
  TextEditingController startingAddressDetailController = TextEditingController();
  TextEditingController startingName = TextEditingController();
  TextEditingController startingHp = TextEditingController();

  RxString endingPostcode = '우편번호를 검색하세요'.obs;
  RxString endingAddress = ''.obs;
  TextEditingController endingAddressDetailController = TextEditingController();
  TextEditingController endingName = TextEditingController();
  TextEditingController endingHp = TextEditingController();

  RxString selectedOption = 'small'.obs;
  TextEditingController caution = TextEditingController();

  RxString inquiryType = '일반유저'.obs;
  List<String> inquiryTypeList = ['일반유저', '택시유저'];

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }
  @override
  void onClose(){

    super.onClose();
  }
  getCurrentUser() async {
    try{
      var position = await determinePosition();
      if(position.runtimeType == bool ){
        return;
      }
      int dotIndex = position.longitude.toString().indexOf(".");
      String long =  dotIndex != -1 && dotIndex + 8 <= position.longitude.toString().length
          ? position.longitude.toString().substring(0, dotIndex + 8)
          : position.longitude.toString();
      dotIndex = position.latitude.toString().indexOf(".");
      String lat = dotIndex != -1 && dotIndex + 8 <= position.latitude.toString().length
          ? position.latitude.toString().substring(0, dotIndex + 8)
          : position.latitude.toString();
      String url = 'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$long&y=$lat&input_coord=WGS84';
      http.Response response4 = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'KakaoAK 781a3219cc87986ab5533ccebcd62aba'
        },
      );

      if(response4.statusCode == 200){
        var data = response4.body;
        var dataJson = jsonDecode(data) ;
        var documents = dataJson['documents'][0];
        if(documents['road_address'] != null){
          startingPostcode.value = documents['road_address']['zone_no'];
          startingAddress.value = documents['road_address']['address_name'];
          startingAddressDetailController.text = documents['road_address']['building_name'];
        } else {
          startingPostcode.value = '현재위치검색';
          startingAddress.value = documents['address']['address_name'];
        }
      }
    }catch(e){
      print(e);
    }
  }
  Future kopoModel (context,starting) async {
    KopoModel? model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    if(model != null){
      if(starting){
        startingAddress.value = model.address!;
        startingPostcode.value = model.zonecode!;
        FocusScope.of(Get.context!).requestFocus(startAddressDetail);
      } else {
        endingPostcode.value = model.zonecode!;
        endingAddress.value = model.address!;
        FocusScope.of(Get.context!).requestFocus(endAddressDetail);
      }
    }
  }
  callTaxi(){
    if(startingPostcode.value == '우편번호를 검색하세요' || endingPostcode.value == '우편번호를 검색하세요'){
      Get.snackbar('알림', '출발지 또는 도착지를 입력해주세요');
      return;
    }
    if(startingName.text ==''){
      Get.snackbar('알림', '출발지 이름을 입력해주세요');
      return;
    }
    if(endingName.text ==''){
      Get.snackbar('알림', '도착지 이름을 입력해주세요');
      return;
    }
    if(startingHp.text ==''){
      Get.snackbar('알림', '출발지 전화번호를 입력해주세요');
      return;
    }
    if(endingHp.text ==''){
      Get.snackbar('알림', '도착지 전화번호를 입력해주세요');
      return;
    }
    CallHistory callHistory = CallHistory(
        documentId: '',
        taxiDocumentId: '',
        startingPostcode: startingPostcode.value,
        startingAddress: startingAddress.value,
        startingAddressDetail:startingAddressDetailController.text,
        startingName: startingName.text,
        startingHp: startingHp.text,
        endingPostcode: endingPostcode.value,
        endingAddress: endingAddress.value,
        endingAddressDetail: endingAddressDetailController.text,
        endingName: endingName.text,
        endingHp: endingHp.text,
        selectedOption: selectedOption.value,
        caution: caution.text,
        billingKey: '',
        price: 0,
        userDocumentId: '',
        paymentType: '카드 자동 결제',
        state: '호출전',
        createDate: Timestamp.now()
    );
    Get.toNamed('/confirmView',arguments: callHistory)!.then((value) {
      startingPostcode.value = '우편번호를 검색하세요';
      startingAddress.value = '';
      startingAddressDetailController.text = '';
      startingName.text = '';
      startingHp.text = '';
      endingPostcode.value = '우편번호를 검색하세요';
      endingAddress.value = '';
      endingAddressDetailController.text = '';
      endingName.text = '';
      endingHp.text = '';
      selectedOption.value = 'small';
      caution.text = '';
      getCurrentUser();
    });
  }

  radioBox<Widget>(size,text,subText){
    return Obx(()=>
      RadioListTile<String>(
        title: Text(text),
        subtitle: Text(subText),
        value: size,
        groupValue: selectedOption.value,
        onChanged: (String? value) {
          selectedOption.value = value!;
        },
        activeColor: Colors.red,
      ),
    );
  }
  bottomSheet(context,starting){
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20))),
      builder: (BuildContext context) {
        return SizedBox(
          height: 216,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('배송하실 물품은 운행 기사님께',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('직접 ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24,color: mainColor),),
                      Text(starting?'인계 하셔야 합니다':'인계 받으셔야 합니다',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24),),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  kopoModel(context,starting);
                },
                child: Container(
                  width: 358,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('확인',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
