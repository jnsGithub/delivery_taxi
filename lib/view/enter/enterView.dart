import 'package:delivery_taxi/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class EnterView extends GetView {
  const EnterView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('회원선택',style: TextStyle(
              fontSize: 24,fontWeight: FontWeight.w600
            ),),
            const SizedBox(height: 20),
            const Text('회원 유형을 선택해 주세요',style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.toNamed('/loginView',arguments: 'taxi');
                  },
                  child: Container(
                    width: size.width*0.44,
                    height: size.width*0.5556,
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7FA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.local_taxi,color: mainColor,size: 35,),
                        Text('택시기사용',style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: gray700
                        ),),
                        Text('택시기사님이\n가입할 수 있어요',style: TextStyle(
                          fontSize: 14,fontWeight: FontWeight.w400,color: gray600
                        ),)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.toNamed('/loginView',arguments: 'user');
                  },
                  child: Container(
                    width: size.width*0.44,
                    height: size.width*0.5556,
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7FA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.person,color: mainColor,size: 35,),
                        Text('일반 회원',style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: gray700
                        ),),
                        Text('택배를 보내는 회원이 가입 할수 있어요',style: TextStyle(
                            fontSize: 14,fontWeight: FontWeight.w400,color: gray600
                        ),)
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
