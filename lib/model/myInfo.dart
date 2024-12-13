import 'package:cloud_firestore/cloud_firestore.dart';

class MyInfo {
  final String documentId;    // 일반유저
  String type;          // 일반유저
  final String name;
  final String hp;
  String address1;
  String address2;
  final String taxiNumber;
  final String taxiType;
  String taxiImage;
  bool isAuth;
  final Timestamp createDate;

  MyInfo({
    required this.documentId,
    required this.type,
    required this.name,
    required this.hp,
    required this.address1,
    required this.address2,
    required this.taxiNumber,
    required this.taxiType,
    required this.taxiImage,
    required this.isAuth,
    required this.createDate,
  });

  // Firestore에서 데이터를 가져와서 MyInfo 객체로 변환하는 팩토리 메서드
  factory MyInfo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyInfo(
      documentId: doc.id,
      type: data['type'] ?? '',
      name: data['name'] ?? '',
      hp: data['hp'] ?? '',
      address1: data['address1'] ?? '',
      address2: data['address2'] ?? '',
      taxiNumber: data['taxiNumber'] ?? '',
      taxiType: data['taxiType'] ?? '',
      taxiImage: data['taxiImage'] ?? '',
      isAuth: data['isAuth'] ?? false,
      createDate: data['createDate'] ?? Timestamp.now(),
    );
  }

  // MyInfo 객체를 Firestore에 저장할 수 있는 맵으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'hp': hp,
      'address1': address1,
      'address2': address2,
      'taxiNumber': taxiNumber,
      'taxiType': taxiType,
      'taxiImage': taxiImage,
      'isAuth': isAuth,
      'createDate': createDate,
    };
  }
}
