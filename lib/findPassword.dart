import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class findPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  Future<void> sendResetEmail(BuildContext context) async {
    try {
      // Firebase에 이메일로 비밀번호 재설정 이메일 보내기
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      // 성공 메시지 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email Sent'),
            content: Text(
                'Password reset email sent to ${emailController.text.trim()}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // 오류 메시지 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to send password reset email. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 24,
                top: 220,
                child: SizedBox(
                  width: 270,
                  child: Text(
                    '이메일을 입력해주세요.',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0.08,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 180,
                child: Text(
                  '비밀번호 찾기',
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0.09,
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 280,
                child: Text(
                  'Email address',
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 300, 30, 0), // 좌우 간격을 20으로 설정
                child: Container(
                  width: double.infinity, // 컨테이너를 부모의 전체 너비로 확장
                  height: 82,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'wait@yonsei.ac.kr',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.24,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBEC5D1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 380,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'Inter'), // 기본 텍스트 스타일
                    children: [
                      TextSpan(
                        text: 'Remember the password?',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      WidgetSpan(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets
                                .zero, // 버튼의 패딩을 제거하여 텍스트와 자연스럽게 이어지게 함
                            minimumSize: Size.zero, // 최소 크기 제한을 없앰
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // 탭 영역을 텍스트 크기에 맞춤
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text(
                            ' Sign in',
                            style: TextStyle(
                              color: Color(0xFF1A94FF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 693), // 상단 간격 설정
                child: Center(
                  // 버튼을 수평 중앙에 배치
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF4F4F4), // 배경색 설정
                      padding: EdgeInsets.symmetric(
                          horizontal: 120, vertical: 20), // 내부 패딩
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 모서리 둥글게 처리
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/findPassword_email');
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
