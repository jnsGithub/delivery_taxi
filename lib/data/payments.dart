import 'package:bootpay/bootpay.dart';
import 'package:bootpay/bootpay_api.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/callHistory.dart';
import 'callHistroyData.dart';

class Payments{
  String webApplicationId = '6678ebc6bd077d0720f8768b';
  String androidApplicationId = '6678ebc6bd077d0720f8768c';
  String iosApplicationId = '6678ebc6bd077d0720f8768d';
  String restApplicationId = '6678ebc6bd077d0720f8768e';
  String privateApplicationId = 'nbHljmWEqNX6rp73V14pkSMVxWaqHDT86zc5H/VaAKs=';


  void bootpayTest(BuildContext context, String pg, int price, String orderName, CallHistory callHistory) {
    final CallHistoryData  callHistoryData = CallHistoryData();
    Payload payload = getPayload(pg, price, orderName);
    late bool check;
    if(kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestSubscription(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onCancel: $data');
      },
      onClose: () async{
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        if(await check){
          Get.snackbar('알림', '호출이 완료되었습니다.');
          Get.toNamed('/useNotifyView');
        } else {
          Get.snackbar('알림', '호출이 실패되었습니다.');
        }
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        var json = jsonDecode(data);

        /**
            1. 바로 승인하고자 할 때
            return true;
         **/
        /***
            2. 비동기 승인 하고자 할 때
            checkQtyFromServer(data);
            return false;
         ***/
        /***
            3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
            return false; 후에 서버에서 결제승인 수행
         */
        // checkQtyFromServer(data);
        return true;
      },
      onDone: (String data) async {
        print('------- onDone: $data');
        var dataJson = jsonDecode(data);
        print(dataJson['data']['receipt_data']['receipt_id']);
        check = await callHistoryData.addItem(callHistory, dataJson['data']['receipt_data']['receipt_id']);
        await Future.delayed(Duration(seconds: 2), ()async => await setBillingKey(callHistory, dataJson['data']['receipt_data']['receipt_id'], dataJson['data']['receipt_id'], pg));
        // setBillingKey(callHistory, dataJson['data']['receipt_data']['receipt_id'], dataJson['data']['receipt_id'], pg);
      },
    );
  }

  Future rePayment(CallHistory callHistory) async{
    String bootPayUrl = 'https://api.bootpay.co.kr/v2/subscribe/payment';
    String tokenUrl = 'https://api.bootpay.co.kr/v2/request/token';
    String cancelUrl = 'https://api.bootpay.co.kr/v2/cancel';
    print(callHistory.documentId);
    String billingKey = await FirebaseFirestore.instance.collection('billingKey').doc(callHistory.documentId).get().then((value) => value['billingKey']);
    // String qq = await FirebaseFirestore.instance.collection('billingKey').doc(callHistory.documentId).get().then((value) => value['billingKey']);
    print('billingKey : $billingKey');
    Map<String, dynamic> rePaymentsMap = {
      "billing_key": billingKey,
      // 'billing_key': '66bc25d5be5ce6894a3b8e31',
      "order_id": "가맹점 주문번호",
      "order_name": "딜리버리티 최종결제금액",
      "price": callHistory.price,
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
      print('캔슬 상태 코드 : ${cancelRespons.statusCode}');
      print('캔슬 응답값 : ${cancelRespons.body}');

      if(cancelRespons.statusCode == 200){
        var response = await http.post(
          Uri.parse(bootPayUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token['access_token']}"
          },
          body: jsonEncode(rePaymentsMap),
        );
        print('재결제 성공');
        print(response.statusCode);
        print('재결제 응답값 ' + response.body);
      } else {
        print('캔슬 실패');
      }



    }catch(e){
      print('에러코드 $e');
    }
  }

  Future cancelPayments(CallHistory callHistory) async {
    String cancelUrl = 'https://api.bootpay.co.kr/v2/cancel';
    String tokenUrl = 'https://api.bootpay.co.kr/v2/request/token';

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
      print('캔슬 상태 코드 : ${cancelRespons.statusCode}');
      print('캔슬 응답값 : ${cancelRespons.body}');
      if(cancelRespons.statusCode == 200){
        await FirebaseFirestore.instance.collection('callHistory').doc(callHistory.documentId).update({
          'state': '호출취소'
        });
        Get.back(result: true);
        Get.snackbar('결제 취소', '택시 호출이 취소되었습니다.', backgroundColor: mainColor, colorText: Colors.white);
      }
      else if(cancelRespons.statusCode == 400){
        Get.snackbar('결제 취소 실패', '결제 취소가 이미 완료되었습니다.', backgroundColor: mainColor, colorText: Colors.white);
      }
      else{
        Get.snackbar('결제 취소 실패', '관리자에게 문의해주세요.', backgroundColor: mainColor, colorText: Colors.white, onTap: (snack) => Get.toNamed('/contactUs'));
      }
    }catch(e){
      print('에러코드 $e');
    }

  }

  Future setBillingKey(CallHistory callHistory, String docid, String receiptId, String paymentType) async{
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await db.collection('callHistory').doc(docid).get();
      String billingKey = await getBillingKey(receiptId);
      db.collection('billingKey').doc(docid).set({
        'billingKey': billingKey,
        'createDate': Timestamp.now(),
        'userDocumentId': myInfo.documentId,
        'callHistoryId': snapshot.id,
      });
      db.collection('callHistory').doc(docid).update({
        'paymentType': paymentType
      });

    } catch(e){
      print(e);
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
      print('토큰 조회 결과' + tokenReponse.body);
      print('hello world!');

      print(receiptId);
      var billingKeyReponse = await http.get(buillingKeyUri,headers: {'Authorization': 'Bearer ${tokenReponseData['access_token']}'});
      print('빌링키 조회 결과 : ' + billingKeyReponse.body);
      var billingKeyResponseData = jsonDecode(billingKeyReponse.body);

      print('빌링키 : ${billingKeyResponseData['billing_key']}');
      return billingKeyResponseData['billing_key'];
    } catch (e) {
      print(e);
      print('캐치당함');
      return '';
    }
  }

  Payload getPayload(String pg, int price, String orderName) {
    Payload payload = Payload();
    // Item item1 = Item();
    // item1.name = "미키 '마우스"; // 주문정보에 담길 상품명
    // item1.qty = 1; // 해당 상품의 주문 수량
    // item1.id = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    // item1.price = 500; // 상품의 가격
    //
    // Item item2 = Item();
    // item2.name = "키보드"; // 주문정보에 담길 상품명
    // item2.qty = 1; // 해당 상품의 주문 수량
    // item2.id = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    // item2.price = 500; // 상품의 가격
    // List itemList = [item1, item2];

    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId = androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id


    payload.pg = pg;
    payload.method = '간편자동';
    // payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
    payload.orderName = orderName; //결제할 상품명
    payload.price = price.toDouble(); //정기결제시 0 혹은 주석


    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함
    payload.subscriptionId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함


    // payload.metadata = {
    //   "callbackParam1" : "value12",
    //   "callbackParam2" : "value34",
    //   "callbackParam3" : "value56",
    //   "callbackParam4" : "value78",
    // }; // 전달할 파라미터, 결제 후 되돌려 주는 값
    // payload.items = itemList.cast<Item>(); // 상품정보 배열

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
    // extra.openType = 'popup';

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    payload.user = user;
    payload.extra = extra;
    return payload;
  }


}

