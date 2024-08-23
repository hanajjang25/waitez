import 'package:flutter/material.dart';

// nonMemberBottom 위젯은 비회원 사용자를 위한 하단 네비게이션 바를 나타내는 StatelessWidget.
class nonMemberBottom extends StatelessWidget {
  // 생성자에서 super.key를 호출하여 부모 클래스의 생성자를 호출.
  const nonMemberBottom({super.key});

  @override
  Widget build(BuildContext context) {
    // 이 StatelessWidget의 UI를 빌드하는 메소드.
    return BottomNavigationBar(
      selectedItemColor: Colors.black,                                 // 선택된 아이템의 아이콘 및 텍스트 색상을 검정으로 설정.
      unselectedItemColor: Colors.black,                               // 선택되지 않은 아이템의 아이콘 및 텍스트 색상을 검정으로 설정.
      type: BottomNavigationBarType.fixed,                             // 네비게이션 바 타입을 고정형으로 설정하여 아이템의 개수가 많아도 동일한 간격을 유지.
      selectedFontSize: 13,                                            // 선택된 아이템의 텍스트 크기를 13으로 설정.
      unselectedFontSize: 13,                                          // 선택되지 않은 아이템의 텍스트 크기를 13으로 설정. 선택된 아이템과 비선택된 아이템의 텍스트 크기를 동일하게 유지.
      
      // 아이템이 탭될 때 호출되는 콜백 함수. 인덱스를 통해 어떤 아이템이 선택되었는지 확인.
      onTap: (int index) {
        switch (index) {
          case 0:                                                      // 첫 번째 아이템 (Home) 이 선택된 경우.
            Navigator.pushNamed(context, '/nonMemberHome');            // '/nonMemberHome' 경로로 이동.
            break;
          case 1:                                                      // 두 번째 아이템 (Reservation) 이 선택된 경우.
            Navigator.pushNamed(context, '/search');                   // '/search' 경로로 이동.
            break;
          default:
        }
      },
      
      // BottomNavigationBar의 각 아이템들을 정의.
      items: const [
        // Home 아이템을 정의. 아이콘으로 홈 아이콘을 사용하고, 라벨로 'Home'을 설정.
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        // Reservation 아이템을 정의. 아이콘으로 달력 아이콘을 사용하고, 라벨로 'reservation'을 설정.
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'reservation'),
      ],
    );
  }
}
