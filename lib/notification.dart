import 'package:flutter_local_notifications/flutter_local_notifications.dart';   
import 'package:shared_preferences/shared_preferences.dart';                   
import 'package:flutter/material.dart';                                          
import 'package:url_launcher/url_launcher.dart';                                 

class FlutterLocalNotification {                                                 // 로컬 알림 관리를 위한 클래스
  FlutterLocalNotification._();                                                  // 클래스의 프라이빗 생성자

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =        // Flutter 로컬 알림 플러그인 인스턴스 생성
      FlutterLocalNotificationsPlugin();

  static init() async {                                                          // 알림 초기화 함수
    const AndroidInitializationSettings androidInitializationSettings =          // 안드로이드 초기화 설정
        AndroidInitializationSettings('mipmap/ic_launcher');

    const InitializationSettings initializationSettings =                       // 초기화 설정 객체 생성
        InitializationSettings(
      android: androidInitializationSettings,
    );

    final bool? result = await flutterLocalNotificationsPlugin.initialize(       // 플러그인 초기화 및 결과 저장
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {  // 알림 클릭 시 실행될 콜백 함수 정의
        // Notification tapped logic here
      },
    );

    if (result != null && result) {                                              // 초기화 성공 여부 확인
      print('Notification initialized successfully');                            // 성공 메시지 출력
    } else {
      print('Notification initialization failed');                               // 실패 메시지 출력
    }
  }

  static Future<void> showNotification(String title, String body) async {        // 알림을 표시하는 함수
    SharedPreferences prefs = await SharedPreferences.getInstance();             // SharedPreferences 인스턴스 가져오기
    bool? appAlert = prefs.getBool('appAlert') ?? false;                         // 알림 활성화 상태 가져오기

    if (appAlert) {                                                              // 알림이 활성화된 경우
      const AndroidNotificationDetails androidNotificationDetails =              // 안드로이드 알림 세부 설정
          AndroidNotificationDetails(
        'channel_id',                                                            // 채널 ID
        'channel_name',                                                          // 채널 이름
        channelDescription: 'channel description',                               // 채널 설명
        importance: Importance.max,                                              // 알림 중요도 설정
        priority: Priority.high,                                                 // 알림 우선순위 설정
        showWhen: false,                                                         // 알림 시각 표시 여부
      );

      const NotificationDetails notificationDetails =                            // 알림 세부 설정 객체 생성
          NotificationDetails(android: androidNotificationDetails);

      try {
        await flutterLocalNotificationsPlugin.show(                              // 알림 표시
            0, title, body, notificationDetails);                                // 알림 ID, 제목, 내용, 세부 설정 전달
        print('Notification shown successfully');                                // 성공 메시지 출력
      } catch (e) {
        print('Error showing notification: $e');                                 // 오류 메시지 출력
      }
    } else {
      print("App alerts are turned off. Notification not sent.");                // 알림이 비활성화된 경우 메시지 출력
    }
  }
}

class NotificationService {                                                      // 알림 서비스를 관리하는 클래스
  static Future<void> sendSmsNotification(                                       // SMS 알림을 보내는 함수
      String message, List<String> recipients) async {                           // 메시지 내용과 수신자 목록 전달
    SharedPreferences prefs = await SharedPreferences.getInstance();             // SharedPreferences 인스턴스 가져오기
    bool smsAlert = prefs.getBool('smsAlert') ?? false;                          // SMS 알림 활성화 상태 가져오기

    if (smsAlert) {                                                              // SMS 알림이 활성화된 경우
      String _message = Uri.encodeComponent(message);                            // 메시지 내용을 URL 인코딩
      String _recipients = recipients.join(',');                                 // 수신자 목록을 쉼표로 연결
      String _url = 'sms:$_recipients?body=$_message';                           // SMS URL 생성

      if (await canLaunch(_url)) {                                               // URL 실행 가능 여부 확인
        await launch(_url);                                                      // SMS 앱을 통해 메시지 전송
      } else {
        throw 'Could not launch $_url';                                          // URL 실행 실패 시 예외 발생
      }
    } else {
      print("SMS Alert is disabled. No SMS sent.");                              // SMS 알림이 비활성화된 경우 메시지 출력
    }
  }
}
