import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'NonMemberBottom.dart';
import 'UserSearch.dart';

// nonMemberHome 클래스는 비회원 사용자를 위한 홈 화면을 나타내는 StatelessWidget.
class nonMemberHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 화면의 너비와 높이를 가져오기 위한 변수. MediaQuery를 사용하여 현재 화면의 크기를 얻음.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Scaffold는 기본적인 화면 레이아웃을 제공하는 Flutter 위젯.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // 앱 바의 높이를 70.0으로 설정.
        child: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼을 자동으로 추가하지 않음.
          backgroundColor: Colors.white, // 앱 바의 배경색을 흰색으로 설정.
          toolbarHeight: 100, // 툴바의 높이를 100으로 설정.
          title: Text(
            'waitez', // 앱 바의 제목 텍스트를 'waitez'로 설정.
            style: TextStyle(
              color: Color(0xFF1C1C21), // 텍스트 색상을 설정.
              fontSize: 18, // 텍스트 크기를 18로 설정.
              fontFamily: 'Epilogue', // 폰트를 'Epilogue'로 설정.
              fontWeight: FontWeight.w700, // 텍스트의 굵기를 설정.
              height: 0.07, // 텍스트의 줄 간격을 설정.
              letterSpacing: -0.27, // 글자 간격을 설정.
            ),
          ), // 타이틀 설정 끝.
          centerTitle: true, // 타이틀을 앱 바의 중앙에 정렬.
          actions: [
            // 앱 바의 우측에 위치한 액션 버튼들.
            IconButton(
              onPressed: () {}, // 새로고침 아이콘이 눌렸을 때의 동작. (현재 아무 동작도 하지 않음)
              icon: Icon(Icons.refresh), // 새로고침 아이콘을 설정.
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/noti'); // 알림 아이콘을 눌렀을 때 '/noti' 라우트로 이동.
                },
                icon: Icon(Icons.notifications) // 알림 아이콘을 설정.
            )
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 모든 방향에서 16px의 패딩을 추가.
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search'); // 검색창을 눌렀을 때 '/search' 라우트로 이동.
                },
                child: Container(
                  width: screenWidth * 0.9, // 화면 너비의 90%를 사용하여 컨테이너의 너비를 설정.
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 수평으로 16px, 수직으로 12px의 패딩 추가.
                  decoration: ShapeDecoration(
                    color: Color(0xFFEDEFF2), // 배경색을 설정.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정.
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search), // 검색 아이콘을 추가.
                      SizedBox(width: 12), // 아이콘과 텍스트 사이에 12px 간격을 추가.
                      Text(
                        '검색', // '검색'이라는 텍스트를 추가.
                        style: TextStyle(
                          color: Color(0xFF3D3F49), // 텍스트 색상을 설정.
                          fontSize: 16, // 텍스트 크기를 설정.
                          fontFamily: 'Epilogue', // 폰트를 'Epilogue'로 설정.
                          fontWeight: FontWeight.w400, // 텍스트의 굵기를 설정.
                          height: 1.3, // 텍스트 줄 간격을 설정.
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // 컨테이너와 광고 배너 사이에 20px 간격을 추가.
              AdBanner(), // 광고 배너 위젯을 추가.
              SizedBox(height: 16), // 광고 배너와 카드 사이에 16px 간격을 추가.
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // 카드의 모서리를 둥글게 설정.
                ),
                elevation: 4, // 카드의 그림자 깊이를 설정.
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // 모든 방향에서 16px의 패딩을 추가.
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 자식들의 크기에 맞춰 높이를 설정.
                    crossAxisAlignment: CrossAxisAlignment.center, // 자식들을 수평으로 중앙 정렬.
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝으로 아이템들을 정렬.
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트들을 왼쪽으로 정렬.
                            children: [
                              Text(
                                '예약하기', // '예약하기' 텍스트를 추가.
                                style: TextStyle(
                                  fontSize: 20, // 텍스트 크기를 설정.
                                  fontWeight: FontWeight.bold, // 텍스트를 굵게 설정.
                                ),
                              ),
                              SizedBox(height: 4), // 두 텍스트 사이에 4px 간격을 추가.
                              Text(
                                'reservation', // 'reservation' 텍스트를 추가.
                                style: TextStyle(
                                  fontSize: 16, // 텍스트 크기를 설정.
                                  color: Colors.grey, // 텍스트 색상을 회색으로 설정.
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.event_seat, // 좌석 아이콘을 추가.
                            size: 40, // 아이콘 크기를 40으로 설정.
                            color: Colors.blue, // 아이콘 색상을 파란색으로 설정.
                          ),
                        ],
                      ),
                      SizedBox(height: 16), // 텍스트와 버튼 사이에 16px 간격을 추가.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 버튼들을 중앙에 정렬.
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.queue, color: Colors.blue), // 아이콘과 함께 버튼을 설정, 아이콘 색상을 파란색으로 설정.
                            label: Text('예약하기'), // 버튼 라벨을 '예약하기'로 설정.
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 버튼 배경색을 흰색으로 설정.
                              foregroundColor: Colors.blue, // 버튼 텍스트 색상을 파란색으로 설정.
                              side: BorderSide(color: Colors.blue), // 버튼 테두리를 파란색으로 설정.
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/search'); // 버튼을 눌렀을 때 '/search' 라우트로 이동.
                            },
                          ),
                          SizedBox(width: 16), // 두 버튼 사이에 16px 간격을 추가.
                          ElevatedButton.icon(
                            icon: Icon(Icons.list_alt, color: Colors.blue), // 아이콘과 함께 버튼을 설정, 아이콘 색상을 파란색으로 설정.
                            label: Text('대기순번'), // 버튼 라벨을 '대기순번'으로 설정.
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 버튼 배경색을 흰색으로 설정.
                              foregroundColor: Colors.blue, // 버튼 텍스트 색상을 파란색으로 설정.
                              side: BorderSide(color: Colors.blue), // 버튼 테두리를 파란색으로 설정.
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/waitingNumber'); // 버튼을 눌렀을 때 '/waitingNumber' 라우트로 이동.
                            },
                          ),
                          SizedBox(width: 16), // 마지막 버튼과 여백 사이에 16px 간격을 추가.
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // 카드와 하단 여백 사이에 20px 간격을 추가.
            ],
          ),
        ),
      ),
      bottomNavigationBar: nonMemberBottom(), // 하단 네비게이션 바를 추가.
    );
  }
}

// AdBanner 클래스는 광고 배너를 나타내는 StatelessWidget.
class AdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // 배너의 모서리를 둥글게 설정.
      ),
      elevation: 4, // 배너의 그림자 깊이를 설정.
      child: Container(
        width: double.infinity, // 배너의 너비를 화면 전체로 설정.
        height: 150, // 배너의 높이를 150으로 설정.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), // 배너의 모서리를 둥글게 설정.
          image: DecorationImage(
            image: AssetImage('assets/images/kimbab.png'), // 배너에 사용할 이미지 경로를 설정.
            fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 조절.
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10, // 텍스트를 위에서 10px 아래로 위치.
              left: 10, // 텍스트를 왼쪽에서 10px 떨어뜨려 위치.
              child: Text(
                '맛있는 김밥\n어떠신가요!', // 광고 배너에 표시될 텍스트.
                style: TextStyle(
                  color: Colors.black, // 텍스트 색상을 검정색으로 설정.
                  fontSize: 20, // 텍스트 크기를 20으로 설정.
                  fontWeight: FontWeight.bold, // 텍스트를 굵게 설정.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
