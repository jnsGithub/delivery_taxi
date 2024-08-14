
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import 'model/myInfo.dart';

const mainColor = Color(0xffFF4500);
const mainColor2 = Color(0xff141269);
const font2020 = Color(0xff202020);
const font2424 = Color(0xff242424);
const font4343 = Color(0xff434343);
const font3030 = Color(0xff303030);
const font1A1A = Color(0xff1A1A1A);
const C9C9C9 = Color(0xffC9C9C9);
const gray700 = Color(0xff4A4A4A);
const gray600 = Color(0xff636366);
const gray500 = Color(0xff848487);
const gray400 = Color(0xff8E8E93);
const gray300 = Color(0xffAEAEB2);
const gray100 = Color(0xffE5E5EA);
const gray200 = Color(0xffD4D4D4);
const bg = Color(0xffF7F7FA);
String uid = '';
late MyInfo myInfo ;
String loginType = '';
int cash = 0;

Future<void> launchUrl(uri) async {
  Uri _url = Uri.parse(uri);
  if (!await url.launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateFormat dateFormat = DateFormat('MM.dd (EEE)', 'ko_KR');
  return dateFormat.format(dateTime);
}
String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.length == 11) {
    return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, 11)}';
  } else {
    return phoneNumber;
  }
}

String formatNumber(int number) {
  final formatter = NumberFormat('#,###');
  return '${formatter.format(number)} 원';
}
String formatPoint(int number) {
  final formatter = NumberFormat('#,###');
  return '${formatter.format(number)} P';
}
void saving(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible:false,
      builder: (BuildContext context) {
        return const AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0, // 그림자 효과 없애기
            content: Center(
              child: CircularProgressIndicator(color: Colors.white,),
            )
        );
      });
}
