
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/model/callHistory.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

import '../global.dart';
import 'notifyData.dart';

class CallHistoryData{
  final db = FirebaseFirestore.instance;
  final callHistoryCollection = FirebaseFirestore.instance.collection('callHistory');

  Future<bool> addItem(CallHistory callHistory, String id) async {
    try{
      await callHistoryCollection.doc(id).set(callHistory.toMap());
      return true;
    } catch(e){
      print(e);
      return false;
    }
  }
  Future<RxList<CallHistory>> getTaxiItem() async {
    try{
      QuerySnapshot querySnapshot = await callHistoryCollection.get();
      RxList<CallHistory> list = <CallHistory>[].obs;
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        bool check1 = data['startingAddress'].contains(myInfo.address1);
        bool check2 = data['startingAddress'].contains(myInfo.address2);
        if(data['state'] =='호출중' && check1 && check2){
          list.add(CallHistory.fromMap(data));
        }
      }
      return list;
    } catch (e) {
      print(e);
      RxList<CallHistory> list = <CallHistory>[].obs;
      return list;
    }
  }
  Future<RxList<CallHistory>> getTaxiNotify() async {
    try{
      QuerySnapshot querySnapshot = await callHistoryCollection.where('taxiDocumentId', isEqualTo: myInfo.documentId).get();
      RxList<CallHistory> list = <CallHistory>[].obs;
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        list.add(CallHistory.fromMap(data));
      }
      return list;
    } catch (e) {
      print(e);
      RxList<CallHistory> list = <CallHistory>[].obs;
      return list;
    }
  }


  Future updateItem(CallHistory callHistory,bool check) async {
    DocumentSnapshot documentSnapshot = await callHistoryCollection.doc(callHistory.documentId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if(check){
      if(data['state'] != '호출중' || data['taxiDocumentId'] != '') {
        Get.snackbar('배차 실패', '배차가 완료된 주문입니다.');
        return;
      }
    }
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(data['userDocumentId']).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    DocumentReference documentRef = callHistoryCollection.doc(callHistory.documentId);
    await documentRef.update({
      'state': callHistory.state,
      'taxiDocumentId':myInfo.documentId,
      'price':callHistory.price,
    });

    if(callHistory.state == '배정완료'){
      pushFcm(userData['fcmToken'], '배차완료', '택시 배차가 완료되었습니다\n택시번호 : ${myInfo.taxiNumber}\n전화번호 : ${myInfo.hp}', snapshot.id, callHistory.price);
    }
    if(callHistory.state == '배송완료'){
      pushFcm(userData['fcmToken'], '이용 완료', '물품 배달이 완료 되었습니다.', snapshot.id, callHistory.price);
    }
    else if(callHistory.state == '배송중'){
      pushFcm(userData['fcmToken'], '픽업 완료', '물건 픽업이 완료되었습니다\n택시번호 : ${myInfo.taxiNumber}\n전화번호 : ${myInfo.hp}', snapshot.id, callHistory.price);
    }
    else if(callHistory.state == '배차실패'){
      pushFcm(userData['fcmToken'], '배차실패', '배차가 실패되었습니다.', snapshot.id, 0);
    }
  }

  Future pushFcm(String fcmToken, String title, String body, String uid, int pay) async{
    try {
      final jsonCredentials = await rootBundle.loadString('assets/delivery-taxi-17959-firebase-adminsdk-cvi0s-b5e005a4a3.json');
      final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
      final client = await auth.clientViaServiceAccount(
        creds,
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      final String url = "https://fcm.googleapis.com/v1/projects/delivery-taxi-17959/messages:send";

      final Map<String, dynamic> message1 = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "page": "notify",
          },
          "apns": {
            "payload": {
              "aps": {
                "category": "Message Category",
                "content-available": 1,
              }
            }
          }
        }
      };
      // Dio dio = Dio();
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${client.credentials.accessToken.data}',
        },
        body: json.encode(message1),
      );

      if (response.statusCode == 200) {
        NotifyData().setNotify(title, body, uid, pay);
        print('Push notification sent to all users successfully');
      } else {
        print('Failed to send push notification. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending push notification to all users: $e');
    }
  }
}
