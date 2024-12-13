import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global.dart';
import '../../main.dart';
import 'bottomNavigationBarController.dart';



class BottomNavi extends GetView<BottomNavigationBarController> {
  final int pageIndex;
  BottomNavi ({required this.pageIndex, super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BottomNavigationBarController());
    return Container(
      decoration: BoxDecoration(
        border:Border(
            top: BorderSide(
                width: 1.0,color: gray500
            )
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: BottomNavigationBar(
          currentIndex: pageIndex,
          onTap:(int index) {controller.changeIndex(index,pageIndex);},
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.grey[500],
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          selectedLabelStyle: const TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon:Icon(Icons.home_filled),
                label: "홈"),
            BottomNavigationBarItem(
                icon:Icon(Icons.notifications),
                label: "이용/알림"),
            BottomNavigationBarItem(
                icon:Icon(Icons.person),
                label: "마이페이지"),

          ],
        ),
      ),
    );
  }
}
