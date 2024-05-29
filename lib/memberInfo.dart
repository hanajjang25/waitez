import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'UserHome.dart'; // UserHome 클래스를 import

class memberInfo extends StatefulWidget {
  @override
  _MemberInfoState createState() => _MemberInfoState();
}

class _MemberInfoState extends State<memberInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
            _nicknameController.text = userData['nickname'] ?? '';
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

  Future<void> _updateUserInfo() async {
    if (_validateForm()) {
      User? user = _auth.currentUser;
      if (user != null) {
        try {
          Map<String, dynamic> updateData = {
            'phoneNum': _phoneController.text,
            'resNum': _businessNumberController.text,
          };

          if (_passwordController.text.isNotEmpty) {
            await user.updatePassword(_passwordController.text);
          }

          await _firestore.collection('users').doc(user.uid).update(updateData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('정보가 성공적으로 업데이트되었습니다.')),
          );

          // 모든 작업이 완료되면 UserHome 페이지로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => home()),
          );
        } catch (e) {
          print('Failed to update user info: $e');
        }
      }
    }
  }

  bool _validateForm() {
    if (!_validatePhone(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전화번호 형식이 올바르지 않습니다.')),
      );
      return false;
    }

    if (_passwordController.text.isNotEmpty) {
      if (_passwordController.text.length < 6 ||
          !_passwordController.text.contains(RegExp(r'[a-z]'))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호는 6글자 이상이며 영어 소문자를 포함해야 합니다.')),
        );
        return false;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
        );
        return false;
      }
    }

    return true;
  }

  bool _validatePhone(String phone) {
    return RegExp(r'^\d{3}-\d{3,4}-\d{4}$').hasMatch(phone);
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
                  '닉네임',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(),
                  readOnly: true,
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
                  decoration: InputDecoration(
                    hintText: '010-1234-5678',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneNumberFormatter(),
                  ],
                  validator: (value) {
                    if (!_validatePhone(value!)) {
                      return '전화번호 형식이 올바르지 않습니다.';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        (value.length < 6 ||
                            !value.contains(RegExp(r'[a-z]')))) {
                      return '비밀번호는 6글자 이상이며 영어 소문자를 포함해야 합니다.';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
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
                  onPressed: _updateUserInfo,
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

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 7) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    final formattedText = buffer.toString();
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
