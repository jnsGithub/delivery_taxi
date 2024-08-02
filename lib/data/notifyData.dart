import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';
import '../model/notify.dart';

class NotifyData{
  final db = FirebaseFirestore.instance.collection('notify');

  Future getNotify() async {
    List<Notify> notify = [];
    QuerySnapshot querySnapshot = await db.where('documentId', isEqualTo: uid).orderBy('createDate', descending: true).get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      notify.add(Notify.fromMap(data, document.id));
    }
    return notify;
  }
}