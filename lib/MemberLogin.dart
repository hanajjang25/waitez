import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 로그인 페이지 위젯 정의
class login extends StatelessWidget {
  int authWay = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 이메일로 로그인하는 메서드 정의
  Future<String> emailLogin({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase 인증을 사용하여 이메일로 로그인
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // 로그인한 사용자 가져오기
      user = _auth.currentUser;

      // 사용자 리로드 (user가 null이 아닌 경우에만)
      if (user != null) {
        await user!.reload();
        user = _auth.currentUser;

        // 이메일 인증이 완료되었는지 확인
        if (user!.emailVerified) {
          user = userCredential.user;
          authWay = 1;

          // 로그인 상태 저장
          await _saveLoginStatus(true);

          return "success"; // 성공 상태 반환
        } else {
          return "emailFail"; // 이메일 인증 실패 상태 반환
        }
      } else {
        return "userNotFound"; // 사용자가 null인 경우
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      return "fail"; // 실패 상태 반환
    } catch (e) {
      print('Exception: $e');
      return "fail"; // 일반 예외에 대한 실패 상태 반환
    }
  }

  // 로그인 상태를 저장하는 함수
  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // TextEditingController 정의
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      padding: EdgeInsets.symmetric(horizontal: 170),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFD2D4D8),
                            width: 4,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Transform.translate(
                      offset: Offset(-10, 0),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Color(0xFF89909E),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 80),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFF1A94FF),
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
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        controller: _emailController,
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
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 200),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/findPassword');
                        },
                        child: Text(
                          'Forget password?',
                          style: TextStyle(
                            color: Color(0xFF1A94FF),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () async {
                        // 입력 값 확인
                        if (_emailController.text.trim().isEmpty ||
                            _passwordController.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('Please check email and password'),
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
                          return;
                        }

                        // 이메일로 로그인 시도
                        String loginResult = await emailLogin(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        if (loginResult == "success") {
                          // Firestore에서 email과 fullName을 확인하고 resNum 확인
                          var email = _emailController.text.trim();
                          var password = _passwordController.text.trim();

                          var userDoc = await _firestore
                              .collection('users')
                              .where('email', isEqualTo: email)
                              .get();

                          if (userDoc.docs.isNotEmpty) {
                            var userData = userDoc.docs.first.data();
                            if (userData.containsKey('nickname')) {
                              if (userData.containsKey('resNum') &&
                                  userData['resNum'] != null &&
                                  userData['resNum'].isNotEmpty) {
                                Navigator.pushNamed(context, '/homeStaff');
                              } else {
                                Navigator.pushNamed(context, '/home');
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Login Error'),
                                    content: Text('nickname not found.'),
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Login Error'),
                                  content: Text('User document not found.'),
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
                        } else {
                          String errorMessage;
                          switch (loginResult) {
                            case 'emailFail':
                              errorMessage = 'Please verify your email first.';
                              break;
                            case 'userNotFound':
                              errorMessage = 'User not found';
                              break;
                            case 'fail':
                            default:
                              errorMessage = 'Login failed. Please try again.';
                              break;
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Login Error'),
                                content: Text(errorMessage),
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
                      },
                      child: Text('Login'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFF4F4F4)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        minimumSize: MaterialStateProperty.all(Size(200, 50)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 30)),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
