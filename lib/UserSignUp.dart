import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Firebase 관련 패키지 임포트
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Firebase 인증 객체 생성
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 사용자 입력값을 받는 TextEditingController 정의
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController(); // 비밀번호 재입력 컨트롤러 추가
  final TextEditingController _resNumController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  // 비밀번호 일치 여부를 저장하는 변수
  bool _passwordsMatch = true;

  // Firebase 사용자 객체
  User? user;

  // 이메일로 회원가입하는 메서드 정의
  Future<String> emailSignUp({
    required String nickname,
    required String email,
    required String password,
    required String phoneNum,
    String? resNum,
  }) async {
    try {
      // Firebase 인증을 사용하여 이메일로 회원가입
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 회원가입 성공 시, 사용자 정보 업데이트
      user = userCredential.user!;

      // 사용자가 이메일을 인증하지 않은 경우, 이메일 인증 요청
      if (user != null && !user!.emailVerified) {
        await user!.sendEmailVerification();
      }

      // Firestore에 사용자 정보 저장
      Map<String, dynamic> userData = {
        'nickname': nickname,
        'email': email,
        'phoneNum': phoneNum,
      };

      if (resNum != null && resNum.isNotEmpty) {
        userData['resNum'] = resNum;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set(userData);

      return "success"; // 성공 상태 반환
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException 처리
      if (e.code == 'email-already-in-use') {
        print("The account already exists for that email.");
        return "already"; // 이미 가입된 이메일인 경우 반환
      } else {
        print("fail");
        return "fail"; // 실패한 경우 반환
      }
    }
  }

  // 이메일 인증을 위한 메서드
  Future<void> sendEmailVerification(String email) async {
    try {
      // 이메일 형식 검증
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        throw FirebaseAuthException(
            code: 'invalid-email', message: '잘못된 이메일 형식입니다.');
      }

      // Firestore에서 해당 이메일이 이미 존재하는지 확인
      var existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUser.docs.isNotEmpty) {
        throw FirebaseAuthException(
            code: 'email-already-in-use', message: '이미 회원가입 되어 있는 이메일입니다.');
      }

      // 이메일 인증 링크 전송
      await _auth.currentUser?.sendEmailVerification();
      print("인증 이메일이 전송되었습니다.");
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e; // 예외를 다시 던져서 호출한 곳에서 처리할 수 있게 함
    }
  }

  // 닉네임 검증 메서드 정의
  bool isValidNickname(String nickname) {
    // 닉네임이 3글자 이상이어야 하고 한국어 문자만 포함되어야 한다는 조건
    if (nickname.length < 3) return false;
    final RegExp koreanRegex = RegExp(r'^[가-힣]{3,}$');
    return koreanRegex.hasMatch(nickname);
  }

  // 비밀번호 일치 여부를 확인하는 메서드
  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _passwordConfirmController.text;
    });
  }

  // 위젯 빌드 메서드
  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
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
                    // 가로로 늘어진 붉은색 박스
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
                    // 로그인 및 회원가입 텍스트
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
                    // 텍스트 필드들
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _nicknameController, // 컨트롤러 연결
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
                              child: Row(children: [
                                Expanded(
                                  child: TextField(
                                    controller: _emailController, // 컨트롤러 연결
                                    decoration: InputDecoration(
                                      labelText: '이메일',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    String email = _emailController.text.trim();
                                    print("입력된 이메일: $email"); // 이메일 로그 출력

                                    try {
                                      await sendEmailVerification(email);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("성공"),
                                          content: Text("인증 이메일이 전송되었습니다."),
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
                                    } on FirebaseAuthException catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("오류"),
                                          content:
                                              Text(e.message ?? "오류가 발생했습니다."),
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
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                                )
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _phoneNumController, // 컨트롤러 연결
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
                                controller: _passwordController, // 컨트롤러 연결
                                decoration: InputDecoration(
                                  labelText: '비밀번호',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                obscureText: true, // 비밀번호 숨기기
                                onChanged: (value) {
                                  _checkPasswordsMatch();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller:
                                    _passwordConfirmController, // 비밀번호 재입력 컨트롤러 연결
                                decoration: InputDecoration(
                                  labelText: '비밀번호 재입력',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _passwordsMatch
                                          ? Colors.grey
                                          : Colors.red, // 비밀번호 일치 여부에 따라 색상 변경
                                    ),
                                  ),
                                ),
                                obscureText: true, // 비밀번호 숨기기
                                onChanged: (value) {
                                  _checkPasswordsMatch();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _resNumController, // 컨트롤러 연결
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
                                    _passwordConfirmController
                                        .text; // 비밀번호 재입력 값 가져오기
                                String phoneNum =
                                    _phoneNumController.text.trim();
                                String resNum = _resNumController.text.trim();

                                // 필드가 비어있는지 확인
                                if (nickname.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("오류"),
                                      content: Text("닉네임을 입력해주세요."),
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
                                  return;
                                }

                                // 닉네임 유효성 검증
                                if (!isValidNickname(nickname)) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("오류"),
                                      content: Text(
                                          "닉네임은 3글자 이상이어야 하며, 한국어 문자만 포함되어야 합니다."),
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
                                  return;
                                }

                                if (email.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("오류"),
                                      content: Text("이메일 주소를 입력해주세요."),
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
                                  return;
                                }

                                if (password.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("오류"),
                                      content: Text("비밀번호를 입력해주세요."),
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
                                  return;
                                }

                                if (password.length < 4) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("오류"),
                                      content: Text("비밀번호는 4글자 이상이어야 합니다."),
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
                                  return;
                                }

                                // 비밀번호 재입력 일치 여부 확인
                                if (password != passwordConfirm) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("오류"),
                                      content: Text("비밀번호가 일치하지 않습니다."),
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
                                  return;
                                }

                                if (phoneNum.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("오류"),
                                      content: Text("전화번호를 입력해주세요."),
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
                                  return;
                                }

                                // 현재 로그인한 사용자 가져오기
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;

                                // 사용자 등록 시도
                                String result = await emailSignUp(
                                  email: email,
                                  password: password,
                                  nickname: nickname,
                                  phoneNum: phoneNum,
                                  resNum: resNum.isNotEmpty ? resNum : null,
                                );

                                // 등록 결과에 따라 처리
                                switch (result) {
                                  case "success":
                                    Navigator.pushNamed(context, '/login');
                                    break;
                                  case "already":
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("오류"),
                                        content: Text("이미 존재하는 이메일입니다."),
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
                                    break;
                                  case "fail":
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("오류"),
                                        content: Text("회원가입에 실패했습니다."),
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
                                    Color(0xFFF4F4F4)), // 배경 색상
                                foregroundColor: MaterialStateProperty.all(
                                    Colors.black), // 텍스트 색상
                                minimumSize: MaterialStateProperty.all(
                                    Size(200, 50)), // 최소 크기
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(horizontal: 30)), // 패딩
                                elevation:
                                    MaterialStateProperty.all(0), // 그림자 없음
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
