import 'package:cloud_firestore/cloud_firestore.dart';

class CallHistory {
  final String documentId;
  final String startingPostcode;
  final String startingAddress;
  final String startingName;
  final String startingHp;
  final String startingAddressDetail;
  final String endingPostcode;
  final String endingAddress;
  final String endingName;
  final String endingHp;
  final String endingAddressDetail;
  final String selectedOption;
  final String caution;
  final String userDocumentId;
  final String taxiDocumentId;
  String paymentType; // 카카오 or 네이버
  String state;
  int price;// 가격
  Timestamp createDate;

  CallHistory({
    required this.documentId,
    required this.startingAddressDetail,
    required this.startingPostcode,
    required this.startingAddress,
    required this.startingName,
    required this.startingHp,
    required this.endingAddressDetail,
    required this.endingPostcode,
    required this.endingAddress,
    required this.endingName,
    required this.endingHp,
    required this.selectedOption,
    required this.caution,
    required this.userDocumentId,
    required this.taxiDocumentId,
    required this.paymentType,
    required this.state,
    required this.price,
    required this.createDate,
  });

  // fromMap: Firestore 데이터를 Usage 객체로 변환
  factory CallHistory.fromMap(Map<String, dynamic> map) {
    return CallHistory(
      documentId: map['documentId'] ?? '',
      startingPostcode: map['startingPostcode'] ?? '',
      startingAddress: map['startingAddress'] ?? '',
      startingAddressDetail: map['startAddressDetail'] ?? '',
      startingName: map['startingName'] ?? '',
      startingHp: map['startingHp'] ?? '',
      endingPostcode: map['endingPostcode'] ?? '',
      endingAddressDetail: map['endingAddressDetail'] ?? '',
      endingAddress: map['endingAddress'] ?? '',
      endingName: map['endingName'] ?? '',
      endingHp: map['endingHp'] ?? '',
      selectedOption: map['selectedOption'] ?? '',
      caution: map['caution'] ?? '',
      userDocumentId: map['userDocumentId'] ?? '',
      taxiDocumentId: map['taxiDocumentId'] ?? '',
      paymentType: map['paymentType'] ?? '',
      state: map['state'] ?? '',
      price: map['price'] ?? 0,
      createDate: map['createDate'] ?? Timestamp.now(),
    );
  }

  // toMap: Usage 객체를 Firestore에 저장할 수 있는 Map 형태로 변환
  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'startingPostcode': startingPostcode,
      'startingAddressDetail': startingAddressDetail,
      'startingAddress': startingAddress,
      'startingName': startingName,
      'startingHp': startingHp,
      'endingPostcode': endingPostcode,
      'endingAddress': endingAddress,
      'endingAddressDetail': endingAddressDetail,
      'endingName': endingName,
      'endingHp': endingHp,
      'selectedOption': selectedOption,
      'caution': caution,
      'userDocumentId': userDocumentId,
      'taxiDocumentId': taxiDocumentId,
      'paymentType': paymentType,
      'state': state,
      'price': price,
      'createDate': createDate,
    };
  }
}
