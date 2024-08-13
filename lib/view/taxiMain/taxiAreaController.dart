
import 'package:delivery_taxi/data/myInfoData.dart';
import 'package:delivery_taxi/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';



class TaxiAreaController extends GetxController {
  RxString city = '선택해주세요'.obs;
  RxString district = '선택해주세요'.obs;

  MyInfomation myInfoArea = MyInfomation();

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
  }
  @override
  void onClose(){

    super.onClose();
  }

  setArea() async {
    myInfo.address1 = city.value;
    myInfo.address2 = district.value;
    await myInfoArea.updateArea(city.value, district.value);
    Get.back();
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
}
