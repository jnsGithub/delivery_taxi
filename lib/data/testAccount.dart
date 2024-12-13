import 'package:cloud_firestore/cloud_firestore.dart';

class TestAccount {
  final db = FirebaseFirestore.instance;

  Future<bool> isTestAccountVisible() async{
    try{
      DocumentSnapshot document = await db.collection('testAccount').doc('testAccount').get();
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return data['visible'];
    } catch(e){
      return false;
    }
  }

}