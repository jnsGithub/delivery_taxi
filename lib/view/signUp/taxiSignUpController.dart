
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:delivery_taxi/data/myInfoData.dart';
import 'package:delivery_taxi/model/myInfo.dart';
import 'package:dotted_border/dotted_border.dart';
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
  RxString selectedOption = '개인'.obs;
  RxString city = '선택해주세요'.obs;
  RxString district = '선택해주세요'.obs;
  RxString authNum = ''.obs;

  XFile taxiImage = XFile('');
  TextEditingController taxiName = TextEditingController();
  TextEditingController taxiNumber = TextEditingController();
  TextEditingController hpAuthController = TextEditingController();
  TextEditingController hpController = TextEditingController();


  final ImagePicker picker = ImagePicker();
  // final List<String> cities = [
  //   '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시', '대전광역시', '울산광역시', '세종특별자치시',
  //   '수원시', '성남시', '의정부시', '안양시', '부천시', '광명시', '평택시', '동두천시', '안산시', '고양시', '과천시', '구리시', '남양주시', '오산시', '시흥시', '군포시', '의왕시', '하남시', '용인시', '파주시', '이천시', '안성시', '김포시', '화성시', '광주시', '양주시', '포천시', '여주시', '연천군', '가평군', '양평군',
  //   '춘천시', '원주시', '강릉시', '동해시', '태백시', '속초시', '삼척시', '홍천군', '횡성군', '영월군', '평창군', '정선군', '철원군', '화천군', '양구군', '인제군', '고성군', '양양군',
  //   '청주시', '충주시', '제천시', '보은군', '옥천군', '영동군', '증평군', '진천군', '괴산군', '음성군', '단양군',
  //   '천안시', '공주시', '보령시', '아산시', '서산시', '논산시', '계룡시', '당진시', '금산군', '부여군', '서천군', '청양군', '홍성군', '예산군', '태안군',
  //   '전주시', '군산시', '익산시', '정읍시', '남원시', '김제시', '완주군', '진안군', '무주군', '장수군', '임실군', '순창군', '고창군', '부안군',
  //   '목포시', '여수시', '순천시', '나주시', '광양시', '담양군', '곡성군', '구례군', '고흥군', '보성군', '화순군', '장흥군', '강진군', '해남군', '영암군', '무안군', '함평군', '영광군', '장성군', '완도군', '진도군', '신안군',
  //   '포항시', '경주시', '김천시', '안동시', '구미시', '영주시', '영천시', '상주시', '문경시', '경산시', '군위군', '의성군', '청송군', '영양군', '영덕군', '청도군', '고령군', '성주군', '칠곡군', '예천군', '봉화군', '울진군', '울릉군',
  //   '창원시', '진주시', '통영시', '사천시', '김해시', '밀양시', '거제시', '양산시', '의령군', '함안군', '창녕군', '고성군', '남해군', '하동군', '산청군', '함양군', '거창군', '합천군',
  //   '제주시', '서귀포시'
  // ];
  final List<String> cities =[
    '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시', '대전광역시', '울산광역시','천안시'
  ];

  final Map<String, List<String>> districts = {
    '서울특별시': ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'],
    '부산광역시': ['강서구', '금정구', '기장군', '남구', '동구', '동래구', '부산진구', '북구', '사상구', '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구'],
    '대구광역시': ['남구', '달서구', '달성군', '동구', '북구', '서구', '수성구', '중구'],
    '인천광역시': ['강화군', '계양구', '남동구', '동구', '미추홀구', '부평구', '서구', '연수구', '옹진군', '중구'],
    '광주광역시': ['광산구', '남구', '동구', '북구', '서구'],
    '대전광역시': ['대덕구', '동구', '서구', '유성구', '중구'],
    '울산광역시': ['남구', '동구', '북구', '울주군', '중구'],
    '천안시': ['동남구', '서북구'],
  };
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bottomSet();
    });
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
        type: 'taxi',
        name: taxiName.text,
        hp: hpController.text,
        address1: city.value,
        address2: district.value,
        taxiNumber: taxiNumber.text,
        taxiType: selectedOption.value,
        taxiImage: await MyInfomation().licenseUploadImage(XFile(taxiImage.path)),
        isAuth: false,
        createDate: Timestamp.now()
    );
    myInfomation.setUser(myInfo);
    update();
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
      'uid': 'thwjdgn',
      'pwd': '0843faco!@',
      'sendType': '3',
      'toNumber': hpController.text,
      'fromNumber': '01096005193',
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
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled:true,
        builder: (context){
          return GetBuilder<TaxiSignUpController>(
              builder: (controller) {
              return Container(
                padding: const EdgeInsets.only(top:40,left: 16,right: 16,bottom: 50),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          title: const Text('택시기사 회원가입'),
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
                        const Row(
                          children: [
                            Text('택시운전자격증',style: TextStyle(
                              fontSize: 18,fontWeight: FontWeight.w600,color: font2424
                            ),),
                            Text('을 업로드 해주세요',style: TextStyle(fontSize: 18,color: font2424),),
                          ],
                        ),
                        const SizedBox(height: 14,),
                        const Text('택시운전자격증명 등록'),
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
                        controller.signUpCheck.value ? const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 26,),
                            Icon(Icons.more_horiz,size: 38,),
                            SizedBox(height: 26,),
                            Text('현재 기사님의 회원가입이',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('요청되어 ',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400),),
                                Text('승인 검토중',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                                Text('입니다',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400),),
                              ],
                            ),
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
                                const Text('전체 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Checkbox(value: check1.value,activeColor: mainColor, onChanged: (value){
                                  check(1);
                                }),
                                const SizedBox(
                                  width: 250,
                                    child: Text('(필수) 정산처리를 위한 개인정보 제3자 제공 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Checkbox(value: check2.value,activeColor: mainColor, onChanged: (value){
                                  check(2);
                                }),
                                const SizedBox(
                                  width: 250,
                                    child: Text('(필수) 차량 배차를 위한 개인정보 및 위치정보 제 3자 제공 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Checkbox(value: check3.value,activeColor: mainColor, onChanged: (value){
                                  check(3);
                                }),//
                                const Text('(필수) 위치기반서비스 이용약관 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Checkbox(value: check4.value,activeColor: mainColor, onChanged: (value){
                                  check(4);
                                }),
                                const Text('(필수) 서비스 이용약관 동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Checkbox(value: check5.value,activeColor: mainColor, onChanged: (value){
                                  check(5);
                                }),
                                const Text('(필수) 개인정보 수집 및 이용동의',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: font2424),),
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
