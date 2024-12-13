import 'package:delivery_taxi/view/useNotify/useNotifyController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/bottom/bottomNavi.dart';
import '../../global.dart';
import '../../main.dart';





class UseNotifyView extends GetView<UseNotifyController> {
  const UseNotifyView ({super.key});

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
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: Colors.black,
          unselectedLabelColor: const Color(0xffacb3bf),
          indicatorPadding: const EdgeInsets.all(0.0),
          indicatorWeight: 4.0,
          dividerColor:Colors.white,
          labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
          indicator: const ShapeDecoration(
            shape: UnderlineInputBorder(
                borderSide: BorderSide(color: mainColor, width: 2, style: BorderStyle.solid)),),
          tabs: <Widget>[
            Container(
              height: 40,
              alignment: Alignment.center,
              color: Colors.white,
              child: const Text("이용내역",style: TextStyle(fontSize: 17),),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              color: Colors.white,
              child: const Text("알림 ",style: TextStyle(fontSize: 17),),
            ),
          ],
          onTap:(i){
            controller.changeTab(i);
          },
        ),
      ),
      body: Obx(() => (controller.tabIndex.value == 0  && controller.callHistory.length != 0) || (controller.tabIndex.value != 0  && controller.notify.length != 0) ?
      RefreshIndicator(
        onRefresh: () async {
          controller.init();
        },
        child: ListView.separated(
          scrollDirection: Axis.vertical,
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
        ),
      ) : RefreshIndicator(
        onRefresh: () async {
          controller.init();
        },
        child: SingleChildScrollView(  // 스크롤 가능한 위젯으로 변경
          child: Container(
              // 스크롤을 위해 높이 설정
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height*0.2,),
                  Image.asset('images/close.png', width: size.width * 0.17),
                  Text('이용 내역이 없습니다.', style: TextStyle(fontSize: 16, color: gray500)),
                  SizedBox(height: size.height*0.5,)
                ],
              ),
            ),
          ),
        ),
      )),
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
                    Get.toNamed('/usingDetailView',arguments: controller.callHistory[index])?.then((value) {
                      if(value == true){
                        controller.init();
                      }
                    });
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
