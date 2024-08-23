import 'package:flutter/material.dart';                                         

class reservationBottom extends StatelessWidget {                               // StatelessWidget을 확장한 예약 바텀 네비게이션 클래스
  const reservationBottom({super.key});                                         // 생성자, 기본 key를 상속받음

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(                                                 // BottomNavigationBar 위젯 생성
      selectedItemColor: Colors.black,                                          // 선택된 아이템의 색상을 검은색으로 설정
      unselectedItemColor: Colors.black,                                        // 비선택된 아이템의 색상도 검은색으로 설정
      type: BottomNavigationBarType.fixed,                                      // 모든 아이템을 고정된 크기로 표시
      selectedFontSize: 13,                                                     // 선택된 아이템의 텍스트 크기를 13으로 설정
      unselectedFontSize: 13,                                                   // 비선택된 아이템의 텍스트 크기도 13으로 설정
      onTap: (int index) {                                                      // 아이템이 탭될 때 실행되는 함수
        switch (index) {                                                        // 탭된 아이템의 인덱스에 따라 분기 처리
          case 0:                                                               // 첫 번째 아이템이 탭된 경우
            Navigator.pushNamed(context, '/home');                              // '/home' 경로로 네비게이션
            break;                                                              // 분기 종료
          case 1:                                                               // 두 번째 아이템이 탭된 경우
            Navigator.pushNamed(context, '/search');                            // '/search' 경로로 네비게이션
            break;                                                              // 분기 종료
          default:                                                              // 그 외의 경우
        }
      },
      items: const [                                                            // BottomNavigationBar에 표시될 아이템들
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),         // 홈 아이콘과 'Home' 라벨
        BottomNavigationBarItem(                                                // 캘린더 아이콘과 'reservation' 라벨
            icon: Icon(Icons.calendar_month), label: 'reservation'),
      ],
    );
  }
}
