import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:delivery_taxi/component/main_box.dart';
import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/view/signUp/signUpController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class SignUpView extends GetView<SignUpController> {
  const SignUpView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => SignUpController());
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Delivery T를 이용하려면\n동의가 필요해요',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: font2424),),
          ),
          LineContainer(),
          Obx(()=>
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(color: gray300),
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Row(
                      children: [
                        Checkbox(value: controller.allCheckBool.value,activeColor: mainColor, onChanged: (value){
                          controller.allCheck();
                        }),
                        GestureDetector(
                            onTap: (){
                              controller.allCheck();
                            },
                            child: Text('전체 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: controller.check1.value,activeColor: mainColor, onChanged: (value){
                              controller.check(1);
                            }),
                            GestureDetector(
                              onTap: (){
                                controller.check(1);
                              },
                              child: SizedBox(
                                  width: size.width*0.7,
                                  child: Text('(필수) 정산처리를 위한 개인정보 제3자 제공 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: (){
                            launchUrl('https://electric-fortnight-2a5.notion.site/77b089422d2d4338b7e55cc43fc29f3b?pvs=4');
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,)
                      ],
                    ),
                  ),

                  Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: controller.check2.value,activeColor: mainColor, onChanged: (value){
                              controller.check(2);
                            }),
                            GestureDetector(
                              onTap: (){
                                controller.check(2);
                              },
                              child: SizedBox(
                                width: size.width*0.7,
                                  child: Text('(필수) 차량 배차를 위한 개인정보 및 위치정보 제 3자 제공 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: (){
                            launchUrl('https://electric-fortnight-2a5.notion.site/77b089422d2d4338b7e55cc43fc29f3b?pvs=4');
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,)
                      ],
                    ),
                  ),
                  Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: controller.check3.value,activeColor: mainColor, onChanged: (value){
                              controller.check(3);
                            }),
                            GestureDetector(
                                onTap: (){
                                  controller.check(3);
                                },
                                child: Text('(필수) 위치기반서비스 이용약관 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                          ],
                        ),
                        IconButton(
                          onPressed: (){
                            launchUrl('https://electric-fortnight-2a5.notion.site/f3c540f6c48b4b0db5f779caae47b768?pvs=4');
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,)
                      ],
                    ),
                  ),
                  Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: controller.check4.value,activeColor: mainColor, onChanged: (value){
                              controller.check(4);
                            }),
                            GestureDetector(
                               onTap: () {
                                 controller.check(4);
                               },
                                child: Text('(필수) 서비스 이용약관 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                          ],
                        ),
                        IconButton(
                          onPressed: (){
                            launchUrl('https://electric-fortnight-2a5.notion.site/d9032623fa124078832590eafad765cb?pvs=4');
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,)
                      ],
                    ),
                  ),
                  Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: controller.check5.value,activeColor: mainColor, onChanged: (value){
                              controller.check(5);
                            }),
                            GestureDetector(
                                onTap: (){
                                  controller.check(5);
                                },
                                child: Text('(필수) 개인정보 수집 및 이용동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                          ],
                        ),
                        IconButton(
                          onPressed: (){
                            launchUrl('https://electric-fortnight-2a5.notion.site/77b089422d2d4338b7e55cc43fc29f3b?pvs=4');
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 24,horizontal: 16),
            child: GestureDetector(
              onTap: (){
                controller.allCheckBool.value ?
                Get.toNamed('/noticeView'):
                Get.snackbar('알림', '모든 동의를 해주세요');
              },
                child: MainBox(text: '가입하기',color: mainColor)
            )
        ),
      )
    );
  }
}
