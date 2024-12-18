
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:delivery_taxi/data/myInfoData.dart';
import 'package:delivery_taxi/model/myInfo.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../component/lineContainer.dart';
import '../../component/main_box.dart';
import '../../global.dart';



class TaxiSignUpController extends GetxController {

  RxBool check1 = false.obs;
  RxBool check2 = false.obs;
  RxBool check3 = false.obs;
  RxBool check4 = false.obs;
  RxBool check5 = false.obs;
  RxBool allCheckBool = false.obs;
  RxBool sendSms = false.obs;
  RxBool hpAuthCheck = false.obs;
  RxBool signUpCheck = false.obs;
  RxBool getImageCheck = false.obs;
  RxBool isUserTaxi = false.obs;
  RxString selectedOption = '개인'.obs;
  RxString city = '선택해주세요'.obs;
  RxString district = '선택해주세요'.obs;
  RxString authNum = ''.obs;
  String type = 'taxi';
  XFile taxiImage = XFile('');
  TextEditingController taxiName = TextEditingController();
  TextEditingController taxiNumber = TextEditingController();
  TextEditingController hpAuthController = TextEditingController();
  TextEditingController hpController = TextEditingController();


  final ImagePicker picker = ImagePicker();
  final List<String> cities =[
    '서울', '부산', '대구', '인천', '광주', '대전', '울산','천안시'
  ];

  final Map<String, List<String>> districts = {
    '서울': ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'],
    '부산': ['강서구', '금정구', '기장군', '남구', '동구', '동래구', '부산진구', '북구', '사상구', '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구'],
    '대구': ['남구', '달서구', '달성군', '동구', '북구', '서구', '수성구', '중구'],
    '인천': ['강화군', '계양구', '남동구', '동구', '미추홀구', '부평구', '서구', '연수구', '옹진군', '중구'],
    '광주': ['광산구', '남구', '동구', '북구', '서구'],
    '대전': ['대덕구', '동구', '서구', '유성구', '중구'],
    '울산': ['남구', '동구', '북구', '울주군', '중구'],
    '천안시': ['동남구', '서북구'],
  };
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bottomSet();
    });
    if(Get.arguments == 'userTaxi'){
      isUserTaxi.value = true;
      type = 'userTaxi';
    } else {
      isUserTaxi.value = false;
    }

  }
  @override
  void onClose(){

    super.onClose();
  }
  option(value){
    selectedOption.value = value;
  }
  getImage() async {
    taxiImage = (await picker.pickImage(source: ImageSource.gallery))!;
    getImageCheck.value = true;
    update();
  }
  signUp() async {
    signUpCheck.value = true;
    MyInfomation myInfomation = MyInfomation();

    MyInfo myInfo = MyInfo(
        documentId: uid,
        type: type,
        name: taxiName.text,
        hp: hpController.text,
        address1: city.value,
        address2: district.value,
        taxiNumber: taxiNumber.text,
        taxiType: selectedOption.value,
        taxiImage: await MyInfomation().licenseUploadImage(XFile(taxiImage.path)),
        isAuth: false,
        createDate: Timestamp.now(), fcmToken: await FirebaseMessaging.instance.getToken() ?? ''
    );
    myInfomation.setUser(myInfo);
    update();
    Get.back();
  }
  allCheck(){
    allCheckBool.value = !allCheckBool.value;
    if(allCheckBool.value){
      check1.value = true;
      check2.value = true;
      check3.value = true;
      check4.value = true;
      check5.value = true;
    } else {
      check1.value = false;
      check2.value = false;
      check3.value = false;
      check4.value = false;
      check5.value = false;
    }
  }
  check(index) {
    if (index == 1) {
      check1.value = !check1.value;
    } else if (index == 2) {
      check2.value = !check2.value;
    } else if (index == 3) {
      check3.value = !check3.value;
    } else if (index == 4) {
      check4.value = !check4.value;
    } else if (index == 5) {
      check5.value = !check5.value;
    }
    if(check1.value && check2.value && check3.value && check4.value && check5.value) {
      allCheckBool.value = true;
    } else {
      allCheckBool.value = false;
    }
  }
  void sendSMS() async{
    const String baseUrl = "http://biz.moashot.com/EXT/URLASP/mssendUTF.asp";
    var rng = Random();
    // 6자리 숫자 생성
    String randomNumber = (100000 + rng.nextInt(900000)).toString();
    authNum.value = randomNumber;
    final Map<String, String> queryParams = {
      'uid': 'lsw8089',
      'pwd': 'dltmddnr445!',
      'sendType': '3',
      'toNumber': hpController.text,
      'fromNumber': '01062088089',
      'contents': '[딜리버리티] 인증번호는 $randomNumber 입니다.'
    };


    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        sendSms.value = true;
        Get.snackbar('휴대폰인증', '전송되었습니다.');
      } else {
        sendSms.value = false;
        Get.snackbar('휴대폰인증', '전송에 실패했습니다.');
      }
    } catch (e) {
      sendSms.value = false;
      Get.snackbar('휴대폰인증', '전송에 실패했습니다.');
    }
  }
  imageUpload(){
    Size size = MediaQuery.of(Get.context!).size;
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled:true,
        builder: (context){
          return GetBuilder<TaxiSignUpController>(
              builder: (controller) {
              return Container(
                width: size.width,
                padding: const EdgeInsets.only(top:40,left: 16,right: 16,bottom: 50),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          title: Text(isUserTaxi.value ? '일반 드라이버 회원가입':'택시기사 회원가입'),
                          centerTitle: false,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: (){
                              Get.back();
                            },
                          )
                        ),
                        const Text('차량에 비치된',style: TextStyle(fontSize: 18,color: font2424),),
                        const SizedBox(height: 9,),
                        Row(
                          children: [
                            Text(isUserTaxi.value?'자동차운전면허증':'택시운전자격증',style: const TextStyle(
                              fontSize: 18,fontWeight: FontWeight.w600,color: font2424
                            ),),
                            const Text('을 업로드 해주세요',style: TextStyle(fontSize: 18,color: font2424),),
                          ],
                        ),
                        const SizedBox(height: 14,),
                        Text(isUserTaxi.value?'자동차 운전면허증등록':'택시운전자격증명 등록',style: const TextStyle(fontSize: 15,color: gray600),),
                        const SizedBox(height: 14,),
                        GestureDetector(
                          onTap: (){
                            getImage();
                          },
                          child:  DottedBorder(
                            color: gray500,//color of dotted/dash line
                            strokeWidth: 1, //thickness of dash/dots
                            dashPattern: [10,6],
                            child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                  child: controller.getImageCheck.value == false
                                      ? const Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, size: 24, color: Colors.grey),
                                        Text(
                                          '  이미지 등록하기',
                                          style: TextStyle(fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                      : Image.file(
                                    File(controller.taxiImage.path),
                                    fit: BoxFit.fill,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,),
                        SizedBox(
                            width: size.width,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('회원가입 승인 후,',style: TextStyle(color: Colors.red,fontWeight:FontWeight.w400,fontSize: 17),),
                                    Text('‘마이페이지’ ',style: TextStyle(color: Colors.red,fontWeight:FontWeight.w600,fontSize: 17),),
                                    Text('에서 ',style: TextStyle(color: Colors.red,fontWeight:FontWeight.w400,fontSize: 17),),
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('‘계좌 정보’',style: TextStyle(color: Colors.red,fontWeight:FontWeight.w600,fontSize: 17),),
                                    Text('를 등록해 주세요.',style: TextStyle(color: Colors.red,fontWeight:FontWeight.w400,fontSize: 17),),
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Text('미등록 시 이용 대금 정산에 차질이 있을 수 있습니다.',style: TextStyle(color: Colors.red,fontWeight:FontWeight.w400,fontSize: 17),textAlign: TextAlign.center,),
                              ],
                            )
                        ),
                        controller.signUpCheck.value ? const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 26,),
                            Icon(Icons.more_horiz,size: 38,),
                            SizedBox(height: 26,),
                            Text('현재 드라이버님의 회원가입이',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400),),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('요청되어 ',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400),),
                                Text('승인 검토중',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                                Text('입니다',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400),),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text('승인이 완료되면 이용하실 수 있습니다',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400),),
                          ],
                        ):Container(),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if(controller.signUpCheck.value){
                          Get.toNamed('/enterView');
                        } else {
                          saving(context);
                          controller.signUp();
                        }
                      },
                        child: MainBox(text: controller.signUpCheck.value?'홈으로':'완료', color: mainColor)
                    )
                  ],
                ),
              );
            }
          );
        }
    );
  }
  getCityInfo(isCity){
    showModalBottomSheet(
        isScrollControlled:true,
        context: Get.context!,
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20))),
        builder: (context){
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 30),
            height: 600,
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('영업지역(시,군)',style: TextStyle(
                  fontSize: 16,fontWeight: FontWeight.w600
                ),),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount:isCity? cities.length: districts[city.value]!.length,
                    itemBuilder: (context, index) {
                      return isCity? ListTile(
                        onTap: (){
                          city.value = cities[index];
                          district.value = '선택해주세요';
                          Get.back();
                        },
                        title: Text(cities[index]),
                      ): ListTile(
                        onTap: (){
                          district.value = districts[city.value]![index];
                          Get.back();
                        },
                        title: Text(districts[city.value]![index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  bottomSet(){
    showModalBottomSheet(
      isScrollControlled:true,
      enableDrag: false,
      isDismissible:false,
      context: Get.context!,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20))),
      builder: (context){
        return StatefulBuilder(
          builder: (context,setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 30),
                  child: Text('Delivery T를 이용하려면\n동의가 필요해요',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: font2424),),
                ),
                const LineContainer(),
                Obx(()=>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                            decoration: BoxDecoration(
                                border: Border.all(color: gray300),
                                borderRadius: BorderRadius.circular(6)
                            ),
                            child: Row(
                              children: [
                                Checkbox(value: allCheckBool.value,activeColor: mainColor, onChanged: (value){
                                  allCheck();
                                }),
                                GestureDetector(
                                    onTap: (){
                                      allCheck();
                                    },
                                    child: const Text('전체 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(value: check1.value,activeColor: mainColor, onChanged: (value){
                                      check(1);
                                    }),
                                    GestureDetector(
                                      onTap: (){
                                        check(1);
                                      },
                                      child: const SizedBox(
                                        width: 250,
                                          child: Text('(필수) 정산처리를 위한 개인정보 제3자 제공 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){
                                    launchUrl('https://electric-fortnight-2a5.notion.site/5e251b921e314b1996e86047776a7d64?pvs=4');
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(value: check2.value,activeColor: mainColor, onChanged: (value){
                                      check(2);
                                    }),
                                    GestureDetector(
                                      onTap: (){
                                        check(2);
                                      },
                                      child: const SizedBox(
                                        width: 250,
                                          child: Text('(필수) 차량 배차를 위한 개인정보 및 위치정보 제 3자 제공 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){
                                    launchUrl('https://electric-fortnight-2a5.notion.site/5e251b921e314b1996e86047776a7d64?pvs=4');
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(value: check3.value,activeColor: mainColor, onChanged: (value){
                                      check(3);
                                    }),
                                    GestureDetector(
                                        onTap: (){
                                          check(3);
                                        },
                                        child: const Text('(필수) 위치기반서비스 이용약관 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){
                                    launchUrl('https://electric-fortnight-2a5.notion.site/f3c540f6c48b4b0db5f779caae47b768?pvs=4');
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(value: check4.value,activeColor: mainColor, onChanged: (value){
                                      check(4);
                                    }),
                                    GestureDetector(
                                        onTap: (){
                                          check(4);
                                        },
                                        child: const Text('(필수) 서비스 이용약관 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){
                                    launchUrl('https://electric-fortnight-2a5.notion.site/d9032623fa124078832590eafad765cb?pvs=4');
                                  }, 
                                  icon: const Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(value: check5.value,activeColor: mainColor, onChanged: (value){
                                      check(5);
                                    }),
                                    GestureDetector(
                                        onTap: (){
                                          check(5);
                                        },
                                        child: const Text('(필수) 개인정보 수집 및 이용동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){
                                    launchUrl('https://electric-fortnight-2a5.notion.site/5e251b921e314b1996e86047776a7d64?pvs=4');
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios, size: 15,),color: font2424,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
                    child: GestureDetector(
                        onTap: (){
                          if(allCheckBool.value){
                            Get.back();
                          } else {
                            Get.snackbar('알림', '모든 약관에 동의해주세요');
                          }

                        },
                        child: const MainBox(text: '가입하기',color: mainColor)
                    )
                ),
              ],
            );
          }
        );
      },
    );
  }
}
