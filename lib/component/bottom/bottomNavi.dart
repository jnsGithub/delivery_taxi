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
          // 현재 인덱스를 selectedIndex에 저장
          currentIndex: pageIndex,
          // 요소(item)을 탭 할 시 실행)
          onTap:(int index) {controller.changeIndex(index,pageIndex);},
          // 선택에 따라 icon·label 색상 변경
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.grey[500],

          // 선택에 따라 label text style 변경
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          selectedLabelStyle: const TextStyle(fontSize: 10),
          // 탭 애니메이션 변경 (fixed: 없음)
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          // Bar에 보여질 요소. icon과 label로 구성.
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
