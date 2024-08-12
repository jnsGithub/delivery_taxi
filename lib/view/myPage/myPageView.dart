import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global.dart';
import 'myPageController.dart';





class MyPageView extends GetView<MyPageController> {
  const MyPageView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => MyPageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myInfo.type =='taxi' ?GestureDetector(
                    onTap: () async{
                      Get.toNamed('/taxiAccountView');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('계좌 등록',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ):Container(),
                  GestureDetector(
                    onTap: () async{
                      Get.toNamed('/contactUs');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('고객센터',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ),
                  Container(width: size.width, height: 1, decoration: const BoxDecoration(color: gray100),),
                  GestureDetector(
                    onTap: () async{
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('서비스 이용 약관',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ),
                  Container(width: size.width, height: 1, decoration: const BoxDecoration(color: gray100),),
                  GestureDetector(
                    onTap: () async{
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('개인정보처리방침',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ),
                  Container(width: size.width, height: 1, decoration: const BoxDecoration(color: gray100),),
                  GestureDetector(
                    onTap: () async{
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('위치정보 이용약관',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ),
                  Container(width: size.width, height: 1, decoration: const BoxDecoration(color: gray100),),
                  GestureDetector(
                    onTap: () async{
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('로그아웃',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ),
                  Container(width: size.width, height: 1, decoration: const BoxDecoration(color: gray100),),
                  GestureDetector(
                    onTap: () async{
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('회원탈퇴',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
