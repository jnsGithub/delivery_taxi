import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/component/main_box.dart';
import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/view/userMain/userMainController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/billingInfo.dart';
import '../model/callHistory.dart';
import '../view/useNotify/useNotifyController.dart';
import 'callHistroyData.dart';

class Payments{

  final CallHistoryData  callHistoryData = CallHistoryData();
  String webApplicationId = '6678ebc6bd077d0720f8768b';
  String androidApplicationId = '6678ebc6bd077d0720f8768c';
  String iosApplicationId = '6678ebc6bd077d0720f8768d';
  String restApplicationId = '6678ebc6bd077d0720f8768e';
  String privateApplicationId = 'nbHljmWEqNX6rp73V14pkSMVxWaqHDT86zc5H/VaAKs=';

  var dataJson;

  billingKeyPay(context, price, orderName, callHistory,billingKey) async {
    User user = User(); // 구매자 정보
    user.username = myInfo.documentId;
    user.id = myInfo.documentId;
    user.phone = myInfo.hp;
    String bootPayUrl = 'https://api.bootpay.co.kr/v2/subscribe/payment';
    String tokenUrl = 'https://api.bootpay.co.kr/v2/request/token';
    Map<String, dynamic> rePaymentsMap = {
      "billing_key": billingKey,
      "order_id": DateTime.now().millisecondsSinceEpoch.toString(),
      "order_name": orderName,
      "price": price,
      "user": {
        "username": myInfo.documentId,
        "phone": "01000000000",
      }
    };

    Map<String, dynamic> tokenMap = {
      'application_id' : restApplicationId,
      'private_key' : privateApplicationId
    };
    try{
      var tokenRespons = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(tokenMap),
      );
      var token = jsonDecode(tokenRespons.body);
        var response = await http.post(
          Uri.parse(bootPayUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token['access_token']}"
          },
          body: jsonEncode(rePaymentsMap),
        );
      dataJson = jsonDecode(response.body);
      callHistory.billingKey = billingKey;
      bool check = await callHistoryData.addItem(callHistory, dataJson['receipt_id']);
      if(check){
        Get.back();
        Get.back(result: true);
        UserMainController().getCurrentUser();
        await Get.delete<UseNotifyController>();
        Get.snackbar('알림', '호출이 완료되었습니다.');
        Get.toNamed('/useNotifyView');
      } else {
        Get.snackbar('알림', '호출이 실패되었습니다.');
      }
    } catch(e){
      print(e);
    }
  }
  choicePayment(BuildContext context, String pg, int price, String orderName, CallHistory callHistory) async {
    final db = FirebaseFirestore.instance.collection('billingKey');
    CarouselSliderController buttonCarouselController = CarouselSliderController();
    Size size = MediaQuery.of(context).size;
    QuerySnapshot querySnapshot = await db.where('userDocumentId',isEqualTo : myInfo.documentId).get();
    List<BillingInfo> billingInfo = [];
    List<Widget> cardList = [];
    int currentIndex = 0;
    if(querySnapshot.docs.isNotEmpty){
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        billingInfo.add(BillingInfo.fromJson(data));
        cardList.add(
            Container(
              width: size.width*0.6923,
              height: 500,
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 18),
              decoration: BoxDecoration(
                color: Color(0xff6974A4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(data['card_company'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('카드 번호',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),
                      SizedBox(height: 9,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('**** **** ****'
                            ,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Colors.white),),
                          Text(' ${data['card_no'].substring(11,15)}'
                            ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
        );
      }
    }
    cardList.add(
        GestureDetector(
          onTap: (){
            bootpayTest(context, pg, price, orderName, callHistory);
          },
          child: Container(
            width: size.width*0.6923,
            height: size.width*0.3974,
            decoration: BoxDecoration(
              color: Color(0xffF6F6F9),
              border: Border.all(color: Color(0xff848487),),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color:  Color(0xff848487),),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Icon(Icons.add,color: Color(0xff848487),)
                  ),
                  const SizedBox(height: 35),
                  Text('결제하실 카드를 등록해 주세요.'),
                ],
              ),
            ),
          ),
        )
    );
    showModalBottomSheet(
      context: context,
      isDismissible:false,
      isScrollControlled: true, // 바텀 시트의 높이 조절을 가능하게 함
      backgroundColor: Colors.transparent, // 바텀 시트 배경을 투명하게
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '결제 수단',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        CarouselSlider(
                          items: cardList,
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            autoPlay: false,
                            enableInfiniteScroll:false,
                            height: size.width*0.42,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              currentIndex = index;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '예상 결제 금액',
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                            ),
                            Text(
                              formatNumber(price),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: (){
                            if(billingInfo.isEmpty || currentIndex == billingInfo.length){
                              bootpayTest(context, pg, price, orderName, callHistory);
                            } else {
                              billingKeyPay(context, price, orderName, callHistory, billingInfo[currentIndex].billingKey);
                            }
                          },
                            child: MainBox(text: '결제하기', color: mainColor)
                        )

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void bootpayTest(BuildContext context, String pg, int price, String orderName, CallHistory callHistory) {
    Payload payload = getPayload(pg, price, orderName);
    payload.user?.phone = callHistory.startingHp;
    if(kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestSubscription(
      context: context,
      payload: payload,
      showCloseButton: false,
      onCancel: (String data) {
      },
      onError: (String data) {
      },
      onClose: () async{
        try{
          Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
          saving(context);
          bool check = false;
          await Future.delayed(Duration(seconds: 2), ()async => check = await setBillingKey(callHistory, dataJson['data']['receipt_data']['receipt_id'], dataJson['data']['receipt_id'], pg,dataJson['data']['receipt_data']['card_data']));
          if(check){
            Get.back();
            Get.back();
            Get.back(result: true);
            Get.snackbar('알림', '호출이 완료되었습니다.');
            UserMainController().getCurrentUser();
            await Get.delete<UseNotifyController>();
            Get.toNamed('/useNotifyView');
          } else {
            Get.snackbar('알림', '호출이 실패되었습니다.');
          }
        } catch (e){
          Get.back();
        }
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onIssued: (String data) {
      },
      onConfirm: (String data) {
        return true;
      },
      onDone: (String data) async {
        dataJson = jsonDecode(data);
      },
    );
  }

  Future rePayment(CallHistory callHistory, {int? cancel}) async{
    String bootPayUrl = 'https://api.bootpay.co.kr/v2/subscribe/payment';
    String tokenUrl = 'https://api.bootpay.co.kr/v2/request/token';
    String cancelUrl = 'https://api.bootpay.co.kr/v2/cancel';
    String billingKey = callHistory.billingKey;
    Map<String, dynamic> rePaymentsMap = {
      "billing_key": billingKey,
      "order_id": "가맹점 주문번호",
      "order_name": cancel == null ? "딜리버리티 최종결제금액" : "딜리버리티 호출취소" ,
      "price": cancel ?? callHistory.price,
      "user": {
        "phone": "01000000000",
      }
    };

    Map<String, dynamic> cancelMap = {
      'receipt_id': callHistory.documentId,
    };
    Map<String, dynamic> tokenMap = {
      'application_id' : restApplicationId,
      'private_key' : privateApplicationId
    };
    try{
      var tokenRespons = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(tokenMap),
      );

      var token = jsonDecode(tokenRespons.body);

      var cancelRespons = await http.post(
          Uri.parse(cancelUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token['access_token']}"
          },
          body: jsonEncode(cancelMap));

      if(cancelRespons.statusCode == 200){
       await http.post(
          Uri.parse(bootPayUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token['access_token']}"
          },
          body: jsonEncode(rePaymentsMap),
        );
      } else {
      }



    }catch(e){
    }
  }

  Future cancelPayments(CallHistory callHistory) async {
    String cancelUrl = 'https://api.bootpay.co.kr/v2/cancel';
    String tokenUrl = 'https://api.bootpay.co.kr/v2/request/token';

    Map<String, dynamic> cancelMap = {
      'receipt_id': callHistory.documentId,
      'cancel_price': callHistory.price - 1000,
    };
    Map<String, dynamic> tokenMap = {
      'application_id' : restApplicationId,
      'private_key' : privateApplicationId
    };

    try{
      var tokenRespons = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(tokenMap),
      );

      var token = jsonDecode(tokenRespons.body);

      var cancelRespons = await http.post(
          Uri.parse(cancelUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token['access_token']}"
          },
          body: jsonEncode(cancelMap));
      if(cancelRespons.statusCode == 200){
        await FirebaseFirestore.instance.collection('callHistory').doc(callHistory.documentId).update({
          'price': 1000,
          'state': '호출취소'
        });
        Get.back(result: true);
        Get.snackbar('결제 취소', '차량 호출이 취소되었습니다.', backgroundColor: mainColor, colorText: Colors.white);
      }
      else if(cancelRespons.statusCode == 400){
        Get.snackbar('결제 취소 실패', '결제 취소가 이미 완료되었습니다.', backgroundColor: mainColor, colorText: Colors.white);
      }
      else{
        Get.snackbar('결제 취소 실패', '관리자에게 문의해주세요.', backgroundColor: mainColor, colorText: Colors.white, onTap: (snack) => Get.toNamed('/contactUs'));
      }
    }catch(e){
    }
  }

  Future setBillingKey(CallHistory callHistory, String docid, String receiptId, String paymentType,cardData) async{
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await db.collection('callHistory').doc(docid).get();
      String billingKey = await getBillingKey(receiptId);
      callHistory.billingKey = billingKey;
      await callHistoryData.addItem(callHistory, dataJson['data']['receipt_data']['receipt_id']);
      db.collection('billingKey').doc(docid).set({
        'billingKey': billingKey,
        'createDate': Timestamp.now(),
        'userDocumentId': myInfo.documentId,
        'callHistoryId': snapshot.id,
        'card_no': cardData['card_no'],
        'card_company': cardData['card_company'],
      });
      return true;
    } catch(e){
      return false;
    }
  }

  Future getBillingKey(String receiptId) async {
    try {
      String billingKeyUrl = 'https://api.bootpay.co.kr/v2/subscribe/billing_key/${receiptId}';
      String tokenUrl = 'https://api.bootpay.co.kr/v2/request/token';
      Uri buillingKeyUri = Uri.parse(billingKeyUrl);
      Uri tokenUri = Uri.parse(tokenUrl);
      Map<String, dynamic> tokenMap = {
        'application_id' : restApplicationId,
        'private_key' : privateApplicationId
      };
      var tokenBody = jsonEncode(tokenMap);
      var tokenReponse = await http.post(
        tokenUri,
        headers: {
          "Content-Type": "application/json"
        },
        body: tokenBody,
      );
      var tokenReponseData = jsonDecode(tokenReponse.body);
      var billingKeyReponse = await http.get(buillingKeyUri,headers: {'Authorization': 'Bearer ${tokenReponseData['access_token']}'});
      var billingKeyResponseData = jsonDecode(billingKeyReponse.body);

      return billingKeyResponseData['billing_key'];
    } catch (e) {
      return '';
    }
  }

  Payload getPayload(String pg, int price, String orderName) {
    Payload payload = Payload();

    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId = androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id


    payload.pg = pg;
    payload.method = '카드자동';
    payload.orderName = orderName; //결제할 상품명
    payload.price = price.toDouble(); //정기결제시 0 혹은 주석

    String id = DateTime.now().millisecondsSinceEpoch.toString();

    payload.orderId = id; //주문번호, 개발사에서 고유값으로 지정해야함
    payload.subscriptionId = id; //주문번호, 개발사에서 고유값으로 지정해야함

    User user = User(); // 구매자 정보
    user.username = myInfo.documentId;
    user.id = myInfo.documentId;
    user.email = "";
    user.area = "";
    user.phone = myInfo.hp;
    user.addr = '';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';

    payload.user = user;
    payload.extra = extra;
    return payload;
  }

}

