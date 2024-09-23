import 'package:delivery_taxi/view/useNotify/taxiNotifyController.dart';
import 'package:delivery_taxi/view/useNotify/useNotifyController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/bottom/bottomNavi.dart';
import '../../global.dart';
import '../../main.dart';





class TaxiNotifyView extends GetView<TaxiNotifyController> {
  const TaxiNotifyView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TaxiNotifyController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용/알림',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600
        ),),
        centerTitle: false,
        leading: Container(),
        leadingWidth: 0,
      ),
      body: Obx(() => ListView.separated(
        scrollDirection:Axis.vertical,
        shrinkWrap:true,
        itemCount:  controller.callHistory.length,
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
          );
        },
        itemBuilder: (context, index) {
          bool isDone = controller.callHistory[index].state == '배송완료';
          return callHistory(index,isDone);
        },
      ),),
      bottomNavigationBar: BottomNavi(pageIndex: 1,),
    );
  }

  callHistory<Widget> (index,isDone){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('${formatTimestamp(controller.callHistory[index].createDate)} ㆍ ',style: const TextStyle(fontSize: 16),),
                  Text(controller.callHistory[index].state, style: TextStyle(color: isDone? gray500:mainColor,fontWeight: FontWeight.w500,fontSize: 16),),
                ],
              ),
              TextButton(
                  onPressed: (){
                    Get.toNamed('/usingDetailView',arguments: controller.callHistory[index]);
                  },
                  child: const Text('상세보기 >',style:TextStyle(
                    color:gray600,
                    fontSize: 14,
                  )))
            ],
          ),

          Row(
            children: [
              const Text('출발   ', style: TextStyle(color: gray500,fontSize: 16),),
              Text(controller.callHistory[index].startingAddress, style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('도착   ', style: TextStyle(color: gray500,fontSize: 16),),
              Text(controller.callHistory[index].endingAddress, style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('금액   ', style: TextStyle(color: gray500, fontSize: 16),),
              Text(formatNumber(controller.callHistory[index].price), style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ],
          )
        ],
      ),
    );
  }
}
