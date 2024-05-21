import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class memberInfo extends StatefulWidget {
  @override
  _MemberInfoState createState() => _MemberInfoState();
}

class _MemberInfoState extends State<memberInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phoneVerificationController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _businessNumberController =
      TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = userData['fullName'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phoneNum'] ?? '';
            _businessNumberController.text = userData['resNum'] ?? '';
          });
        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print('Failed to load user info: $e');
      }
    } else {
      print('No user is signed in');
    }
  }

  Future<void> _deleteUserAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Firestore에서 사용자 문서 삭제
        await _firestore.collection('users').doc(user.uid).delete();
        // Firebase Authentication에서 사용자 삭제
        await user.delete();
        print('User account deleted');
        // 회원탈퇴 후 로그인 화면으로 이동
        Navigator.of(context).pushReplacementNamed('/login');
      } catch (e) {
        print('Failed to delete user account: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원정보 수정',
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.07,
            letterSpacing: -0.27,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  '회원 정보',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 500,
                  child: Divider(color: Colors.black, thickness: 2.0),
                ),
                SizedBox(height: 30),
                Text(
                  '이름',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(),
                ),
                SizedBox(height: 50),
                Text(
                  '이메일',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(),
                  readOnly: true,
                ),
                SizedBox(height: 50),
                Text(
                  '전화번호',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(),
                ),
                SizedBox(height: 50),
                Text(
                  '새 비밀번호',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                  ),
                  obscureText: _isPasswordObscured,
                ),
                SizedBox(height: 50),
                Text(
                  '새 비밀번호 재입력',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordObscured =
                              !_isConfirmPasswordObscured;
                        });
                      },
                    ),
                  ),
                  obscureText: _isConfirmPasswordObscured,
                ),
                SizedBox(height: 50),
                Text(
                  '사업자등록번호',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _businessNumberController,
                  decoration: InputDecoration(),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // 회원탈퇴 기능 호출
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('회원탈퇴'),
                            content: Text('정말로 회원탈퇴를 하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await _deleteUserAccount();
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      '회원탈퇴',
                      style: TextStyle(
                        color: Color(0xFF1C1C21),
                        fontSize: 18,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w700,
                        height: 0.07,
                        letterSpacing: -0.27,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 수정 기능 추가
                  },
                  child: Text('수정'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
