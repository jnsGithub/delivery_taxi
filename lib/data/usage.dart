import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/model/callHistory.dart';

import '../global.dart';

class GetUsage{
  final db = FirebaseFirestore.instance;

  Future getCallHistory() async {
    try{
      List<CallHistory> callHistory = [];
      QuerySnapshot querySnapshot = await db.collection('callHistory').where('userDocumentId', isEqualTo: uid).orderBy('createDate', descending: true).get();
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        callHistory.add(CallHistory.fromMap(data));
      }
      return callHistory;
    } catch(e){
      return [];
    }
  }
}