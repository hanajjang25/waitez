import 'package:flutter/material.dart';

class setting extends StatefulWidget {                                // 설정 화면을 나타내는 StatefulWidget 클래스
  @override
  _settingState createState() => _settingState();                    // 상태 관리 클래스 _settingState 생성
}

class _settingState extends State<setting> {                          // _settingState 클래스 정의
  bool smsAlert = false;                                              // SMS 알림 스위치 상태 변수
  bool appAlert = false;                                              // 앱 알림 스위치 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(                                                  // 화면의 기본 구조를 만드는 Scaffold 위젯
      appBar: AppBar(                                                 // 상단 앱바 설정
        title: Text('설정'),                                           // 앱바의 제목을 '설정'으로 지정
        centerTitle: true,                                            // 제목을 가운데 정렬
      ),
      body: Column(                                                   // 설정 항목들을 배치할 Column 위젯
        crossAxisAlignment: CrossAxisAlignment.start,                 // 자식 위젯을 왼쪽으로 정렬
        children: [
          Divider(),                                                  // 구분선 추가
          ListTile(                                                   // SMS 알림 설정 항목
            title: Text('SMS알림'),                                   // 제목을 'SMS알림'으로 설정
            trailing: Switch(                                         // 스위치 위젯으로 알림 켜고 끄기
              value: smsAlert,                                        // smsAlert 상태에 따라 스위치 상태 변경
              onChanged: (value) {                                    // 스위치 상태 변경 시 호출되는 콜백 함수
                setState(() {
                  smsAlert = value;                                   // smsAlert 상태를 변경
                });
              },
            ),
          ),
          Divider(),                                                  // 구분선 추가
          ListTile(                                                   // 앱 알림 설정 항목
            title: Text('앱 알림'),                                   // 제목을 '앱 알림'으로 설정
            trailing: Switch(                                         // 스위치 위젯으로 알림 켜고 끄기
              value: appAlert,                                        // appAlert 상태에 따라 스위치 상태 변경
              onChanged: (value) {                                    // 스위치 상태 변경 시 호출되는 콜백 함수
                setState(() {
                  appAlert = value;                                   // appAlert 상태를 변경
                });
              },
            ),
          ),
          Divider(),                                                  // 구분선 추가
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(                       // 하단 내비게이션 바 추가
        items: const <BottomNavigationBarItem>[                       // 내비게이션 바의 항목들 설정
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),                            // 첫 번째 아이템의 아이콘과 라벨 설정
            label: '대기 순번',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),                                // 두 번째 아이템의 아이콘과 라벨 설정
            label: '이력 조회',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),                                  // 세 번째 아이템의 아이콘과 라벨 설정
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),                               // 네 번째 아이템의 아이콘과 라벨 설정
            label: '즐겨 찾기',
          ),
        ],
      ),
    );
  }
}
