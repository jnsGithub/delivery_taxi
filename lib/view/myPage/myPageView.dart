import 'package:delivery_taxi/data/socialLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/callHistroyData.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(uid.substring(0,8), style: TextStyle(fontWeight: FontWeight.w300),),
                  IconButton(onPressed: (){
                    Clipboard.setData(ClipboardData(text: uid.substring(0,8)));
                  }, icon: Icon(Icons.copy, size: 10,),),
                ],
              ),
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
                      if(myInfo.type == 'taxi'){
                        launchUrl('https://electric-fortnight-2a5.notion.site/d9032623fa124078832590eafad765cb?pvs=4');
                      } else {
                        launchUrl('https://electric-fortnight-2a5.notion.site/d9032623fa124078832590eafad765cb?pvs=4');
                      }
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
                      if(myInfo.type == 'taxi'){
                        launchUrl('https://electric-fortnight-2a5.notion.site/5e251b921e314b1996e86047776a7d64?pvs=4');
                      } else {
                        launchUrl('https://electric-fortnight-2a5.notion.site/77b089422d2d4338b7e55cc43fc29f3b?pvs=4');
                      }
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
                      if(myInfo.type == 'taxi'){
                        launchUrl('https://electric-fortnight-2a5.notion.site/f3c540f6c48b4b0db5f779caae47b768?pvs=4');
                      } else {
                        launchUrl('https://electric-fortnight-2a5.notion.site/f3c540f6c48b4b0db5f779caae47b768?pvs=4');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('위치정보 이용 약관',style: TextStyle(fontSize: 15),),
                          Icon(Icons.navigate_next,color:gray200,)
                        ],
                      ),
                    ),
                  ),
                  Container(width: size.width, height: 1, decoration: const BoxDecoration(color: gray100),),
                  GestureDetector(
                    onTap: () async{
                      SocialLogin().signOut();
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
