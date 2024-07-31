
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/model/callHistory.dart';

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
}
