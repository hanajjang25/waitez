import 'package:flutter/material.dart';                        
import 'UserBottom.dart';                                      

class communityMyPage extends StatefulWidget {                  // 커뮤니티 마이 페이지의 상태를 관리하는 StatefulWidget 클래스 선언
  const communityMyPage({super.key});                           // const 생성자를 통해 불변의 key를 받음

  @override
  State<communityMyPage> createState() => _communityMyPageState(); // 상태를 생성하는 createState 메서드 오버라이드
}

class _communityMyPageState extends State<communityMyPage> {     // 실제 상태를 관리하는 State 클래스 선언
  @override
  Widget build(BuildContext context) {                          // 위젯을 빌드하는 메서드, 화면에 그려질 UI 정의
    return Scaffold(                                            // 기본적인 페이지 레이아웃을 제공하는 Scaffold 위젯 사용
      appBar: AppBar(                                           // 상단 앱바(AppBar) 위젯 정의
        elevation: 0,                                           // 앱바의 그림자 깊이를 0으로 설정
        backgroundColor: Colors.white,                          // 앱바의 배경색을 흰색으로 설정
        leading: IconButton(                                    // 앱바의 왼쪽에 위치할 뒤로가기 버튼 정의
          icon: Icon(Icons.arrow_back, color: Colors.black),    // 뒤로가기 버튼의 아이콘과 색상 설정
          onPressed: () {                                       // 뒤로가기 버튼을 눌렀을 때 실행할 동작 정의
            Navigator.of(context).pop();                        // 현재 화면을 닫고 이전 화면으로 돌아감
          },
        ),
      ),
      body: Padding(                                            // 페이지의 내용을 패딩으로 감싸 여백을 줌
        padding: EdgeInsets.all(16),                            // 모든 방향에 16 픽셀의 여백 설정
        child: Column(                                          // 세로로 정렬된 자식 위젯들을 포함하는 Column 위젯 정의
          children: [
            SizedBox(height: 30),                               // 30픽셀 높이의 빈 공간 추가
            Container(                                          // 커뮤니티 제목을 담을 컨테이너 정의
              alignment: Alignment.centerLeft,                  // 컨테이너 내의 텍스트를 왼쪽에 정렬
              child: Text(                                      // 텍스트 위젯으로 "커뮤니티" 표시
                '커뮤니티',                                      // 텍스트 내용 설정
                style: TextStyle(                               // 텍스트 스타일 설정
                  color: Color(0xFF1C1C21),                     // 텍스트 색상 설정
                  fontSize: 18,                                 // 텍스트 크기 설정
                  fontFamily: 'Epilogue',                       // 폰트 패밀리 설정
                  fontWeight: FontWeight.w700,                  // 텍스트 굵기 설정
                  height: 1.5,                                  // 텍스트 높이 설정
                  letterSpacing: -0.27,                         // 텍스트 자간 설정
                ),
              ),
            ),
            SizedBox(height: 30),                               // 30픽셀 높이의 빈 공간 추가
            Container(                                          // 구분선을 포함하는 컨테이너 정의
                width: 500,                                     // 구분선의 너비 설정
                child: Divider(color: Colors.black, thickness: 1.0) // 검은색의 두께 1픽셀인 구분선 추가
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuButtom(),                        // 하단 네비게이션 바를 화면 하단에 배치
    );
  }
}
