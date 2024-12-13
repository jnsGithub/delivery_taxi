import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/view/signUp/taxiSignUpController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/main_box.dart';
import '../../component/textfield.dart';





class TaxiSignUpView extends GetView<TaxiSignUpController> {
  const TaxiSignUpView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TaxiSignUpController());
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('택시기사 회원가입'),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('소속 선택' ,style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
            ),),
                const SizedBox(height: 9,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        controller.option('개인');
                      },
                      child: Row(
                        children: [
                          Obx(()=>
                              Radio<String>(
                                visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: '개인',
                                groupValue: controller.selectedOption.value,
                                onChanged: (String? value) {
                                  controller.option( value!);
                                },
                                activeColor:mainColor,
                              ),
                          ),
                          const SizedBox(width: 8,),
                          const Text('개인',style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    GestureDetector(
                      onTap: (){
                        controller.option('법인');
                      },
                      child: Row(
                        children: [
                          Obx(()=>
                              Radio<String>(
                                value: '법인',
                                groupValue: controller.selectedOption.value,
                                onChanged: (String? value) {
                                  controller.option( value!);
                                },
                                activeColor:mainColor,
                              ),
                          ),
                          const Text('법인',style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
                 TextFieldComponent(
                  text: '이름', multi: false, color: Colors.black, typeNumber: false, controller: controller.taxiName,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text('휴대폰 번호',style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),),
                const SizedBox(
                  height: 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(()=>
                        Container(
                          alignment: Alignment.centerLeft,
                          width: size.width*0.6333,
                          height: size.width*0.1282,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xfff6f6fa)),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            readOnly: controller.sendSms.value,
                            controller: controller.hpController,
                            decoration: const InputDecoration(
                              border: InputBorder.none, // 밑줄 없애기
                              contentPadding: EdgeInsets.symmetric(horizontal: 16), // TextField 내부의 패딩 적용
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width:1.5,color: mainColor),
                              ),
                            ),
                          ),
                        ),
                    ),
                    GestureDetector(
                      onTap: (){
                        controller.sendSMS();
                      },
                      child: Container(
                        width: size.width*0.2590,
                        height: size.width*0.1282,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: mainColor,
                        ),
                        child: const Text('인증번호 발송',style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: size.width*0.6333,
                      height: size.width*0.1282,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xfff6f6fa)),
                      child: Obx(()=>
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: controller.hpAuthController,
                            readOnly: controller.hpAuthCheck.value,
                            decoration: const InputDecoration(
                              hintText: '인증번호 입력',
                              border: InputBorder.none, // 밑줄 없애기
                              contentPadding: EdgeInsets.symmetric(horizontal: 16), // TextField 내부의 패딩 적용
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width:1.5,color: mainColor),
                              ),
                            ),
                          ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(controller.hpAuthController.text == controller.authNum.value) {
                          controller.sendSms.value = true;
                          controller.hpAuthCheck.value = true;
                        } else {
                          controller.sendSms.value = false;
                          controller.hpAuthCheck.value = false;
                          controller.hpAuthController.text == '';
                          Get.snackbar('인증번호 오류', '인증번호가 일치하지 않습니다.');
                        }
                      },
                      child: Container(
                        width: size.width*0.2590,
                        height: size.width*0.1282,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xffFFF5F0),
                        ),
                        child: const Text('인증완료',style: TextStyle(
                            fontSize: 14,
                            color: mainColor
                        ),),
                      ),
                    )
                  ],
                ),//
                const SizedBox(height: 18,),
                Obx(()=>controller.hpAuthCheck.value ? const Text('인증완료',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700),):const SizedBox()),
                const SizedBox(
                  height: 25,
                ),
                const Text('영업지역(시,군)', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                ),),
                const SizedBox(
                  height: 9,
                ),
                GestureDetector(
                  onTap: (){
                    controller.getCityInfo(true);
                  },
                  child: Container(
                    width: size.width,
                    height:  50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xfff6f6fa)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(()=> Text(controller.city.value)),
                        const Icon(Icons.arrow_drop_down)
                      ]
                    ),
                  ),
                ),
                Obx(
                    ()=> controller.city.value == '선택해주세요'?Container():
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Text('영업지역(구)', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),),
                      const SizedBox(
                        height: 9,
                      ),
                      GestureDetector(
                        onTap: (){
                          controller.getCityInfo(false);
                        },
                        child: Container(
                          width: size.width,
                          height:  50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xfff6f6fa)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(()=> Text(controller.district.value)),
                                const Icon(Icons.arrow_drop_down)
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18,),
                TextFieldComponent(
                  text: '택시 번호', multi: false, color: Colors.black, typeNumber: false, controller: controller.taxiNumber,
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: (){
                    if(controller.hpAuthCheck.value == false){
                      Get.snackbar('인증번호 오류', '휴대폰 인증을 완료해주세요.');
                    } else if(controller.city.value == '선택해주세요'){
                      Get.snackbar('지역선택 오류', '영업지역을 선택해주세요.');
                    } else if(controller.district.value == '선택해주세요'){
                      Get.snackbar('지역선택 오류', '영업지역(구)를 선택해주세요.');
                    } else if(controller.taxiNumber.text == ''){
                      Get.snackbar('택시번호 오류', '택시번호를 입력해주세요.');
                    } else {
                      controller.imageUpload();
                    }
                  },
                  child:MainBox(text: '다음 으로',color: mainColor ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
