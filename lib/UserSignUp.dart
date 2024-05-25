import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _resNumController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  bool _passwordsMatch = true;

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _passwordConfirmController.text;
    });
  }

  Future<String> emailSignUp({
    required String nickname,
    required String email,
    required String password,
    required String phoneNum,
    String? resNum,
  }) async {
    try {
      // Check if business registration number already exists
      if (resNum != null && resNum.isNotEmpty) {
        DatabaseEvent event = await _databaseReference
            .child('users')
            .orderByChild('resNum')
            .equalTo(resNum)
            .once();

        if (event.snapshot.value != null) {
          return "resNum-exists"; // Business registration number already exists
        }
      }

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save user data to Realtime Database
        await _databaseReference.child('users').child(user.uid).set({
          'nickname': nickname,
          'email': email,
          'phoneNum': phoneNum,
          'resNum': resNum,
        });

        return "success"; // Registration successful
      } else {
        return "fail"; // Registration failed
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "email-already-in-use"; // Email already exists
      } else {
        return "fail"; // Other errors
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

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
                color: Colors.black.withOpacity(0.48), // 배경 색상 설정
              ),
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.1 + 200,
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white, // 배경 색상
                  borderRadius: BorderRadius.circular(36), // 모서리 둥글게 처리
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
                                  '회원가입',
                                  style: TextStyle(
                                    color: Color(0xFF1A94FF),
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
                                '로그인',
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
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _nicknameController,
                                decoration: InputDecoration(
                                  labelText: '닉네임',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: '이메일',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                      // 이메일 인증 버튼 눌렀을 때 동작
                                    },
                                    child: Text(
                                      '이메일 인증',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.lightBlueAccent),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(50, 50)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(horizontal: 10)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _phoneNumController,
                                decoration: InputDecoration(
                                  labelText: '전화번호',
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
                                  labelText: '비밀번호',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                obscureText: true,
                                onChanged: (value) {
                                  _checkPasswordsMatch();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _passwordConfirmController,
                                decoration: InputDecoration(
                                  labelText: '비밀번호 재입력',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _passwordsMatch
                                          ? Colors.grey
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                                obscureText: true,
                                onChanged: (value) {
                                  _checkPasswordsMatch();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _resNumController,
                                decoration: InputDecoration(
                                  labelText: '사업자등록번호 (선택사항)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () async {
                                // 입력된 값들 가져오기
                                String nickname =
                                    _nicknameController.text.trim();
                                String email = _emailController.text.trim();
                                String password = _passwordController.text;
                                String passwordConfirm =
                                    _passwordConfirmController.text;
                                String phoneNum =
                                    _phoneNumController.text.trim();
                                String resNum = _resNumController.text.trim();

                                // 필드가 비어있는지 확인
                                if (nickname.isEmpty) {
                                  _showErrorDialog("오류", "닉네임을 입력해주세요.");
                                  return;
                                }

                                if (email.isEmpty) {
                                  _showErrorDialog("오류", "이메일 주소를 입력해주세요.");
                                  return;
                                }

                                if (password.isEmpty) {
                                  _showErrorDialog("오류", "비밀번호를 입력해주세요.");
                                  return;
                                }

                                if (password.length < 4) {
                                  _showErrorDialog(
                                      "오류", "비밀번호는 4글자 이상이어야 합니다.");
                                  return;
                                }

                                if (password != passwordConfirm) {
                                  _showErrorDialog("오류", "비밀번호가 일치하지 않습니다.");
                                  return;
                                }

                                if (phoneNum.isEmpty) {
                                  _showErrorDialog("오류", "전화번호를 입력해주세요.");
                                  return;
                                }

                                // 회원가입 시도
                                String result = await emailSignUp(
                                  nickname: nickname,
                                  email: email,
                                  password: password,
                                  phoneNum: phoneNum,
                                  resNum: resNum.isNotEmpty ? resNum : null,
                                );

                                // 등록 결과에 따라 처리
                                switch (result) {
                                  case "success":
                                    Navigator.pushNamed(context, '/login');
                                    break;
                                  case "email-already-in-use":
                                    _showErrorDialog("오류", "이미 존재하는 이메일입니다.");
                                    break;
                                  case "resNum-exists":
                                    _showErrorDialog(
                                        "오류", "이미 존재하는 사업자등록번호입니다.");
                                    break;
                                  case "fail":
                                    _showErrorDialog("오류", "회원가입에 실패했습니다.");
                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: Text(
                                '회원가입',
                                style: TextStyle(
                                  color: Color(0xFF89909E),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFF4F4F4)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                minimumSize:
                                    MaterialStateProperty.all(Size(200, 50)),
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
                            SizedBox(height: 30),
                          ],
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
