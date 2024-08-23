import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class noti extends StatefulWidget {                                            // noti라는 StatefulWidget 정의
  const noti({super.key});                                                     // 기본 생성자

  @override
  State<noti> createState() => _NotiState();                                   // 상태 객체 생성
}

class _NotiState extends State<noti> {                                         // noti의 상태 클래스 정의
  bool smsAlert = false;                                                       // SMS 알림 상태를 저장할 변수
  bool appAlert = false;                                                       // 앱 알림 상태를 저장할 변수
  int noShowCount = 0;                                                         // 불참 횟수를 저장할 변수

  @override
  void initState() {                                                           // 상태 초기화 메서드
    super.initState();                                                         // 상위 클래스의 initState 호출
    _loadPreferences();                                                        // 저장된 알림 설정 로드
    _fetchNoShowCount();                                                       // 불참 횟수 로드
  }

  @override
  void dispose() {                                                             // 위젯이 소멸될 때 호출되는 메서드
    super.dispose();                                                           // 상위 클래스의 dispose 호출
  }

  void _loadPreferences() async {                                              // 저장된 알림 설정을 로드하는 메서드
    SharedPreferences prefs = await SharedPreferences.getInstance();           // SharedPreferences 인스턴스 가져오기
    if (!mounted) return;                                                      // 위젯이 마운트되지 않았으면 리턴
    setState(() {                                                              // 상태 업데이트
      smsAlert = prefs.getBool('smsAlert') ?? false;                           // SMS 알림 설정 로드, 기본값은 false
      appAlert = prefs.getBool('appAlert') ?? false;                           // 앱 알림 설정 로드, 기본값은 false
    });
  }

  void _savePreference(String key, bool value) async {                         // 알림 설정을 저장하는 메서드
    SharedPreferences prefs = await SharedPreferences.getInstance();           // SharedPreferences 인스턴스 가져오기
    await prefs.setBool(key, value);                                           // 설정값 저장
  }

  void _toggleAppAlert() {                                                     // 앱 알림 설정을 토글하는 메서드
    if (!mounted) return;                                                      // 위젯이 마운트되지 않았으면 리턴
    setState(() {                                                              // 상태 업데이트
      appAlert = !appAlert;                                                    // 앱 알림 상태 토글
      _savePreference('appAlert', appAlert);                                   // 저장된 설정값 업데이트
      debugPrint("App Alert: $appAlert");                                      // 디버깅용 출력
    });
  }

  void _toggleSmsAlert() {                                                     // SMS 알림 설정을 토글하는 메서드
    if (!mounted) return;                                                      // 위젯이 마운트되지 않았으면 리턴
    setState(() {                                                              // 상태 업데이트
      smsAlert = !smsAlert;                                                    // SMS 알림 상태 토글
      _savePreference('smsAlert', smsAlert);                                   // 저장된 설정값 업데이트
      debugPrint("SMS Alert: $smsAlert");                                      // 디버깅용 출력
    });
  }

  Future<void> _fetchNoShowCount() async {                                     // Firestore에서 불참 횟수를 가져오는 메서드
    try {
      User? user = FirebaseAuth.instance.currentUser;                          // 현재 로그인된 사용자 가져오기
      if (user != null) {                                                      // 사용자가 존재할 경우
        String email = user.email!;                                            // 사용자 이메일 가져오기
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)                                  // 이메일로 사용자 데이터베이스 쿼리
            .limit(1)
            .get();

        if (userSnapshot.docs.isNotEmpty) {                                    // 사용자가 존재할 경우
          var userData = userSnapshot.docs.first.data() as Map<String, dynamic>; // 사용자 데이터 가져오기
          setState(() {                                                        // 상태 업데이트
            noShowCount = userData['noShowCount'] ?? 0;                        // 불참 횟수 가져오기, 기본값은 0
            noShowCount = (noShowCount) % 4;                                   // 불참 횟수를 4로 나눈 나머지로 설정
          });
        }
      }
    } catch (e) {                                                              // 오류 발생 시
      print('Error fetching no-show count: $e');                               // 오류 출력
    }
  }

  @override
  Widget build(BuildContext context) {                                         // UI 빌드 메서드
    return Scaffold(
      appBar: AppBar(                                                          // 상단 앱 바 설정
        title: Text('알림'),                                                   // 앱 바 제목 설정
      ),
      body: Column(                                                            // 세로 방향으로 위젯 배치
        children: [
          Divider(),                                                           // 구분선
          ListTile(                                                            // SMS 알림 설정 타일
            title: Text('SMS알림'),                                            // 타일 제목
            trailing: Switch(                                                  // 타일의 끝에 스위치 추가
              value: smsAlert,                                                 // 스위치의 현재 값
              onChanged: (value) {                                             // 값 변경 시 호출되는 콜백
                _toggleSmsAlert();                                             // SMS 알림 토글 메서드 호출
              },
            ),
          ),
          Divider(),                                                           // 구분선
          ListTile(                                                            // 앱 알림 설정 타일
            title: Text('앱 알림'),                                            // 타일 제목
            trailing: Switch(                                                  // 타일의 끝에 스위치 추가
              value: appAlert,                                                 // 스위치의 현재 값
              onChanged: (value) {                                             // 값 변경 시 호출되는 콜백
                _toggleAppAlert();                                             // 앱 알림 토글 메서드 호출
              },
            ),
          ),
          Divider(),                                                           // 구분선
          SizedBox(height: 20),                                                // 간격 추가
          Align(
            alignment: Alignment.centerLeft,                                   // 왼쪽 정렬
            child: Row(children: [
              SizedBox(width: 15),                                              // 간격 추가
              Text(
                '불참횟수',                                                     // 불참횟수 텍스트
                style: TextStyle(
                  color: Color(0xFF1C1C21),                                     // 텍스트 색상 설정
                  fontSize: 18,                                                 // 텍스트 크기 설정
                  fontFamily: 'Epilogue',                                       // 폰트 설정
                  fontWeight: FontWeight.w700,                                  // 텍스트 굵기 설정
                ),
              ),
            ]),
          ),
          SizedBox(height: 10),                                                 // 간격 추가
          Divider(color: Colors.black, thickness: 2.0),                         // 두꺼운 구분선 추가
          SizedBox(height: 50),                                                 // 간격 추가
          Text(
            '$noShowCount번',                                                   // 불참 횟수 표시
            style: TextStyle(
              color: Color(0xFF1C1C21),                                         // 텍스트 색상 설정
              fontSize: 18,                                                     // 텍스트 크기 설정
              fontFamily: 'Epilogue',                                           // 폰트 설정
              fontWeight: FontWeight.w700,                                      // 텍스트 굵기 설정
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(                               // 플로팅 액션 버튼 추가
        onPressed: _toggleAppAlert,                                             // 앱 알림 토글 메서드 호출
        child: Icon(
            appAlert ? Icons.notifications_active : Icons.notifications_off),  // 현재 앱 알림 상태에 따라 아이콘 설정
      ),
    );
  }
}
