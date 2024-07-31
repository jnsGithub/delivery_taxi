
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/model/callHistory.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../global.dart';

class CallHistoryData{
  final db = FirebaseFirestore.instance;
  final callHistoryCollection = FirebaseFirestore.instance.collection('callHistory');

  Future<bool> addItem(CallHistory callHistory) async {
    try{
      await callHistoryCollection.add(callHistory.toMap());
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
        data['documentId'] = document.id;
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
  Future updateItem(CallHistory callHistory) async {
    DocumentReference documentRef = callHistoryCollection.doc(callHistory.documentId);
    await documentRef.update({
      'state': callHistory.state,
      'taxiDocumentId':myInfo.documentId,
    });
  }
}
