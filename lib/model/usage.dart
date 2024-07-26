import 'package:cloud_firestore/cloud_firestore.dart';

class Usage {
  final String date;
  final String type;
  final int price;
  final String documentId;
  final String title;

  Usage({required this.date, required this.type,required this.price, required this.documentId, required this.title});


  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      date:(json['date'] as Timestamp).toDate().toString().substring(0,10),
      type:json['type'] ?? '',
      price:json['price'] as int,
      documentId:json['documentId'] ?? '',
      title:json['title'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['type'] = this.type;
    data['price'] = this.price;
    data['documentId'] = this.documentId;
    data['title'] = this.title;
    return data;
  }
}

class Charging{
  final String date;
  final String type;
  final int price;
  final String documentId;

  Charging({required this.date, required this.type,required this.price, required this.documentId});


  factory Charging.fromJson(Map<String, dynamic> json) {
    return Charging(
      documentId: json['documentId'],
      date:(json['date'] as Timestamp).toDate().toString().substring(0,10),
      type:json['type'],
      price:json['price'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}

