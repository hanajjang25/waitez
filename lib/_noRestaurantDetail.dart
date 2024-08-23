import 'package:flutter/material.dart';                     
import 'package:waitez/MemberFavorite.dart';                
import 'package:waitez/UserSearch.dart';                   

class restaurantDetailPage extends StatelessWidget {         // 레스토랑 상세 페이지를 위한 StatelessWidget 정의
  final SearchDetails restaurant;                            // 레스토랑 정보를 저장하는 변수

  const restaurantDetailPage({Key? key, required this.restaurant}) 
      : super(key: key);                                     // 생성자에서 레스토랑 정보를 받아옴

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;    // 화면 너비 가져오기
    final screenHeight = MediaQuery.of(context).size.height;  // 화면 높이 가져오기
    return Scaffold(                                         // Scaffold 위젯으로 페이지 구성
      appBar: AppBar(                                        // 상단 앱바 설정
        title: Text(
          restaurant.name,                                   // 앱바 타이틀로 레스토랑 이름 표시
          style: TextStyle(
            color: Color(0xFF1C1C21),                        // 텍스트 색상 설정
            fontSize: 18,                                    // 텍스트 크기 설정
            fontFamily: 'Epilogue',                          // 폰트 패밀리 설정
            fontWeight: FontWeight.w700,                     // 텍스트 굵기 설정
            height: 0.07,                                    // 텍스트 높이 설정
            letterSpacing: -0.27,                            // 텍스트 간격 설정
          ),
        ),
        backgroundColor: Colors.white,                       // 앱바 배경색 설정
        foregroundColor: Colors.black,                       // 앱바 텍스트 색상 설정
      ),
      body: SingleChildScrollView(                           // 스크롤이 가능한 화면 구성
        child: Column(
          children: [
            Container(
              width: screenWidth,                            // 컨테이너 너비를 화면 너비로 설정
              height: screenHeight,                          // 컨테이너 높이를 화면 높이로 설정
              decoration: BoxDecoration(color: Colors.white),// 컨테이너 배경색 설정
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,            // 자식의 크기에 맞게 최소 크기로 설정
                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                  children: [
                    Container(
                      width: 390,                            // 컨테이너 너비 설정
                      height: 925,                           // 컨테이너 높이 설정
                      clipBehavior: Clip.antiAlias,          // 컨테이너 경계 클리핑 설정
                      decoration: BoxDecoration(color: Colors.white),// 컨테이너 배경색 설정
                      child: Column(
                        mainAxisSize: MainAxisSize.min,      // 자식의 크기에 맞게 최소 크기로 설정
                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                        children: [
                          Container(
                            width: 390,                      // 컨테이너 너비 설정
                            height: 250,                     // 컨테이너 높이 설정
                            child: Column(
                              mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                              mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                              crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                              children: [
                                Container(
                                  width: 390,                // 컨테이너 너비 설정
                                  height: 221,               // 컨테이너 높이 설정
                                  clipBehavior: Clip.antiAlias,// 컨테이너 경계 클리핑 설정
                                  decoration: BoxDecoration(
                                    image: DecorationImage(  // 배경 이미지를 설정
                                      image: NetworkImage(restaurant.photoUrl),// 네트워크 이미지 가져오기
                                      fit: BoxFit.fill,      // 이미지를 컨테이너에 맞게 채움
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 390,                      // 컨테이너 너비 설정
                            height: 59.50,                   // 컨테이너 높이 설정
                            padding: const EdgeInsets.only(
                              top: 20,                       // 상단 여백 설정
                              left: 16,                      // 왼쪽 여백 설정
                              right: 16,                     // 오른쪽 여백 설정
                              bottom: 12,                    // 하단 여백 설정
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                              mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                              crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                              children: [
                                Container(
                                  width: 151.09,             // 컨테이너 너비 설정
                                  height: 27.50,             // 컨테이너 높이 설정
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                    mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                    crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                    children: [
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                          mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                          crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                          children: [
                                            Text(
                                              restaurant.name,           // 레스토랑 이름 표시
                                              style: TextStyle(
                                                color: Color(0xFF1C1C21),// 텍스트 색상 설정
                                                fontSize: 22,            // 텍스트 크기 설정
                                                fontFamily: 'Epilogue',  // 폰트 패밀리 설정
                                                fontWeight: FontWeight.w700,// 텍스트 굵기 설정
                                                height: 0.06,            // 텍스트 높이 설정
                                                letterSpacing: -0.33,    // 텍스트 간격 설정
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 390,                      // 컨테이너 너비 설정
                            height: 72,                      // 컨테이너 높이 설정
                            decoration: BoxDecoration(color: Colors.white),// 컨테이너 배경색 설정
                            child: Stack(                    // 자식들을 겹치게 배치
                              children: [
                                Positioned(
                                  left: 15,                  // 왼쪽에서 15만큼 떨어진 위치에 배치
                                  top: 0.50,                 // 위에서 0.5만큼 떨어진 위치에 배치
                                  child: Container(
                                    width: 235.53,           // 컨테이너 너비 설정
                                    height: 72,              // 컨테이너 높이 설정
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                      mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                      crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                      children: [
                                        Container(
                                          width: 147.53,       // 컨테이너 너비 설정
                                          height: 66,          // 컨테이너 높이 설정
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                            mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                                            crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                            children: [
                                              Container(
                                                width: 147.53,   // 컨테이너 너비 설정
                                                height: 24,      // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 24,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            '주소',       // 주소 텍스트 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF1C1C21),// 텍스트 색상 설정
                                                              fontSize: 16, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w500,// 텍스트 굵기 설정
                                                              height: 0.09,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 147.53,  // 컨테이너 너비 설정
                                                height: 21,     // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 21,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            restaurant.address,// 레스토랑 주소 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF3D3F49),// 텍스트 색상 설정
                                                              fontSize: 14, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w400,// 텍스트 굵기 설정
                                                              height: 0.11,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 280,                // 왼쪽에서 280만큼 떨어진 위치에 배치
                                  top: 21.50,               // 위에서 21.5만큼 떨어진 위치에 배치
                                  child: Container(
                                    width: 95,              // 컨테이너 너비 설정
                                    height: 24,             // 컨테이너 높이 설정
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                      mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                      crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                      children: [
                                        Container(width: 95.20, height: 24),// 빈 컨테이너 추가
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 390,                    // 컨테이너 너비 설정
                            height: 72,                    // 컨테이너 높이 설정
                            decoration: BoxDecoration(color: Colors.white),// 컨테이너 배경색 설정
                            child: Stack(                  // 자식들을 겹치게 배치
                              children: [
                                Positioned(
                                  left: 15,                // 왼쪽에서 15만큼 떨어진 위치에 배치
                                  top: 0.50,               // 위에서 0.5만큼 떨어진 위치에 배치
                                  child: Container(
                                    width: 235.53,         // 컨테이너 너비 설정
                                    height: 72,            // 컨테이너 높이 설정
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                      mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                      crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                      children: [
                                        Container(
                                          width: 147.53,     // 컨테이너 너비 설정
                                          height: 66,        // 컨테이너 높이 설정
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                            mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                                            crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                            children: [
                                              Container(
                                                width: 147.53, // 컨테이너 너비 설정
                                                height: 24,    // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 24,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            '영업시간', // 영업시간 텍스트 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF1C1C21),// 텍스트 색상 설정
                                                              fontSize: 16, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w500,// 텍스트 굵기 설정
                                                              height: 0.09,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 147.53, // 컨테이너 너비 설정
                                                height: 21,    // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 21,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            restaurant.businessHours,// 영업시간 정보 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF3D3F49),// 텍스트 색상 설정
                                                              fontSize: 14, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w400,// 텍스트 굵기 설정
                                                              height: 0.11,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 280,               // 왼쪽에서 280만큼 떨어진 위치에 배치
                                  top: 21.50,              // 위에서 21.5만큼 떨어진 위치에 배치
                                  child: Container(
                                    width: 95,             // 컨테이너 너비 설정
                                    height: 24,            // 컨테이너 높이 설정
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                      mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                      crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                      children: [
                                        Container(width: 95.20, height: 24),// 빈 컨테이너 추가
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 390,                  // 컨테이너 너비 설정
                            height: 59.50,               // 컨테이너 높이 설정
                            padding: const EdgeInsets.only(
                              top: 20,                   // 상단 여백 설정
                              left: 16,                  // 왼쪽 여백 설정
                              right: 16,                 // 오른쪽 여백 설정
                              bottom: 12,                // 하단 여백 설정
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                              mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                              crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                              children: [
                                Container(
                                  width: 151.09,           // 컨테이너 너비 설정
                                  height: 27.50,           // 컨테이너 높이 설정
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                    mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                    crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                    children: [
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                          mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                          crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                          children: [
                                            Text(
                                              'MENU',           // 메뉴 텍스트 표시
                                              style: TextStyle(
                                                color: Color(0xFF1C1C21),// 텍스트 색상 설정
                                                fontSize: 22,   // 텍스트 크기 설정
                                                fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                fontWeight: FontWeight.w700,// 텍스트 굵기 설정
                                                height: 0.06,   // 텍스트 높이 설정
                                                letterSpacing: -0.33,// 텍스트 간격 설정
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 390,                  // 컨테이너 너비 설정
                            height: 96,                  // 컨테이너 높이 설정
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),// 좌우 및 상하 여백 설정
                            decoration: BoxDecoration(color: Colors.white),// 컨테이너 배경색 설정
                            child: Row(
                              mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                              mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                              crossAxisAlignment: CrossAxisAlignment.center,// 자식들을 중앙에 정렬
                              children: [
                                Expanded(
                                  child: Container(
                                    height: double.infinity,// 컨테이너 높이를 부모 크기에 맞게 설정
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                      mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                      crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                      children: [
                                        Container(
                                          width: 72,       // 컨테이너 너비 설정
                                          height: 72,      // 컨테이너 높이 설정
                                          clipBehavior: Clip.antiAlias,// 컨테이너 경계 클리핑 설정
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("https://via.placeholder.com/72x72"),// 메뉴 이미지 설정
                                              fit: BoxFit.fill, // 이미지를 컨테이너에 맞게 채움
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8)),// 모서리를 둥글게 설정
                                          ),
                                        ),
                                        const SizedBox(width: 16), // 자식들 사이의 간격 설정
                                        Container(
                                          width: 270,     // 컨테이너 너비 설정
                                          height: 66,     // 컨테이너 높이 설정
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                            mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                                            crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                            children: [
                                              Container(
                                                width: 270, // 컨테이너 너비 설정
                                                height: 24, // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 24,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            'Salmon Nigiri',// 메뉴 이름 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF1C0F0C),// 텍스트 색상 설정
                                                              fontSize: 16, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w500,// 텍스트 굵기 설정
                                                              height: 0.09,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 270,  // 컨테이너 너비 설정
                                                height: 21,  // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 21,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            '\$7.00', // 메뉴 가격 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF99594C),// 텍스트 색상 설정
                                                              fontSize: 14, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w400,// 텍스트 굵기 설정
                                                              height: 0.11,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 270, // 컨테이너 너비 설정
                                                height: 21, // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 21,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            '2 pieces', // 메뉴 수량 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF99594C),// 텍스트 색상 설정
                                                              fontSize: 14, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w400,// 텍스트 굵기 설정
                                                              height: 0.11,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 390,                  // 컨테이너 너비 설정
                            height: 96,                  // 컨테이너 높이 설정
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),// 좌우 및 상하 여백 설정
                            decoration: BoxDecoration(color: Colors.white),// 컨테이너 배경색 설정
                            child: Row(
                              mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                              mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                              crossAxisAlignment: CrossAxisAlignment.center,// 자식들을 중앙에 정렬
                              children: [
                                Expanded(
                                  child: Container(
                                    height: double.infinity,// 컨테이너 높이를 부모 크기에 맞게 설정
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                      mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                      crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                      children: [
                                        Container(
                                          width: 72,       // 컨테이너 너비 설정
                                          height: 72,      // 컨테이너 높이 설정
                                          clipBehavior: Clip.antiAlias,// 컨테이너 경계 클리핑 설정
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("https://via.placeholder.com/72x72"),// 메뉴 이미지 설정
                                              fit: BoxFit.fill, // 이미지를 컨테이너에 맞게 채움
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8)),// 모서리를 둥글게 설정
                                          ),
                                        ),
                                        const SizedBox(width: 16), // 자식들 사이의 간격 설정
                                        Container(
                                          width: 270,     // 컨테이너 너비 설정
                                          height: 66,     // 컨테이너 높이 설정
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                            mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                                            crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                            children: [
                                              Container(
                                                width: 270, // 컨테이너 너비 설정
                                                height: 24, // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 24,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            'Salmon Nigiri',// 메뉴 이름 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF1C0F0C),// 텍스트 색상 설정
                                                              fontSize: 16, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w500,// 텍스트 굵기 설정
                                                              height: 0.09,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 270,  // 컨테이너 너비 설정
                                                height: 21,  // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 21,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            '\$7.00', // 메뉴 가격 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF99594C),// 텍스트 색상 설정
                                                              fontSize: 14, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w400,// 텍스트 굵기 설정
                                                              height: 0.11,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 270, // 컨테이너 너비 설정
                                                height: 21, // 컨테이너 높이 설정
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                  mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                  crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                  children: [
                                                    Container(
                                                      width: double.infinity,// 컨테이너 너비를 최대값으로 설정
                                                      height: 21,  // 컨테이너 높이 설정
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                        mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                                        crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                        children: [
                                                          Text(
                                                            '2 pieces', // 메뉴 수량 표시
                                                            style: TextStyle(
                                                              color: Color(0xFF99594C),// 텍스트 색상 설정
                                                              fontSize: 14, // 텍스트 크기 설정
                                                              fontFamily: 'Epilogue',// 폰트 패밀리 설정
                                                              fontWeight: FontWeight.w400,// 텍스트 굵기 설정
                                                              height: 0.11,// 텍스트 높이 설정
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 390,                 // 컨테이너 너비 설정
                            height: 134,                // 컨테이너 높이 설정
                            child: Column(
                              mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                              mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                              crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                              children: [
                                Container(
                                  width: 390,             // 컨테이너 너비 설정
                                  height: 134,            // 컨테이너 높이 설정
                                  padding: const EdgeInsets.all(16),// 내부 여백 설정
                                  decoration: BoxDecoration(color: Colors.white),// 컨테이너 배경색 설정
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                    mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                    crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                    children: [
                                      Container(
                                        width: 358,        // 컨테이너 너비 설정
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),// 모서리를 둥글게 설정
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                          mainAxisAlignment: MainAxisAlignment.start,// 자식들을 상단에 정렬
                                          crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                          children: [
                                            Container(
                                              width: 358,  // 컨테이너 너비 설정
                                              height: 110.50,// 컨테이너 높이 설정
                                              padding: const EdgeInsets.symmetric(vertical: 16),// 상하 여백 설정
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                                                crossAxisAlignment: CrossAxisAlignment.start,// 자식들을 왼쪽에 정렬
                                                children: [
                                                  Container(
                                                    width: 358, // 컨테이너 너비 설정
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 64, vertical: 16),// 좌우 및 상하 여백 설정
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFF1A94FF),// 배경색 설정
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),// 모서리를 둥글게 설정
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,// 자식의 크기에 맞게 최소 크기로 설정
                                                      mainAxisAlignment: MainAxisAlignment.center,// 자식들을 중앙에 정렬
                                                      crossAxisAlignment: CrossAxisAlignment.center,// 자식들을 중앙에 정렬
                                                      children: [
                                                        Text(
                                                          'Cancel Reservation',// 예약 취소 버튼 텍스트
                                                          textAlign: TextAlign.center,// 텍스트 중앙 정렬
                                                          style: TextStyle(
                                                            color: Colors.white,// 텍스트 색상 설정
                                                            fontSize: 14,  // 텍스트 크기 설정
                                                            fontFamily: 'Inter',// 폰트 패밀리 설정
                                                            fontWeight: FontWeight.w700,// 텍스트 굵기 설정
                                                            height: 0,    // 텍스트 높이 설정
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
