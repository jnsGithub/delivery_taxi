import 'package:delivery_taxi/view/confirm/confirmView.dart';
import 'package:delivery_taxi/view/enter/enterView.dart';
import 'package:delivery_taxi/view/login/loginView.dart';
import 'package:delivery_taxi/view/myPage/contactUs.dart';
import 'package:delivery_taxi/view/myPage/myPageView.dart';
import 'package:delivery_taxi/view/signUp/noticeView.dart';
import 'package:delivery_taxi/view/signUp/signUpView.dart';
import 'package:delivery_taxi/view/signUp/taxiImageUploadView.dart';
import 'package:delivery_taxi/view/signUp/taxiSignUpView.dart';
import 'package:delivery_taxi/view/taxiMain/taxiAreaView.dart';
import 'package:delivery_taxi/view/taxiMain/taxiCallList.dart';
import 'package:delivery_taxi/view/taxiMain/taxiMainView.dart';
import 'package:delivery_taxi/view/useNotify/taxiNotifyView.dart';
import 'package:delivery_taxi/view/useNotify/useNotifyView.dart';
import 'package:delivery_taxi/view/userMain/userMainView.dart';
import 'package:delivery_taxi/view/usingDetail/usingDetailView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'firebase_options.dart';
import 'model/myInfo.dart';




bool isTaxiUser = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  kakao.KakaoSdk.init(nativeAppKey: 'd468c2ed0fcb419fddce6d63dd21b1c7');
  await NaverMapSdk.instance.initialize(clientId: "3ds1y6zz0h");
  await initializeDateFormatting('ko_KR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('ko', 'KR'),
      color: Colors.white,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: false,
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor:  Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400
            ), elevation:0
          )
      ),
      initialRoute: '/enterView',
      getPages: [
        GetPage(name: '/enterView', page: () => const EnterView()),
        GetPage(name: '/loginView', page: ()=> const LoginView()),
        GetPage(name: '/signUpView', page:()=> const SignUpView()),
        GetPage(name: '/noticeView', page:()=> const NoticeView()),
        GetPage(name: '/userMainView', page:()=> const UserMainView()),
        GetPage(name: '/confirmView', page:()=> const ConfirmView()),
        GetPage(name: '/useNotifyView', page: () => const UseNotifyView()),
        GetPage(name: '/usingDetailView', page: () => const UsingDetailView()),
        GetPage(name: '/myPageView', page: () => const MyPageView()),
        GetPage(name: '/contactUs', page: () => const ContactUs()),
        GetPage(name: '/taxiSignUpView', page: () => const TaxiSignUpView()),
        GetPage(name:'/taxiImageUpload',page:()=> const TaxiImageUploadView()),
        GetPage(name: '/taxiMainView', page:() => const TaxiMainView()),
        GetPage(name:'/taxiCallList',page:()=> const TaxiCallList()),
        GetPage(name: '/taxiNotifyView', page:() => const TaxiNotifyView()),
        GetPage(name: '/taxiAreaView', page: () => const TaxiAreaView()),
        // GetPage(name: '/InquiryPage', page: () => const InquiryPage()),
        // GetPage(name: '/inquiryWrite', page: () => const InquiryWrite()),
        // GetPage(name:'/storeEdit',page:()=> const StoreEdit()),
        // GetPage(name:'/shoppingCartPage',page:()=> const ShoppingCartPage()),
        // GetPage(name:'/itemManagement',page:()=> const ItemManagement()),
        // GetPage(name:'/itemDetailPage',page:()=> const ItemDetailPage()),

        // GetPage(name:'/reportList',page:()=> const ReportList()),
        // GetPage(name:'/reportWrite',page:()=> const ReportWrite()),
        // GetPage(name:'/payPageDetail',page:()=> const PayPageDetail()),
        // GetPage(name: '/customerInfoDetail', page: () => const CustomerInfoDetail()),
        // GetPage(name: '/reportRegistration', page: () => const ReportRegistration()),
        // GetPage(name: '/reportList', page: () => const ReportList()),
        // GetPage(name: '/login', page: () => const LoginView()),
      ],

    );
  }
}
