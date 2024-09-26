class BillingInfo {
  final String billingKey;
  final String callHistoryId;
  final String cardCompany;
  final String cardNo;
  final DateTime createDate;
  final String userDocumentId;

  BillingInfo({
    required this.billingKey,
    required this.callHistoryId,
    required this.cardCompany,
    required this.cardNo,
    required this.createDate,
    required this.userDocumentId,
  });

  // JSON 데이터를 BillingInfo 객체로 변환하는 factory 메서드
  factory BillingInfo.fromJson(Map<String, dynamic> json) {
    return BillingInfo(
      billingKey: json['billingKey'],
      callHistoryId: json['callHistoryId'],
      cardCompany: json['card_company'],
      cardNo: json['card_no'],
      createDate:json['createDate'].toDate(), // 날짜 형식에 맞게 파싱
      userDocumentId: json['userDocumentId'],
    );
  }

  // BillingInfo 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'billingKey': billingKey,
      'callHistoryId': callHistoryId,
      'card_company': cardCompany,
      'card_no': cardNo,
      'createDate': createDate.toIso8601String(),
      'userDocumentId': userDocumentId,
    };
  }
}