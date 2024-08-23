import 'package:flutter/material.dart';

class menuButtom extends StatelessWidget {                            // 하단 네비게이션 바를 정의하는 StatelessWidget 클래스.
  const menuButtom({super.key});                                      // 생성자, super.key는 기본 키 값을 전달.

  @override
  Widget build(BuildContext context) {                                // UI를 빌드하는 메소드.
    return BottomNavigationBar(                                       // BottomNavigationBar 위젯 반환.
      selectedItemColor: Colors.black,                                // 선택된 아이템의 텍스트 색상을 검정으로 설정.
      unselectedItemColor: Colors.black,                              // 선택되지 않은 아이템의 텍스트 색상을 검정으로 설정.
      type: BottomNavigationBarType.fixed,                            // 모든 아이템이 고정된 위치에 배치되도록 설정.
      selectedFontSize: 13,                                           // 선택된 아이템의 텍스트 크기를 13으로 설정.
      unselectedFontSize: 13,                                         // 선택되지 않은 아이템의 텍스트 크기를 13으로 설정.
      onTap: (int index) {                                             // 각 아이템이 탭되었을 때 실행되는 함수.
        switch (index) {                                              // 선택된 인덱스에 따라 다른 동작 수행.
          case 0:                                                     // 첫 번째 아이템 선택 시.
            Navigator.pushNamed(context, '/home');                    // '/home' 경로로 네비게이트.
            break;
          case 1:                                                     // 두 번째 아이템 선택 시.
            Navigator.pushNamed(context, '/favorite');                // '/favorite' 경로로 네비게이트.
            break;
          case 2:                                                     // 세 번째 아이템 선택 시.
            Navigator.pushNamed(context, '/search');                  // '/search' 경로로 네비게이트.
            break;
          case 3:                                                     // 네 번째 아이템 선택 시.
            Navigator.pushNamed(context, '/community');               // '/community' 경로로 네비게이트.
            break;
          case 4:                                                     // 다섯 번째 아이템 선택 시.
            Navigator.pushNamed(context, '/profile');                 // '/profile' 경로로 네비게이트.
            break;
          default:                                                    // 위의 경우에 해당하지 않는 경우.
        }
      },
      items: const [                                                  // BottomNavigationBar의 아이템들을 정의.
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), // 첫 번째 아이템: 홈 아이콘과 'Home' 레이블.
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'favortie'), // 두 번째 아이템: 즐겨찾기 아이콘과 'favorite' 레이블.
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'reservation'),  // 세 번째 아이템: 달력 아이콘과 'reservation' 레이블.
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'community'), // 네 번째 아이템: 그룹 아이콘과 'community' 레이블.
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: 'profile'),      // 다섯 번째 아이템: 계정 아이콘과 'profile' 레이블.
      ],
    );
  }
}
