import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UserBottom.dart';
import 'UserSearch.dart';
import 'notification.dart';

class home extends StatelessWidget {                                  // 홈 화면을 정의하는 StatelessWidget 클래스.
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;            // 화면 너비를 가져옴.
    return Scaffold(                                                  // 화면의 기본 구조를 제공하는 Scaffold 위젯.
      appBar: PreferredSize(                                          // AppBar의 크기를 조정하기 위해 PreferredSize 사용.
        preferredSize: Size.fromHeight(70.0),                        // AppBar의 높이를 70으로 설정.
        child: AppBar(                                                // 상단 앱바 정의.
          backgroundColor: Colors.white,                              // 앱바의 배경색을 흰색으로 설정.
          toolbarHeight: 80,                                          // 툴바 높이를 80으로 설정.
          automaticallyImplyLeading: false,                           // 기본 뒤로가기 버튼을 숨김.
          title: Text(                                                // 앱바의 제목을 설정.
            'waitez',
            style: TextStyle(
              color: Color(0xFF1C1C21),                               // 텍스트 색상을 설정.
              fontSize: 18,                                           // 텍스트 크기를 설정.
              fontFamily: 'Epilogue',                                 // 텍스트 폰트를 설정.
              fontWeight: FontWeight.w700,                            // 텍스트 굵기를 설정.
              height: 0.07,                                           // 텍스트의 줄 높이를 설정.
              letterSpacing: -0.27,                                   // 글자 사이의 간격을 설정.
            ),
          ),
          centerTitle: true,                                          // 타이틀 텍스트를 가운데로 정렬.
          actions: [                                                  // 앱바 오른쪽에 배치될 아이콘 버튼들.
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),  // 새로고침 버튼, 현재는 동작하지 않음.
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/noti');              // 알림 화면으로 이동.
                },
                icon: Icon(Icons.notifications))                      // 알림 아이콘.
          ],
        ),
      ),
      body: SingleChildScrollView(                                    // 본문을 스크롤 가능하게 설정.
        child: Center(                                                // 본문을 중앙에 배치.
          child: Padding(                                             // 패딩 추가.
            padding: const EdgeInsets.all(16.0),                      // 모든 방향에 16px의 패딩 추가.
            child: Column(                                            // 세로로 위젯을 배치하는 컬럼.
              children: [
                GestureDetector(                                       // 터치 이벤트를 감지하기 위한 위젯.
                  onTap: () {
                    Navigator.pushNamed(context, '/search');          // 검색 화면으로 이동.
                  },
                  child: Container(                                   // 검색 버튼의 스타일 설정.
                    width: screenWidth * 0.9,                         // 버튼 너비를 화면의 90%로 설정.
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),                // 패딩 설정.
                    decoration: ShapeDecoration(
                      color: Color(0xFFEDEFF2),                       // 배경색 설정.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),      // 모서리를 둥글게 설정.
                      ),
                    ),
                    child: Row(                                       // 아이콘과 텍스트를 가로로 배치.
                      children: [
                        Icon(Icons.search),                           // 검색 아이콘.
                        SizedBox(width: 12),                          // 아이콘과 텍스트 사이에 12px의 간격 추가.
                        Text(
                          '검색',                                      // 검색 텍스트.
                          style: TextStyle(
                            color: Color(0xFF3D3F49),                 // 텍스트 색상 설정.
                            fontSize: 16,                             // 텍스트 크기 설정.
                            fontFamily: 'Epilogue',                   // 폰트 설정.
                            fontWeight: FontWeight.w400,              // 텍스트 굵기 설정.
                            height: 1.3,                              // 텍스트 줄 높이 설정.
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),                                 // 검색 버튼과 배너 사이의 간격을 20px로 설정.
                AdBanner(),                                           // 광고 배너 위젯 추가.
                SizedBox(height: 20),                                 // 배너와 카드 사이의 간격을 20px로 설정.
                Card(                                                 // 예약하기 카드 생성.
                  color: Colors.blue[50],                             // 카드의 배경색을 연한 파란색으로 설정.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),        // 모서리를 둥글게 설정.
                  ),
                  elevation: 4,                                       // 카드의 그림자 깊이를 4로 설정.
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),              // 모든 방향에 16px의 패딩 추가.
                    child: Column(
                      mainAxisSize: MainAxisSize.min,                 // 자식 위젯들의 크기에 맞춰 크기 조정.
                      crossAxisAlignment: CrossAxisAlignment.center,  // 자식 위젯들을 가운데 정렬.
                      children: [
                        Row(                                          // 아이콘과 텍스트를 가로로 배치.
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 텍스트를 양 끝에 배치.
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬.
                              children: [
                                Text(
                                  '예약하기',                           // 예약하기 텍스트.
                                  style: TextStyle(
                                    fontSize: 20,                      // 텍스트 크기를 20으로 설정.
                                    fontWeight: FontWeight.bold,       // 텍스트 굵기를 볼드로 설정.
                                  ),
                                ),
                                SizedBox(height: 4),                   // 텍스트 사이에 4px 간격 추가.
                                Text(
                                  'reservation',                      // 예약하기의 영문 텍스트.
                                  style: TextStyle(
                                    fontSize: 16,                      // 텍스트 크기를 16으로 설정.
                                    color: Colors.grey,                // 텍스트 색상을 회색으로 설정.
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.restaurant,                       // 레스토랑 아이콘.
                              size: 40,                               // 아이콘 크기를 40으로 설정.
                              color: Colors.blue,                     // 아이콘 색상을 파란색으로 설정.
                            ),
                          ],
                        ),
                        SizedBox(height: 16),                         // 텍스트와 버튼 사이의 간격을 16px로 설정.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 버튼들을 가운데 정렬.
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.queue, color: Colors.blue), // 예약하기 아이콘.
                              label: Text('예약하기'),                    // 예약하기 버튼 텍스트.
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,         // 버튼 배경색을 흰색으로 설정.
                                foregroundColor: Colors.blue,          // 버튼 텍스트 색상을 파란색으로 설정.
                                side: BorderSide(color: Colors.blue),  // 버튼 테두리를 파란색으로 설정.
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/search'); // 검색 화면으로 이동.
                              },
                            ),
                            SizedBox(width: 16),                      // 두 버튼 사이에 16px 간격 추가.
                            ElevatedButton.icon(
                              icon: Icon(Icons.list_alt, color: Colors.blue), // 대기순번 아이콘.
                              label: Text('대기순번'),                   // 대기순번 버튼 텍스트.
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,         // 버튼 배경색을 흰색으로 설정.
                                foregroundColor: Colors.blue,          // 버튼 텍스트 색상을 파란색으로 설정.
                                side: BorderSide(color: Colors.blue),  // 버튼 테두리를 파란색으로 설정.
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/waitingNumber'); // 대기 순번 화면으로 이동.
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),                                 // 카드와 카드 사이의 간격을 20px로 설정.
                Row(
                  children: [
                    Expanded(                                         // 가로로 확장되는 카드 위젯.
                      child: Card(
                        color: Colors.blue[50],                       // 카드의 배경색을 연한 파란색으로 설정.
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),  // 모서리를 둥글게 설정.
                        ),
                        elevation: 4,                                 // 카드의 그림자 깊이를 4로 설정.
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),        // 모든 방향에 16px의 패딩 추가.
                          child: Column(
                            mainAxisSize: MainAxisSize.min,           // 자식 위젯들의 크기에 맞춰 크기 조정.
                            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬.
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝에 배치.
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬.
                                    children: [
                                      Text(
                                        '이력조회',                    // 이력조회 텍스트.
                                        style: TextStyle(
                                          fontSize: 20,                // 텍스트 크기를 20으로 설정.
                                          fontWeight: FontWeight.bold, // 텍스트 굵기를 볼드로 설정.
                                        ),
                                      ),
                                      SizedBox(height: 4),             // 텍스트 사이에 4px 간격 추가.
                                      Text(
                                        'history',                    // 이력조회 영문 텍스트.
                                        style: TextStyle(
                                          fontSize: 16,                // 텍스트 크기를 16으로 설정.
                                          color: Colors.grey,          // 텍스트 색상을 회색으로 설정.
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.view_list,                  // 목록 아이콘.
                                    size: 40,                         // 아이콘 크기를 40으로 설정.
                                    color: Colors.blue,               // 아이콘 색상을 파란색으로 설정.
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),                   // 텍스트와 버튼 사이의 간격을 16px로 설정.
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center, // 버튼을 가운데 정렬.
                                children: [
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.queue, color: Colors.blue), // 이력조회 아이콘.
                                    label: Text('이력조회'),              // 이력조회 버튼 텍스트.
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,   // 버튼 배경색을 흰색으로 설정.
                                      foregroundColor: Colors.blue,    // 버튼 텍스트 색상을 파란색으로 설정.
                                      side: BorderSide(color: Colors.blue), // 버튼 테두리를 파란색으로 설정.
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/historyList'); // 이력조회 화면으로 이동.
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),                              // 두 카드 사이에 10px 간격 추가.
                    Expanded(
                      child: Card(
                        color: Colors.blue[50],                       // 카드의 배경색을 연한 파란색으로 설정.
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),  // 모서리를 둥글게 설정.
                        ),
                        elevation: 4,                                 // 카드의 그림자 깊이를 4로 설정.
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),        // 모든 방향에 16px의 패딩 추가.
                          child: Column(
                            mainAxisSize: MainAxisSize.min,           // 자식 위젯들의 크기에 맞춰 크기 조정.
                            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬.
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝에 배치.
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬.
                                    children: [
                                      Text(
                                        '즐겨찾기',                   // 즐겨찾기 텍스트.
                                        style: TextStyle(
                                          fontSize: 20,                // 텍스트 크기를 20으로 설정.
                                          fontWeight: FontWeight.bold, // 텍스트 굵기를 볼드로 설정.
                                        ),
                                      ),
                                      SizedBox(height: 4),             // 텍스트 사이에 4px 간격 추가.
                                      Text(
                                        'favorite',                   // 즐겨찾기 영문 텍스트.
                                        style: TextStyle(
                                          fontSize: 16,                // 텍스트 크기를 16으로 설정.
                                          color: Colors.grey,          // 텍스트 색상을 회색으로 설정.
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.star_outline,               // 즐겨찾기 아이콘.
                                    size: 40,                         // 아이콘 크기를 40으로 설정.
                                    color: Colors.blue,               // 아이콘 색상을 파란색으로 설정.
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),                   // 텍스트와 버튼 사이의 간격을 16px로 설정.
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center, // 버튼을 가운데 정렬.
                                children: [
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.queue, color: Colors.blue), // 즐겨찾기 아이콘.
                                    label: Text('즐겨찾기'),              // 즐겨찾기 버튼 텍스트.
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,   // 버튼 배경색을 흰색으로 설정.
                                      foregroundColor: Colors.blue,    // 버튼 텍스트 색상을 파란색으로 설정.
                                      side: BorderSide(color: Colors.blue), // 버튼 테두리를 파란색으로 설정.
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/favorite'); // 즐겨찾기 화면으로 이동.
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),                                 // 카드와 카드 사이의 간격을 16px로 설정.
                Card(                                                 // 커뮤니티 카드 생성.
                  color: Colors.blue[50],                             // 카드의 배경색을 연한 파란색으로 설정.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),        // 모서리를 둥글게 설정.
                  ),
                  elevation: 4,                                       // 카드의 그림자 깊이를 4로 설정.
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),              // 모든 방향에 16px의 패딩 추가.
                    child: Column(
                      mainAxisSize: MainAxisSize.min,                 // 자식 위젯들의 크기에 맞춰 크기 조정.
                      crossAxisAlignment: CrossAxisAlignment.center,  // 자식 위젯들을 가운데 정렬.
                      children: [
                        Row(                                          // 아이콘과 텍스트를 가로로 배치.
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 텍스트를 양 끝에 배치.
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬.
                              children: [
                                Text(
                                  '커뮤니티',                          // 커뮤니티 텍스트.
                                  style: TextStyle(
                                    fontSize: 20,                      // 텍스트 크기를 20으로 설정.
                                    fontWeight: FontWeight.bold,       // 텍스트 굵기를 볼드로 설정.
                                  ),
                                ),
                                SizedBox(height: 4),                   // 텍스트 사이에 4px 간격 추가.
                                Text(
                                  'community',                        // 커뮤니티 영문 텍스트.
                                  style: TextStyle(
                                    fontSize: 16,                      // 텍스트 크기를 16으로 설정.
                                    color: Colors.grey,                // 텍스트 색상을 회색으로 설정.
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.people_alt,                       // 커뮤니티 아이콘.
                              size: 40,                               // 아이콘 크기를 40으로 설정.
                              color: Colors.blue,                     // 아이콘 색상을 파란색으로 설정.
                            ),
                          ],
                        ),
                        SizedBox(height: 16),                         // 텍스트와 버튼 사이의 간격을 16px로 설정.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 버튼들을 가운데 정렬.
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.queue, color: Colors.blue), // 커뮤니티 버튼 아이콘.
                              label: Text('커뮤니티'),                  // 커뮤니티 버튼 텍스트.
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,         // 버튼 배경색을 흰색으로 설정.
                                foregroundColor: Colors.blue,          // 버튼 텍스트 색상을 파란색으로 설정.
                                side: BorderSide(color: Colors.blue),  // 버튼 테두리를 파란색으로 설정.
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/community'); // 커뮤니티 화면으로 이동.
                              },
                            ),
                            SizedBox(width: 16),                      // 두 버튼 사이에 16px 간격 추가.
                            ElevatedButton.icon(
                              icon: Icon(Icons.list_alt, color: Colors.blue), // 글쓰기 버튼 아이콘.
                              label: Text('글쓰기'),                    // 글쓰기 버튼 텍스트.
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,         // 버튼 배경색을 흰색으로 설정.
                                foregroundColor: Colors.blue,          // 버튼 텍스트 색상을 파란색으로 설정.
                                side: BorderSide(color: Colors.blue),  // 버튼 테두리를 파란색으로 설정.
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/communityWrite'); // 글쓰기 화면으로 이동.
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: menuButtom(),                              // 하단 네비게이션 바를 추가.
    );
  }
}

class AdBanner extends StatelessWidget {                              // 광고 배너를 정의하는 StatelessWidget 클래스.
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),                    // 배너의 모서리를 둥글게 설정.
      ),
      elevation: 4,                                                   // 배너의 그림자 깊이를 4로 설정.
      child: Container(
        width: double.infinity,                                       // 배너 너비를 화면 전체로 설정.
        height: 150,                                                  // 배너 높이를 150으로 설정.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),                  // 배너의 모서리를 둥글게 설정.
          image: DecorationImage(
            image: AssetImage('assets/images/kimbab.png'),            // 배너 이미지 경로.
            fit: BoxFit.cover,                                        // 이미지가 배너를 덮도록 설정.
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,                                                 // 텍스트 위치를 위에서 10px 아래로 설정.
              left: 10,                                                // 텍스트 위치를 왼쪽에서 10px 떨어지게 설정.
              child: Text(
                '맛있는 김밥\n어떠신가요!',                               // 배너 텍스트.
                style: TextStyle(
                  color: Colors.black,                                 // 텍스트 색상을 검정색으로 설정.
                  fontSize: 20,                                        // 텍스트 크기를 20으로 설정.
                  fontWeight: FontWeight.bold,                         // 텍스트 굵기를 볼드로 설정.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
