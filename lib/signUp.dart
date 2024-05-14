import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signUp extends StatelessWidget {
  final TextEditingController _emailInputText = TextEditingController();
  final TextEditingController _passInputText = TextEditingController();
  final TextEditingController _fullNameInputText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.48),
              ),
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.1 + 200,
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 170), // 모든 방향에 4의 패딩을 추가
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFD2D4D8),
                            width: 4,
                            style: BorderStyle.solid,
                          ),
                          borderRadius:
                              BorderRadius.circular(12), // 모서리를 둥글게 처리
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Transform.translate(
                      offset: Offset(-10, 0),
                      child: Container(
                        padding: EdgeInsets.all(20), // 주변 패딩을 주어 전체적인 여백을 설정
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 가로 중앙 정렬
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    right:
                                        10), // Login 텍스트와 Create Account 텍스트 사이의 간격 조정
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: Text(
                                    'Create Account',
                                    style: TextStyle(
                                      color: Color(0xFF1A94FF),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                            SizedBox(width: 80),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'login',
                                style: TextStyle(
                                  color: Color(0xFF89909E),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        'Registration',
                        style: TextStyle(
                          color: Color(0xFF89909E),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(0xFFF4F4F4)), // 버튼 배경색
                        foregroundColor: MaterialStateProperty.all(
                            Colors.black), // 버튼 텍스트 색상
                        minimumSize: MaterialStateProperty.all(
                            Size(200, 50)), // 버튼의 미니멈 사이즈
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 30)), // 좌우 패딩
                        elevation: MaterialStateProperty.all(0), // 그림자 제거
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // 둥근 모서리
                          ),
                        ),
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
