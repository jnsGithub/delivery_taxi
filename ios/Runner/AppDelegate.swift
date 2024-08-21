import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Firebase 초기화 중복을 방지하기 위해 Firebase가 이미 초기화되었는지 확인
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    if #available(iOS 10.0, *) {
        	UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    // 알림 권한 요청
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()
        }
      } else if let error = error {
        print("알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
      }
    }


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


// // import Flutter
// // import UIKit
// //
// // @main
// // @objc class AppDelegate: FlutterAppDelegate {
// //   override func application(
// //     _ application: UIApplication,
// //     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
// //   ) -> Bool {
// //     GeneratedPluginRegistrant.register(with: self)
// //     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
// //   }
// // }
// import UIKit
// import Flutter
// import Firebase
//
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     FirebaseApp.configure()
//     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//       if granted {
//         DispatchQueue.main.async {
//           application.registerForRemoteNotifications()
//         }
//       }
//     }
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
