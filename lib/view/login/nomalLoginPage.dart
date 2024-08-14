import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/textfield.dart';
import '../../data/myInfoData.dart';
import '../../global.dart';
import '../../model/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'loginExgam.dart';

class NomalLoginPage extends StatelessWidget {
  const NomalLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => NomalLoginPage());
    MyInfomation myInfomation = Get.put(MyInfomation());
    TextEditingController idController = TextEditingController();
    TextEditingController pwController = TextEditingController();
    LoginExgam login = LoginExgam();
    return Scaffold(
      appBar: AppBar(
        title: const Text('일반 로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              TextFieldComponent(text: '아이디',controller: idController, multi: false, color: Colors.black, typeNumber: false,),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text('비밀번호', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),),
                  const SizedBox(
                    height: 9,
                  ),
                  Container(
                    width: 358,
                    height:  50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xfff6f6fa)),
                    child: TextField(
                      obscureText: true,
                      controller: pwController,
                      maxLines: 1,
                      decoration:   InputDecoration(
                        hintStyle: TextStyle(fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffAEAEB2)),
                        border: InputBorder.none,
                        // 밑줄 없애기
                        contentPadding:EdgeInsets.only(left: 20,top: 0),
                        // TextField 내부의 패딩 적용
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: mainColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextButton(
                  onPressed: () async{
                    print('ㅎㅇ');
                    if(await login.loginCheck(idController.text, pwController.text)){
                      Get.toNamed('/userMainView');
                    }
                    else{
                      Get.snackbar('로그인 실패', '아이디와 비밀번호를 확인해주세요');
                    }
                  },
                  child: Text('로그인')
              )
            ],
          )
        ),
      ),
    );
  }
}
