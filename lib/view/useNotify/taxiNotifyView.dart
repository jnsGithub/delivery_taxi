import 'package:delivery_taxi/view/useNotify/useNotifyController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/bottom/bottomNavi.dart';
import '../../global.dart';
import '../../main.dart';





class TaxiNotifyView extends GetView<UseNotifyController> {
  const TaxiNotifyView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => UseNotifyController());
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
        itemCount: controller.tabIndex.value == 0? controller.callHistory.length:controller. notify.length,
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
          );
        },
        itemBuilder: (context, index) {
          bool isDone = false ;
          if(controller.tabIndex.value == 0 )isDone = controller.callHistory[index].state == '배송완료';
          return controller.tabIndex.value == 0 ? callHistory(index,isDone):notify(index);
        },
      ),),
      bottomNavigationBar: BottomNavi(pageIndex: 1,),
    );
  }
  notify<Widget> (index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.notify[index].title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            SizedBox(height: 8,),
            Text(controller.notify[index].content,style: TextStyle(fontSize: 16,color: gray600,height: 1.5),textAlign: TextAlign.start),
            SizedBox(height: 8,),
            controller.notify[index].pay == 0?Container():
            Text('이용요금 : ${formatNumber(controller.notify[index].pay)}',style: TextStyle(fontSize: 16,color: Color(0xffF10000)),),
          ],
        )
    );
  }
  callHistory<Widget> (index,isDone){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('${formatTimestamp(controller.callHistory[index].createDate)} ㆍ ',style: TextStyle(fontSize: 16),),
                  Text(controller.callHistory[index].state,style: TextStyle(color: isDone? gray500:mainColor,fontWeight: FontWeight.w500,fontSize: 16),),
                ],
              ),
              TextButton(
                  onPressed: (){
                    Get.toNamed('/usingDetailView',arguments: controller.callHistory[index]);
                  },
                  child: Text('상세보기 >',style:TextStyle(
                    color:gray600,
                    fontSize: 14,
                  )))
            ],
          ),

          Row(
            children: [
              Text('출발   ',style: TextStyle(color: gray500,fontSize: 16),),
              Text(controller.callHistory[index].startingAddress,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('도착   ',style: TextStyle(color: gray500,fontSize: 16),),
              Text(controller.callHistory[index].endingAddress,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('금액   ',style: TextStyle(color: gray500,fontSize: 16),),
              Text(formatNumber(controller.callHistory[index].price),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ],
          )
        ],
      ),
    );
  }
}
