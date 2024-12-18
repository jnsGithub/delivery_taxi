import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:delivery_taxi/component/main_box.dart';
import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/view/userMain/userMainController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/bottom/bottomNavi.dart';
import '../../component/textfield.dart';
import '../../main.dart';





class UserMainView extends GetView<UserMainController> {
  const UserMainView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => UserMainController());
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Image(image: AssetImage('images/local_taxi.png'),width: 21, height: 21,),
              const SizedBox(width: 10,),
              const Text('Delivery T',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: gray500
              ),),
              myInfo.hp == 'admin' ? Obx(() => Container(
                width: 150,
                height: 50,
                child: DropdownButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  menuMaxHeight: 300,
                  isExpanded: true,
                  dropdownColor: const Color(0xffF7F7FA),
                  itemHeight: 50,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  hint: const Text(
                    "유저타입",
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontFamily: 'nanumRegular'
                    ),
                  ),
                  value: controller.inquiryType.value,
                  onChanged: (String? newValue){
                    if (newValue != null) {
                      controller.inquiryType.value = newValue;

                      if(controller.inquiryType.value == '일반유저') {
                        isTaxiUser = false;
                        myInfo.type = 'customer';
                        if(Get.currentRoute != '/userMainView') Get.back();
                      }
                      else{
                        isTaxiUser = true;
                        myInfo.type = 'taxi';
                        Get.toNamed('/taxiMainView');
                      }
                    }
                  },
                  items: controller.inquiryTypeList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              ) : Container(),
            ],
          ),
          centerTitle: false,
          leadingWidth: 0,
          leading: Container(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const Text('출발지',style: TextStyle(
                  fontSize: 22,fontWeight: FontWeight.w600,color:font3030
                ),),
                const SizedBox(height: 18,),
                const Text('주소',style: TextStyle(
                    fontSize: 16,fontWeight: FontWeight.w500,color:font3030
                ),),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    controller.bottomSheet(context,true);
                  },
                  child: Obx(()=>
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  width: size.width*0.6333,
                                  height: size.width*0.1282,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: const Color(0xfff6f6fa)),
                                  child: Text(controller.startingAddress.value,style: const TextStyle(
                                      fontSize: 15,
                                      color:Colors.black
                                  ),)
                              ),
                              Container(
                                width: size.width*0.2590,
                                height: size.width*0.1282,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: mainColor,
                                ),
                                child: const Text('주소 검색',style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Container(
                            width: size.width,
                            height: size.width*0.1282,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xfff6f6fa)),
                            child: TextField(
                              controller: controller.startingAddressDetailController,
                              focusNode: controller.startAddressDetail,
                              decoration: const InputDecoration(
                                hintText: '상세주소를 입력하세요 (ex. 101호 101호)',
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xffAEAEB2)
                                ),
                                border: InputBorder.none, // 밑줄 없애기
                                contentPadding: EdgeInsets.symmetric(horizontal: 16), // TextField 내부의 패딩 적용
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:1.5,color: mainColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                const SizedBox(height: 18,),
                TextFieldComponent(
                 text: '이름', multi: false, color: Colors.black, typeNumber: false, controller: controller.startingName,
                ),
                const SizedBox(height: 18,),
                TextFieldComponent(
                  text: '연락처', multi: false, color: Colors.black, typeNumber: false, controller: controller.startingHp,
                ),
                const LineContainer(),
                const Text('도착지',style: TextStyle(
                    fontSize: 22,fontWeight: FontWeight.w600,color:font3030
                ),),
                const SizedBox(height: 18,),
                const Text('주소',style: TextStyle(
                    fontSize: 16,fontWeight: FontWeight.w500,color:font3030
                ),),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    controller.bottomSheet(context,false);

                  },
                  child: Obx(()=>
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  width: size.width*0.6333,
                                  height: size.width*0.1282,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: const Color(0xfff6f6fa)),
                                  child: Text(controller.endingAddress.value,style: const TextStyle(
                                      fontSize: 15,
                                      color:Colors.black
                                  ),)
                              ),
                              Container(
                                width: size.width*0.2590,
                                height: size.width*0.1282,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: mainColor,
                                ),
                                child: const Text('주소 검색',style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Container(
                            width: size.width,
                            height: size.width*0.1282,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xfff6f6fa)),
                            child: TextField(
                              controller: controller.endingAddressDetailController,
                              focusNode: controller.endAddressDetail,
                              decoration: const InputDecoration(
                                hintText: '상세주소를 입력하세요 (ex. 101호 101호)',
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xffAEAEB2)
                                ),
                                border: InputBorder.none, // 밑줄 없애기
                                contentPadding: EdgeInsets.symmetric(horizontal: 16), // TextField 내부의 패딩 적용
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:1.5,color: mainColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                const SizedBox(height: 18,),
                TextFieldComponent(
                  text: '이름', multi: false, color: Colors.black, typeNumber: false, controller: controller.endingName,
                ),
                const SizedBox(height: 18,),
                TextFieldComponent(
                  text: '연락처', multi: false, color: Colors.black, typeNumber: false, controller: controller.endingHp,
                ),
                const LineContainer(),
                const Text('물품 정보',style: TextStyle(
                  fontSize: 18,fontWeight: FontWeight.w500
                ),),
                controller.radioBox('small','소형','가로+세로+높이의 합 80cm, 2KG 이하'),
                controller.radioBox('medium','중형','가로+세로+높이의 합 100cm, 5KG 이하'),
                controller.radioBox('large','대형','가로+세로+높이의 합 140cm, 20KG 이하'),
                const LineContainer(),
                const Row(
                  children: [
                    Text('배송 유의사항', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                    ),),
                    Text(' (선택)', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: gray500
                    ),),
                  ],
                ),
                const SizedBox(
                  height: 9,
                ),
                Container(
                  width: 358,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xfff6f6fa)),
                  child: TextField(
                    controller: controller.caution,
                    decoration:   const InputDecoration(
                      hintStyle: TextStyle(fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffAEAEB2)),
                      border: InputBorder.none,
                      // 밑줄 없애기
                      contentPadding:EdgeInsets.only(left: 20,top:0),
                      // TextField 내부의 패딩 적용
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: mainColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('어웨이크'),
                const SizedBox(height: 10 ,),
                const Text('대표 이승욱 | 사업자 등록번호 111-46-02010',style: TextStyle(
                  fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff757575)
                ),),
                const SizedBox(height: 10 ,),
                const Text('충청남도 천안시 서북구 불당36길 63, 304호',style: TextStyle(
                    fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff757575)
                ),),
                const SizedBox(height: 10 ,),
                const Text('고객센터 070-8065-0624 | 통신판매업신고 2024-충남천안-1783호',style: TextStyle(
                    fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff757575)
                ),),
                const SizedBox(height: 10 ,),
                const Text('이메일 deliveryt445@gmail.com',style: TextStyle(
                    fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff757575)
                ),),
                const SizedBox(height: 20,),
                GestureDetector(onTap: (){controller.callTaxi();},child: const MainBox(text: '다음으로',color: mainColor,)),
                const SizedBox(height: 60,),
              ]
            ),
          ),
        ),
        bottomNavigationBar: BottomNavi(pageIndex: 0,),
      ),
    );
  }
}
