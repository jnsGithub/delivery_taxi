import 'package:cloud_firestore/cloud_firestore.dart';

class Notify {
  final String documentId;
  final String title;
  final String content;
  final int pay;
  final Timestamp createDate;

  Notify({
    required this.documentId,
    required this.title,
    required this.content,
    required this.pay,
    required this.createDate,
  });

  // Firestore 데이터로부터 객체를 생성하는 팩토리 생성자
  factory Notify.fromMap(Map<String, dynamic> data, String documentId) {
    return Notify(
      documentId: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      pay: data['pay'] ?? 0,
      createDate: data['createDate'] ?? Timestamp.now(),
    );
  }

  // 객체를 Firestore에 저장할 수 있는 Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'title': title,
      'content': content,
      'pay': pay,
      'createDate': createDate,
    };
  }
}
