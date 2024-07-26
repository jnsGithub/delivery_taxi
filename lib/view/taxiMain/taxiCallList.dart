import 'package:delivery_taxi/component/lineContainer.dart';
import 'package:delivery_taxi/component/main_box.dart';
import 'package:delivery_taxi/global.dart';
import 'package:delivery_taxi/model/callHistory.dart';
import 'package:delivery_taxi/view/taxiMain/taxiCallListController.dart';
import 'package:delivery_taxi/view/taxiMain/taxiMainController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class TaxiCallList extends GetView<TaxiMainController> {
  const TaxiCallList ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TaxiMainController());
    return Scaffold(
      backgroundColor: gray100,
      appBar: AppBar(
        backgroundColor: gray100,
        title: const Text('콜 리스트',style: TextStyle(
          fontSize: 18,fontWeight: FontWeight.w500,color: font2424
        ),),
        centerTitle: true,
      ),
      body:  ListView.builder(
        scrollDirection:Axis.vertical,
        shrinkWrap:true,
        itemCount: controller.callHistory.length,
        itemBuilder: (context, index) {

          CallHistory item = controller.callHistory[index];
          String typeEng = item.selectedOption;
          bool isDone = item.state != '호출중';
          String type =typeEng =='small'? '소형': typeEng == 'medium'? '중형':'대형';
          return isDone?Container():Container(
            margin: const EdgeInsets.only(top: 22,left: 16,right: 16),
            padding: const EdgeInsets.symmetric(vertical: 26,horizontal: 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 114,
                      child: Text('출발지 주소',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                    Expanded(
                      child: Text(item.startingAddress,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
                const SizedBox(height: 18,),
                Row(
                  children: [
                    const SizedBox(
                      width: 114,
                      child: Text('도착지',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                    Expanded(
                      child: Text(item.endingAddress,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
                const SizedBox(height: 18,),
                Row(
                  children: [
                    const SizedBox(
                      width: 114,
                      child: Text('화물크기',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                    Expanded(
                      child: Text(type,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
                const LineContainer(),
                Row(
                  children: [
                    const SizedBox(
                      width: 114,
                      child: Text('요금',style: TextStyle(color: gray600,fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                    Expanded(
                      child: Text(formatNumber(item.price),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    controller.call(size,item,true);
                  },
                    child: const MainBox(text: '콜 잡기', color: mainColor)
                )
              ],
            )
          );
        },
      ),
    );
  }
}
