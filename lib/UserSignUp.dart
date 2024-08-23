import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {                              // 회원가입 화면을 나타내는 StatefulWidget
  @override
  _SignUpState createState() => _SignUpState();                   // _SignUpState 상태 클래스 생성
}

class _SignUpState extends State<SignUp> {                         // _SignUpState 클래스 정의
  final FirebaseAuth _auth = FirebaseAuth.instance;                // FirebaseAuth 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore 인스턴스 생성

  final TextEditingController _nicknameController = TextEditingController();  // 닉네임 입력 필드의 컨트롤러
  final TextEditingController _emailController = TextEditingController();     // 이메일 입력 필드의 컨트롤러
  final TextEditingController _passwordController = TextEditingController();  // 비밀번호 입력 필드의 컨트롤러
  final TextEditingController _passwordConfirmController = TextEditingController(); // 비밀번호 확인 필드의 컨트롤러
  final TextEditingController _resNumController = TextEditingController();    // 사업자 등록번호 필드의 컨트롤러
  final TextEditingController _phoneNumController = TextEditingController();  // 전화번호 입력 필드의 컨트롤러

  final FocusNode _nicknameFocusNode = FocusNode();               // 닉네임 입력 필드의 포커스 노드
  final FocusNode _emailFocusNode = FocusNode();                  // 이메일 입력 필드의 포커스 노드
  final FocusNode _passwordFocusNode = FocusNode();               // 비밀번호 입력 필드의 포커스 노드
  final FocusNode _passwordConfirmFocusNode = FocusNode();        // 비밀번호 확인 필드의 포커스 노드
  final FocusNode _resNumFocusNode = FocusNode();                 // 사업자 등록번호 필드의 포커스 노드
  final FocusNode _phoneNumFocusNode = FocusNode();               // 전화번호 입력 필드의 포커스 노드

  final ScrollController _scrollController = ScrollController();  // 스크롤 제어를 위한 컨트롤러

  bool _passwordsMatch = true;                                    // 비밀번호 일치 여부를 확인하는 변수
  bool _emailVerified = false;                                    // 이메일 인증 여부를 확인하는 변수
  User? _currentUser;                                              // 현재 사용자 정보를 저장하는 변수

  void _checkPasswordsMatch() {                                   // 비밀번호와 비밀번호 확인 필드의 값이 일치하는지 확인
    setState(() {
      _passwordsMatch = _passwordController.text == _passwordConfirmController.text;
    });
  }

  Future<void> _sendEmailVerification(User user) async {          // 이메일 인증을 위한 메소드
    try {
      await user.sendEmailVerification();
      _showErrorDialog("이메일 전송", "이메일을 확인하고 인증을 완료해주세요."); // 인증 이메일 전송 성공 시 다이얼로그 표시
    } catch (e) {
      _showErrorDialog("오류", "이메일 인증 중 오류가 발생했습니다: $e");  // 인증 이메일 전송 실패 시 오류 다이얼로그 표시
    }
  }

  Future<bool> _isEmailInUse(String email) async {                // 이메일이 이미 사용 중인지 확인하는 메소드
    List<String> methods = await _auth.fetchSignInMethodsForEmail(email);
    return methods.isNotEmpty;
  }

  Future<bool> _isNicknameInUse(String nickname) async {          // 닉네임이 이미 사용 중인지 확인하는 메소드
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> _isPhoneNumInUse(String phoneNum) async {          // 전화번호가 이미 사용 중인지 확인하는 메소드
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('phoneNum', isEqualTo: phoneNum)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> emailSignUp({                                    // 회원가입 메소드
    required String nickname,
    required String email,
    required String password,
    required String phoneNum,
    String? resNum,
  }) async {
    try {
      // 닉네임 중복 확인
      bool nicknameInUse = await _isNicknameInUse(nickname);
      if (nicknameInUse) {
        return "nickname-already-in-use"; // 닉네임이 이미 존재하는 경우
      }

      // 사업자등록번호 중복 확인
      if (resNum != null && resNum.isNotEmpty) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('resNum', isEqualTo: resNum)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return "resNum-exists"; // 사업자등록번호가 이미 존재하는 경우
        }
      }

      // 이메일 중복 확인
      bool emailInUse = await _isEmailInUse(email);
      if (emailInUse) {
        return "email-already-in-use"; // 이메일이 이미 존재하는 경우
      }

      // 전화번호 중복 확인
      bool phoneNumInUse = await _isPhoneNumInUse(phoneNum);
      if (phoneNumInUse) {
        return "phoneNum-already-in-use"; // 전화번호가 이미 존재하는 경우
      }

      // 이메일과 비밀번호로 사용자 생성
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Firestore에 사용자 정보 저장
        await _firestore.collection('users').doc(user.uid).set({
          'nickname': nickname,
          'email': email,
          'phoneNum': phoneNum,
          'resNum': resNum,
        });

        return "success"; // 회원가입 성공
      } else {
        return "fail"; // 회원가입 실패
      }
    } on FirebaseAuthException catch (e) {
      return "fail"; // Firebase 인증 관련 오류 처리
    } catch (e) {
      return "fail"; // 일반 오류 처리
    }
  }


 void _showErrorDialog(String title, String message) {           // 오류 메시지를 표시하는 다이얼로그
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

  bool _validateNickname(String nickname) {                       // 닉네임 유효성 검사
    final RegExp nicknameExp = RegExp(r'^[가-힣]+$');
    return nicknameExp.hasMatch(nickname) &&
        nickname.length >= 2 &&
        nickname.length <= 7;
  }

  bool _validatePhoneNum(String phoneNum) {                       // 전화번호 유효성 검사
    final RegExp phoneExp = RegExp(r'^010-\d{4}-\d{4}$');
    return phoneExp.hasMatch(phoneNum);
  }

  bool _validatePassword(String password) {                       // 비밀번호 유효성 검사
    final RegExp passwordExp = RegExp(r'^(?=.*[a-z]).{6,10}$');
    return passwordExp.hasMatch(password);
  }

  bool _validateResNum(String resNum) {                           // 사업자등록번호 유효성 검사
    final RegExp resNumExp = RegExp(r'^\d*$');
    return resNumExp.hasMatch(resNum);
  }

  bool _isFormValid() {                                           // 모든 입력값이 유효한지 확인하는 메소드
    bool nicknameValid = _validateNickname(_nicknameController.text);
    bool passwordValid = _validatePassword(_passwordController.text);
    bool phoneNumValid = _validatePhoneNum(_phoneNumController.text);
    bool passwordsMatch = _passwordsMatch;
    bool emailVerified = _emailVerified;

    print("Nickname valid: $nicknameValid");
    print("Password valid: $passwordValid");
    print("Phone number valid: $phoneNumValid");
    print("Passwords match: $passwordsMatch");
    print("Email verified: $emailVerified");

    return nicknameValid &&
        passwordValid &&
        passwordsMatch &&
        phoneNumValid &&
        emailVerified;
  }

  void _scrollToFocusedNode(FocusNode focusNode) {                 // 포커스된 입력 필드로 자동 스크롤
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _scrollToFocusedNode(_nicknameFocusNode);                      // 닉네임 입력 필드 포커스 시 스크롤
    _scrollToFocusedNode(_emailFocusNode);                         // 이메일 입력 필드 포커스 시 스크롤
    _scrollToFocusedNode(_passwordFocusNode);                      // 비밀번호 입력 필드 포커스 시 스크롤
    _scrollToFocusedNode(_passwordConfirmFocusNode);               // 비밀번호 확인 필드 포커스 시 스크롤
    _scrollToFocusedNode(_resNumFocusNode);                        // 사업자등록번호 필드 포커스 시 스크롤
    _scrollToFocusedNode(_phoneNumFocusNode);                      // 전화번호 입력 필드 포커스 시 스크롤
  }

  @override
  void dispose() {
    _nicknameController.dispose();                                 // 닉네임 컨트롤러 메모리 해제
    _emailController.dispose();                                    // 이메일 컨트롤러 메모리 해제
    _passwordController.dispose();                                 // 비밀번호 컨트롤러 메모리 해제
    _passwordConfirmController.dispose();                          // 비밀번호 확인 컨트롤러 메모리 해제
    _resNumController.dispose();                                   // 사업자등록번호 컨트롤러 메모리 해제
    _phoneNumController.dispose();                                 // 전화번호 컨트롤러 메모리 해제

    _nicknameFocusNode.dispose();                                  // 닉네임 포커스 노드 메모리 해제
    _emailFocusNode.dispose();                                     // 이메일 포커스 노드 메모리 해제
    _passwordFocusNode.dispose();                                  // 비밀번호 포커스 노드 메모리 해제
    _passwordConfirmFocusNode.dispose();                           // 비밀번호 확인 포커스 노드 메모리 해제
    _resNumFocusNode.dispose();                                    // 사업자등록번호 포커스 노드 메모리 해제
    _phoneNumFocusNode.dispose();                                  // 전화번호 포커스 노드 메모리 해제

    _scrollController.dispose();                                   // 스크롤 컨트롤러 메모리 해제

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;          // 화면의 너비를 가져옴
    final screenHeight = MediaQuery.of(context).size.height;        // 화면의 높이를 가져옴

    return Scaffold(
      resizeToAvoidBottomInset: true,                               // 키보드에 의해 화면이 밀리지 않도록 설정
      body: SingleChildScrollView(                                  // 화면을 스크롤 가능하게 설정
        controller: _scrollController,
        child: Container(
          width: screenWidth,                                       // 화면의 전체 너비 사용
          height: screenHeight,                                     // 화면의 전체 높이 사용
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.48),            // 배경 색상 설정
                ),
              ),
              Positioned(
                left: screenWidth * 0.05,                           // 좌측 여백 설정
                top: screenHeight * 0.1 + 200,                      // 상단 여백 설정
                child: Container(
                  width: screenWidth * 0.9,                         // 화면의 90% 너비 사용
                  height: screenHeight * 0.7,                       // 화면의 70% 높이 사용
                  decoration: BoxDecoration(
                    color: Colors.white,                            // 배경 색상
                    borderRadius: BorderRadius.circular(36),        // 모서리 둥글게 처리
                  ),
                  child: Column(children: [
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
                                    color: Colors.blueAccent,
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
                                Navigator.pushNamed(context, '/');
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
                                focusNode: _nicknameFocusNode,
                                decoration: InputDecoration(
                                  labelText: '닉네임',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _nicknameFocusNode.hasFocus ||
                                          _nicknameController.text.isNotEmpty
                                      ? _validateNickname(
                                              _nicknameController.text)
                                          ? null
                                          : '한글만 입력 가능하며 2글자 이상 7글자 이하이어야 합니다'
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _emailController,
                                      focusNode: _emailFocusNode,
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
                                    onPressed: () async {
                                      // 이메일 인증 버튼 눌렀을 때 동작
                                      String email =
                                          _emailController.text.trim();
                                      bool emailInUse =
                                          await _isEmailInUse(email);
                                      if (emailInUse) {
                                        _showErrorDialog(
                                            "오류", "이미 등록되어 있는 메일이 있습니다.");
                                        return;
                                      }

                                      try {
                                        UserCredential userCredential =
                                            await _auth
                                                .createUserWithEmailAndPassword(
                                          email: email,
                                          password: 'temporaryPassword',
                                        );
                                        User? user = userCredential.user;
                                        if (user != null) {
                                          await _sendEmailVerification(user);
                                          setState(() {
                                            _emailVerified = true;
                                            _currentUser = user;
                                          });
                                        } else {
                                          _showErrorDialog(
                                              "오류", "이메일 인증에 실패했습니다.");
                                        }
                                      } catch (e) {
                                        _showErrorDialog(
                                            "오류", "이메일 인증 중 오류가 발생했습니다: $e");
                                      }
                                    },
                                    child: Text(
                                      '이메일 인증',
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue[50]),
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
                                focusNode: _phoneNumFocusNode,
                                decoration: InputDecoration(
                                  labelText: '전화번호',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _phoneNumFocusNode.hasFocus ||
                                          _phoneNumController.text.isNotEmpty
                                      ? _validatePhoneNum(
                                              _phoneNumController.text)
                                          ? null
                                          : '010-0000-0000 형식으로 입력해주세요'
                                      : null,
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                  PhoneNumberTextInputFormatter(),
                                ],
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                decoration: InputDecoration(
                                  labelText: '비밀번호',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _passwordFocusNode.hasFocus ||
                                          _passwordController.text.isNotEmpty
                                      ? _validatePassword(
                                              _passwordController.text)
                                          ? null
                                          : '비밀번호는 6글자 이상 10글자 이하이고 영어 소문자를 포함해야 합니다'
                                      : null,
                                ),
                                obscureText: true,
                                onChanged: (value) {
                                  _checkPasswordsMatch();
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _passwordConfirmController,
                                focusNode: _passwordConfirmFocusNode,
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
                                  errorText:
                                      _passwordConfirmFocusNode.hasFocus ||
                                              _passwordConfirmController
                                                  .text.isNotEmpty
                                          ? _passwordsMatch
                                              ? null
                                              : '비밀번호가 일치하지 않습니다'
                                          : null,
                                ),
                                obscureText: true,
                                onChanged: (value) {
                                  _checkPasswordsMatch();
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextField(
                                controller: _resNumController,
                                focusNode: _resNumFocusNode,
                                decoration: InputDecoration(
                                  labelText: '사업자등록번호 (선택사항)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _resNumFocusNode.hasFocus ||
                                          _resNumController.text.isNotEmpty
                                      ? _validateResNum(_resNumController.text)
                                          ? null
                                          : '숫자만 입력 가능합니다'
                                      : null,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  setState(() {});
                                },
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
                                if (nickname.isEmpty ||
                                    !_validateNickname(nickname)) {
                                  _showErrorDialog("오류", "닉네임을 올바르게 입력해주세요.");
                                  return;
                                }

                                if (email.isEmpty) {
                                  _showErrorDialog("오류", "이메일 주소를 입력해주세요.");
                                  return;
                                }

                                if (password.isEmpty ||
                                    !_validatePassword(password)) {
                                  _showErrorDialog("오류", "비밀번호를 올바르게 입력해주세요.");
                                  return;
                                }

                                if (passwordConfirm.isEmpty) {
                                  _showErrorDialog("오류", "비밀번호 재입력을 해주세요.");
                                  return;
                                }

                                if (password != passwordConfirm) {
                                  _showErrorDialog("오류", "비밀번호가 일치하지 않습니다.");
                                  return;
                                }

                                if (phoneNum.isEmpty ||
                                    !_validatePhoneNum(phoneNum)) {
                                  _showErrorDialog("오류", "전화번호를 올바르게 입력해주세요.");
                                  return;
                                }

                                if (!_emailVerified) {
                                  _showErrorDialog("오류", "이메일 인증을 완료해주세요.");
                                  return;
                                }

                                if (resNum.isNotEmpty &&
                                    !_validateResNum(resNum)) {
                                  _showErrorDialog(
                                      "오류", "사업자등록번호를 올바르게 입력해주세요.");
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
                                    if (_currentUser != null) {
                                      await _currentUser!
                                          .updatePassword(password);
                                    }
                                    Navigator.pushNamed(context, '/');
                                    break;
                                  case "nickname-already-in-use":
                                    _showErrorDialog("오류", "동일한 닉네임이 존재합니다.");
                                    break;
                                  case "email-already-in-use":
                                    _showErrorDialog(
                                        "오류", "이미 등록되어 있는 메일이 있습니다.");
                                    break;
                                  case "phoneNum-already-in-use":
                                    _showErrorDialog("오류", "이미 전화번호가 존재합니다.");
                                    break;
                                  case "resNum-exists":
                                    _showErrorDialog(
                                        "오류", "이미 존재하는 사업자등록번호입니다.");
                                    break;
                                  case "fail":
                                    if (_currentUser != null) {
                                      await _currentUser!.delete();
                                    }

                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: Text(
                                '회원가입',
                                style: TextStyle(
                                  color: _isFormValid()
                                      ? Colors.white
                                      : Color(0xFF89909E),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  _isFormValid()
                                      ? Color(0xFF1A94FF)
                                      : Color(0xFFF4F4F4),
                                ),
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
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {   // 전화번호 포맷팅을 위한 클래스
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int oldTextLength = oldValue.text.length;
    final int newTextLength = newValue.text.length;

    final StringBuffer newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    for (int i = 0; i < newTextLength; i++) {
      if (i == 3 || i == 7) {
        newText.write('-');
        if (i <= selectionIndex) selectionIndex++;
      }
      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
