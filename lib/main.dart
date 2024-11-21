import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:delivery_taxi/data/myInfoData.dart';
import 'package:delivery_taxi/data/socialLogin.dart';
import 'package:delivery_taxi/view/confirm/confirmView.dart';
import 'package:delivery_taxi/view/enter/enterView.dart';
import 'package:delivery_taxi/view/login/loginView.dart';
import 'package:delivery_taxi/view/login/nomalLoginPage.dart';
import 'package:delivery_taxi/view/myPage/contactUs.dart';
import 'package:delivery_taxi/view/myPage/myPageView.dart';
import 'package:delivery_taxi/view/myPage/taxiAccountView.dart';
import 'package:delivery_taxi/view/signUp/noticeView.dart';
import 'package:delivery_taxi/view/signUp/signUpView.dart';
import 'package:delivery_taxi/view/signUp/taxiImageUploadView.dart';
import 'package:delivery_taxi/view/signUp/taxiSignUpView.dart';
import 'package:delivery_taxi/view/taxiMain/taxiAreaView.dart';
import 'package:delivery_taxi/view/taxiMain/taxiCallList.dart';
import 'package:delivery_taxi/view/taxiMain/taxiMainView.dart';
import 'package:delivery_taxi/view/useNotify/taxiNotifyView.dart';
import 'package:delivery_taxi/view/useNotify/useNotifyController.dart';
import 'package:delivery_taxi/view/useNotify/useNotifyView.dart';
import 'package:delivery_taxi/view/userMain/userMainView.dart';
import 'package:delivery_taxi/view/usingDetail/usingDetailView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'firebase_options.dart';
import 'global.dart';
import 'model/myInfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

bool isLogin = false;
bool isTaxiUser = false;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future setFcmToken(String token) async{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  await _db.collection('users').doc(uid).update({
    'fcmToken': token
  });
}
// Future<dynamic> _backGround(RemoteMessage message) async{
//   print(message.data );
//   print('여기까진 백그라운드sdfasdfasdfsadfsadfsadfasdfdsafadsfdassfsaf');
//   // FirebaseMessaging.onBackgroundMessage((message) async {
//   //   print("onBackgroundMessage: $message");
//   //   var data = jsonDecode(message.data['data']);
//   //   print('여기까진 백그라운드');
//   //   if(message.data['page'] == 'notify'){
//   //     Get.toNamed('/useNotifyView');
//   //   }
//   // });
// }


void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  kakao.KakaoSdk.init(nativeAppKey: 'ebec32eed582eeb5ca7e8bf6ee868a13');
  await NaverMapSdk.instance.initialize(clientId: "3ds1y6zz0h");
  await initializeDateFormatting('ko_KR', null);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  if(_auth.currentUser != null){
    if(await SocialLogin().accountCheck(_auth.currentUser!.uid)){
      SocialLogin().accountCheck(_auth.currentUser!.uid);
      uid = _auth.currentUser!.uid;
      myInfo =  await MyInfomation().getUser();
      // Fcm Token 발급
      if(FirebaseFirestore.instance.collection('users').doc(uid).get() != null) {
        FirebaseMessaging.instance.getToken().then((value) {
          print('token : $value');
          setFcmToken(value ?? '');
        });
      }
      print('메인 호출시 불러들이는 uid : $uid');
      if(myInfo.documentId != ''){
        isTaxiUser = myInfo.type == 'taxi' ? true : false;
        isLogin = true;
      }
    }
  }

  if(await Permission.notification.isGranted) {
    print('권한이 허용되어 있습니다.');
  } else {
    Permission.notification.request();
    print('권한이 허용되어 있지 않습니다.');
  }

  // final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/ic_notification');
  final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      // iOS에서 알림을 클릭했을 때 실행할 동작을 정의합니다.
    },
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  try{
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      print(message.data);
      print('data : ${message.data['page']}');
      print('여기까진 리슨');
      if(message.data['page'] == 'notify'){
        flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            const NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
              android: AndroidNotificationDetails(
                '안녕하세요',
                '딜리버리 택시입니다.',
                importance: Importance.max,
                priority: Priority.high,
              ),
            )
        );
        flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (payload) async{
          if(Get.currentRoute == '/useNotifyView'){
            Get.find<UseNotifyController>().init();
          } else {
            Get.toNamed('/useNotifyView');
          }
        });
      }
    });




    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('ffpfhpfhpfhpfhdpfhdphfdphfdphfpdhfpdhfasldbvlkasdnvl할ㅇ라ㅣㄴ어라ㅣㄴ얼');
      if(message.data['page'] == 'notify'){
        if(Get.currentRoute == '/useNotifyView'){
          Get.find<UseNotifyController>().init();
        } else {
          Get.toNamed('/useNotifyView');
        }
      }
    });
  } catch(e){
    print(e);
  }
  await Future.delayed(const Duration(seconds: 5));
  FlutterNativeSplash.remove();
  if(_auth.currentUser != null) {
    isLogin = true;
    print('메인 호출시 불러들이는 uid : $uid');
  }

  myInfo =  await MyInfomation().getUser();
  print(myInfo.type);
  isTaxiUser = myInfo.type == 'taxi' ? true : false;

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
      initialRoute:!isLogin? '/enterView': isTaxiUser? '/taxiMainView':'/userMainView',
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
        GetPage(name: '/taxiAccountView', page: () => const TaxiAccountView()),
        GetPage(name: '/nomalLoginView', page: () => const NomalLoginPage()),
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
