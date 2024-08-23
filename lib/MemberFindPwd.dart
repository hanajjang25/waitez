import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class findPassword extends StatefulWidget {
  @override
  _FindPasswordState createState() => _FindPasswordState();
}

class _FindPasswordState extends State<findPassword> {
  final TextEditingController emailController = TextEditingController(); // 이메일 입력 필드 컨트롤러
  bool _isEmailFilled = false; // 이메일이 입력되었는지 여부를 저장하는 변수

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateEmailState); // 이메일 입력 상태를 업데이트하는 리스너 추가
  }

  @override
  void dispose() {
    emailController.removeListener(_updateEmailState); // 리스너 제거
    emailController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  // 이메일 입력 상태를 업데이트하는 함수
  void _updateEmailState() {
    setState(() {
      _isEmailFilled = emailController.text.isNotEmpty;
    });
  }

  // 비밀번호 재설정 이메일을 전송하는 함수
  Future<void> sendResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(), // 이메일 입력값에서 공백 제거
      );
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
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      Navigator.pushNamed(context, '/findPassword_email'); // 이메일 전송 후 이동할 페이지
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('이메일 보내기 실패하였습니다. 이메일을 확인해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
    final screenWidth = MediaQuery.of(context).size.width; // 화면 너비 가져오기
    final screenHeight = MediaQuery.of(context).size.height; // 화면 높이 가져오기

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white), // 배경 색상 설정
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
                padding: EdgeInsets.fromLTRB(30, 300, 30, 0),
                child: Container(
                  width: double.infinity,
                  height: 82,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'wait@yonsei.ac.kr', // 예시 이메일 주소
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
                    style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
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
                            Navigator.pushNamed(context, '/'); // 로그인 페이지로 이동
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text(
                            ' Sign in',
                            style: TextStyle(
                              color: Color(0xFF1A94FF), // 하이라이트 색상
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 693),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isEmailFilled
                          ? Color(0xFF1A94FF)
                          : Color(0xFFF4F4F4), // 이메일 입력에 따라 색상 변경
                      padding:
                          EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isEmailFilled
                        ? () {
                            sendResetEmail(context); // 이메일 전송 함수 호출
                          }
                        : null,
                    child: Text(
                      '전송',
                      style: TextStyle(
                        color:
                            _isEmailFilled ? Colors.white : Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
