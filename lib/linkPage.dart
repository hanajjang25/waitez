import 'package:flutter/material.dart';        
import 'package:flutter/widgets.dart';         
import 'package:firebase_database/firebase_database.dart'; 

class StartPage extends StatelessWidget {       // StartPage 클래스는 StatelessWidget을 상속
  @override
  Widget build(BuildContext context) {          // build 메서드는 위젯을 렌더링
    return Scaffold(                            // 기본적인 페이지 레이아웃을 제공하는 Scaffold 위젯 사용
      body: Center(                             // 화면 중앙에 배치하기 위해 Center 위젯 사용
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Waitez'),                       // 텍스트 'Waitez'를 화면에 표시
          Wrap(                                 // Wrap 위젯은 자식 위젯들을 여러 줄로 나열
            children: [                         // Wrap의 자식 위젯들을 리스트로 나열
              TextButton(                       // TextButton 위젯은 클릭 가능한 버튼
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/login');  // '/login' 경로로 이동
                  },
                  child: Text('로그인')),        // 버튼에 표시될 텍스트 '로그인'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/signup');  // '/signup' 경로로 이동
                  },
                  child: Text('회원가입')),      // 버튼에 표시될 텍스트 '회원가입'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/waitingNumber');  // '/waitingNumber' 경로로 이동
                  },
                  child: Text('대기순번')),      // 버튼에 표시될 텍스트 '대기순번'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/home');  // '/home' 경로로 이동
                  },
                  child: Text('home')),          // 버튼에 표시될 텍스트 'home'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/homeStaff');  // '/homeStaff' 경로로 이동
                  },
                  child: Text('직원home')),      // 버튼에 표시될 텍스트 '직원home'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/history');  // '/history' 경로로 이동
                  },
                  child: Text('이력조회')),      // 버튼에 표시될 텍스트 '이력조회'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/map');  // '/map' 경로로 이동
                  },
                  child: Text('지도')),          // 버튼에 표시될 텍스트 '지도'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/sendingMessage');  // '/sendingMessage' 경로로 이동
                  },
                  child: Text('문자')),          // 버튼에 표시될 텍스트 '문자'
              TextButton(
                  onPressed: () {               // 버튼 클릭 시 호출되는 함수 정의
                    Navigator.pushNamed(context, '/nonMemberWaitingNumber');  // '/nonMemberWaitingNumber' 경로로 이동
                  },
                  child: Text('비회원대기순번')), // 버튼에 표시될 텍스트 '비회원대기순번'
            ],
          ),
        ]),
      ),
    );
  }
}
