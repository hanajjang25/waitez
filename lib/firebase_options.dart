import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;                  // 플랫폼 관련 상수들을 가져옴

class DefaultFirebaseOptions {                                // DefaultFirebaseOptions 클래스 정의
  static FirebaseOptions get currentPlatform {                // 현재 플랫폼에 따른 FirebaseOptions 반환
    if (kIsWeb) {                                             // 만약 웹 플랫폼이라면
      return web;                                             // 웹용 FirebaseOptions 반환
    }
    switch (defaultTargetPlatform) {                          // 플랫폼에 따라 분기 처리
      case TargetPlatform.android:                            // 안드로이드인 경우
        return android;                                       // 안드로이드용 FirebaseOptions 반환
      case TargetPlatform.iOS:                                // iOS인 경우
        return ios;                                           // iOS용 FirebaseOptions 반환
      case TargetPlatform.macOS:                              // macOS인 경우
        return macos;                                         // macOS용 FirebaseOptions 반환
      case TargetPlatform.windows:                            // 윈도우인 경우
        throw UnsupportedError(                               // 오류를 발생시켜 지원되지 않는다는 것을 알림
          'DefaultFirebaseOptions have not been configured for windows - '  // 오류 메시지: 윈도우용 설정 없음
          'you can reconfigure this by running the FlutterFire CLI again.', // FlutterFire CLI를 다시 실행하여 설정할 수 있음
        );
      case TargetPlatform.linux:                              // 리눅스인 경우
        throw UnsupportedError(                               // 오류를 발생시켜 지원되지 않는다는 것을 알림
          'DefaultFirebaseOptions have not been configured for linux - '  // 오류 메시지: 리눅스용 설정 없음
          'you can reconfigure this by running the FlutterFire CLI again.', // FlutterFire CLI를 다시 실행하여 설정할 수 있음
        );
      default:                                                // 그 외의 플랫폼인 경우
        throw UnsupportedError(                               // 오류를 발생시켜 지원되지 않는다는 것을 알림
          'DefaultFirebaseOptions are not supported for this platform.',  // 오류 메시지: 이 플랫폼은 지원되지 않음
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(         // 웹 플랫폼용 FirebaseOptions 정의
    apiKey: 'AIzaSyCL2p5aFu6A7_VfEMpnYd63HtnY5OLde2c',        // 웹용 API 키
    appId: '1:924566005196:web:92b0b25585a71aefabe969',       // 웹용 앱 ID
    messagingSenderId: '924566005196',                        // 메시징 발신자 ID
    projectId: 'waitez-39bfc',                                // Firebase 프로젝트 ID
    authDomain: 'waitez-39bfc.firebaseapp.com',               // 인증 도메인
    storageBucket: 'waitez-39bfc.appspot.com',                // 스토리지 버킷
    measurementId: 'G-BX8HMNTVS4',                            // 측정 ID
  );

  static const FirebaseOptions android = FirebaseOptions(     // 안드로이드 플랫폼용 FirebaseOptions 정의
    apiKey: 'AIzaSyANwdKJdYovhhc3yPGGiye7yXFwA6QSZ68',        // 안드로이드용 API 키
    appId: '1:924566005196:android:3acf1d05a88ff670abe969',   // 안드로이드용 앱 ID
    messagingSenderId: '924566005196',                        // 메시징 발신자 ID
    projectId: 'waitez-39bfc',                                // Firebase 프로젝트 ID
    storageBucket: 'waitez-39bfc.appspot.com',                // 스토리지 버킷
  );

  static const FirebaseOptions ios = FirebaseOptions(         // iOS 플랫폼용 FirebaseOptions 정의
    apiKey: 'AIzaSyDcYLAxC8TtPD61p0iVbzMxlappHH8dN3w',        // iOS용 API 키
    appId: '1:924566005196:ios:16abb097811561c6abe969',       // iOS용 앱 ID
    messagingSenderId: '924566005196',                        // 메시징 발신자 ID
    projectId: 'waitez-39bfc',                                // Firebase 프로젝트 ID
    storageBucket: 'waitez-39bfc.appspot.com',                // 스토리지 버킷
    iosBundleId: 'com.example.waitez',                        // iOS 번들 ID
  );

  static const FirebaseOptions macos = FirebaseOptions(       // macOS 플랫폼용 FirebaseOptions 정의
    apiKey: 'AIzaSyDcYLAxC8TtPD61p0iVbzMxlappHH8dN3w',        // macOS용 API 키
    appId: '1:924566005196:ios:dafe6b67441cb85dabe969',       // macOS용 앱 ID (iOS와 동일)
    messagingSenderId: '924566005196',                        // 메시징 발신자 ID
    projectId: 'waitez-39bfc',                                // Firebase 프로젝트 ID
    storageBucket: 'waitez-39bfc.appspot.com',                // 스토리지 버킷
    iosBundleId: 'com.example.waitez.RunnerTests',            // macOS 번들 ID (테스트용)
  );
}
