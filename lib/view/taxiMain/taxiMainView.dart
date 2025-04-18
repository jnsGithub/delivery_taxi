import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_taxi/component/main_box.dart';
import 'package:delivery_taxi/model/callHistory.dart';
import 'package:delivery_taxi/view/taxiMain/taxiMainController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/bottom/bottomNavi.dart';
import '../../component/formatterString.dart';
import '../../component/lineContainer.dart';
import '../../global.dart';





class TaxiMainView extends GetView<TaxiMainController> {
  const TaxiMainView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TaxiMainController());
    return PopScope(
      canPop: false,
      onPopInvoked: (d){},
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: gray100,
          appBar: AppBar(
            backgroundColor: gray100,
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
                    value: controller.inquiryType.value.isEmpty
                        ? null
                        : controller.inquiryType.value,
                    onChanged: (String? newValue){
                      if (newValue != null) {
                        controller.inquiryType.value = newValue;
                        if(controller.inquiryType.value == '일반유저') {
                          myInfo.type = 'customer';
                          Get.toNamed('/userMainView');
                        }
                        else{
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(()=>
                    GestureDetector(
                      onTap: (){
                        if(!controller.delivery.value){
                          controller.isDone.value = !controller.isDone.value;
                        }
                      },
                        child: MainBox(text:controller.isDone.value? '출근 (배정 ON)':'퇴근 (배정 OFF)', color: controller.isDone.value?mainColor:gray700)
                    ),
                  ),
                  Obx(()=>
                  controller.nowPay.value?confirm(size):Container()
                  ),
                  const SizedBox(height: 18,),
                  Obx(()=> controller.nowPay.value? Container():
                    controller.isDone.value?readyToCall(size):
                    StreamBuilder<Map<String, dynamic>>(
                      stream: controller.getLatestDocumentStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Container();
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Container();
                        } else {
                          var data = snapshot.data!;
                          CallHistory callHistory = CallHistory.fromMap(data);
                          bool check1 = callHistory.startingAddress.contains(myInfo.address1);
                          bool check2 = callHistory.startingAddress.contains(myInfo.address2);
                          if(snapshot.data!['taxiDocumentId'] == myInfo.documentId && snapshot.data!['state'] != '호출중' && snapshot.data!['state'] != '배송완료'){
                            controller.getLastCall(callHistory);
                          }
                          if(snapshot.data!['state'] == '호출중' && check1 && check2){
                            if(!controller.newCall.value){
                              controller.changeItem(callHistory);
                            }
                          } else if(snapshot.data!['state'] != '호출중' && snapshot.data!['taxiDocumentId'] != myInfo.documentId ) {
                            controller.newCall.value = false;
                            controller.lastCallItem = CallHistory(startingPostcode: '', startingAddress: '', startingAddressDetail: '',startingName: '', startingHp: '', endingPostcode: '', endingAddress: '', endingAddressDetail: '', endingName: '', endingHp: '', selectedOption: '', caution: '',billingKey: '', price: 0, userDocumentId: '', paymentType: '', state: '', createDate: Timestamp.now(), documentId: '', taxiDocumentId: '',);
                          }

                          return Obx(() => controller.delivery.value
                              ? deliveryWidget(size,controller.lastCallItem)
                              : controller.newCall.value
                              ? gotCall(size,controller.lastCallItem)
                              : readyToCall(size));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32,),
                  Obx(()=>
                  controller.delivery.value ?Container():GestureDetector(
                      onTap: (){
                        if(!controller.isDone.value){
                          controller.getList();
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call,size: 24,color: mainColor,),
                          SizedBox(width: 14,),
                          Text('콜 리스트',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: gray600),)
                        ],
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
                  const Text('고객센터 070-8065-0624 | 통신판매업신고 : 2024-충남천안-1783호',style: TextStyle(
                      fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff757575)
                  ),),
                  const SizedBox(height: 10 ,),
                  const Text('이메일 deliveryt445@gmail.com',style: TextStyle(
                      fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff757575)
                  ),),
                  const SizedBox(height: 60,),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavi(pageIndex: 0,),
        ),
      ),
    );
  }
  Widget readyToCall(size){
    return  Container(
      width: size.width,
      height: size.width*1.0256,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: Colors.black
      ),
      child: GestureDetector(
        onTap: (){
          Get.toNamed('/taxiAreaView');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('콜 대기중',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: size.width*0.8,
              height: 53,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: mainColor,width: 1)
              ),
              child: Text('${myInfo.address1} ${myInfo.address2} >',style: const TextStyle(fontSize: 20,color: mainColor),),
            )
          ],
        ),
      ),
    );
  }
  Widget gotCall(size,CallHistory item){
    String typeEng = item.selectedOption;
    String type =typeEng =='small'? '소형': typeEng == 'medium'? '중형':'대형';
    return Container(
      width: size.width,
      height: size.width*1.0256,
      padding: const EdgeInsets.only(bottom: 26),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('물품 $type',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                const SizedBox(height: 24,),
                Text(item.startingAddress,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                const SizedBox(height: 24,),
                const Icon(Icons.keyboard_arrow_down,size: 40,color: gray300,),
                const SizedBox(height: 24,),
                Text(item.endingAddress,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),

              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  controller.cancelCall(size);
                },
                child: Container(
                  width: size.width*0.4103,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: gray100
                  ),
                  child: const Text('거절하기',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: gray600),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  controller.call(size,item,false);
                },
                child: Container(
                  width: size.width*0.4103,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: mainColor
                  ),
                  child: const Text('콜 잡기',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget confirm(size) {
    return GetBuilder<TaxiMainController>(
        builder: (controller) {
          return Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  color: Colors.white
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text('운행 금액 ${myInfo.type == 'userTaxi'?'':'입력'}', style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),),
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
                      readOnly:  myInfo.type == 'userTaxi',
                      controller: controller.price,
                      keyboardType:  TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                      style: const TextStyle(
                          fontSize: 22,fontWeight: FontWeight.w500
                      ),
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
                  GestureDetector(
                      onTap: (){
                        if(controller.price.text == '' || controller.price.text == '0') {
                          Get.snackbar('결제 요청 실패', '결제 금액을 확인해주세요');
                        }
                        else{
                          controller.changeState(size,true);
                        }
                      },
                      child: const MainBox(text: '결제 요청하기', color: mainColor)
                  ),
                  myInfo.type == 'userTaxi'?Column(
                    children: [
                      const SizedBox(height: 30,),
                      const Text('(※ 산정 요금 기준 : 네이버지도 경로 택시요금)',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xffF10000)),),
                    ],
                  ):Container(),
                  const SizedBox(height: 50,),
                ],
              )
          );
        }
    );
  }
  Widget deliveryWidget(size,CallHistory item) {
    String typeEng = item.selectedOption;
    String type =typeEng =='small'? '소형': typeEng == 'medium'? '중형':'대형';
    return GetBuilder<TaxiMainController>(
      builder: (controller) {
        bool isDone = item.state == '배송완료';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              color: Colors.white
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('출발지 정보',style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),),
                  Text('물품 | $type',style:const TextStyle(fontSize: 17),)
                ],
              ),
              const SizedBox(height: 18,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 114,
                    child: Text('출발지 주소',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Expanded(
                    child: Text('${item.startingAddress} ${item.startingAddressDetail}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              const SizedBox(height: 18,),
              Row(
                children: [
                  const SizedBox(
                    width: 114,
                    child: Text('이름',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Expanded(
                    child: Text(item.startingName,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              const SizedBox(height: 18,),
              Row(
                children: [
                  const SizedBox(
                    width: 114,
                    child: Text('전화번호',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Expanded(
                    child: Text(item.startingHp,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              const LineContainer(),
              const Text('도착지 정보',style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),),
              const SizedBox(height: 18,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 114,
                    child: Text('출발지 주소',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Expanded(
                    child: Text('${item.endingAddress} ${item.endingAddressDetail}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              const SizedBox(height: 18,),
              Row(
                children: [
                  const SizedBox(
                    width: 114,
                    child: Text('이름',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Expanded(
                    child: Text(item.endingName,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              const SizedBox(height: 18,),
              Row(
                children: [
                  const SizedBox(
                    width: 114,
                    child: Text('전화번호',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Expanded(
                    child: Text(item.endingHp,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              const LineContainer(),
              const Text('물건 종류',style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),),
              const SizedBox(height: 18,),
              SizedBox(
                  width: size.width,
                  child: Text(
                    item.caution
                    , style: const TextStyle(fontSize:17,fontWeight: FontWeight.w500,color: gray600),)
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  controller.changeState(size,false);
                },
                  child: MainBox(text: item.state=='배정완료'?'배송 시작 (물품 수령 완료)':'배송 완료 (물품 전달 완료)', color: mainColor)
              )
            ],
          ),
        );
      }
    );
  }
}
