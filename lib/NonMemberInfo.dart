import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// nonMemberInfo 클래스는 비회원 정보를 입력받는 StatefulWidget.
class nonMemberInfo extends StatefulWidget {
  const nonMemberInfo({super.key});

  @override
  _NonMemberInfoState createState() => _NonMemberInfoState();                        // 상태를 관리할 State를 생성.
}

class _NonMemberInfoState extends State<nonMemberInfo> {
  final TextEditingController _nicknameController = TextEditingController();         // 닉네임 입력 필드를 제어하는 컨트롤러.
  final TextEditingController _phoneController =
      TextEditingController(text: '010-');                                           // 전화번호 입력 필드를 제어하는 컨트롤러, 기본값으로 '010-' 설정.

  String? _errorMessage;                                                             // 오류 메시지를 저장할 변수.

  @override
  void dispose() {
    // 위젯이 소멸될 때 컨트롤러를 해제하여 메모리 누수를 방지.
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // 주어진 닉네임이 이미 존재하는지 확인하는 메소드.
  Future<bool> _isNicknameExists(String nickname) async {
    final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .get();                                                                       // 'users' 컬렉션에서 동일한 닉네임이 존재하는지 조회.
    final QuerySnapshot nonMemberSnapshot = await FirebaseFirestore.instance
        .collection('non_members')
        .where('nickname', isEqualTo: nickname)
        .get();                                                                      // 'non_members' 컬렉션에서 동일한 닉네임이 존재하는지 조회.
    return userSnapshot.docs.isNotEmpty || nonMemberSnapshot.docs.isNotEmpty;        // 두 컬렉션 중 하나라도 닉네임이 존재하면 true 반환.
  }


  // 주어진 전화번호가 이미 존재하는지 확인하는 메소드.
  Future<bool> _isPhoneExists(String phone) async {
    final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNum', isEqualTo: phone)
        .get();                                                                      // 'users' 컬렉션에서 동일한 전화번호가 존재하는지 조회.
    final QuerySnapshot nonMemberSnapshot = await FirebaseFirestore.instance
        .collection('non_members')
        .where('phoneNum', isEqualTo: phone)
        .get();                                                                      // 'non_members' 컬렉션에서 동일한 전화번호가 존재하는지 조회.
    return userSnapshot.docs.isNotEmpty || nonMemberSnapshot.docs.isNotEmpty;        // 두 컬렉션 중 하나라도 전화번호가 존재하면 true 반환.
  }

  // 비회원 정보를 저장하는 메소드.
  Future<void> _saveNonMemberInfo() async {
    try {
      final nickname = _nicknameController.text.trim();                              // 닉네임 입력값을 가져와서 공백을 제거.
      final phone = _phoneController.text.trim();                                    // 전화번호 입력값을 가져와서 공백을 제거.

      // 닉네임이 유효한지 확인. (2~7글자 사이)
      if (nickname.isEmpty || nickname.length < 2 || nickname.length > 7) {
        setState(() {
          _errorMessage = '닉네임은 2글자 이상 7글자 이하로 입력해주세요.';              // 오류 메시지 설정.
        });
        return;
      }

      // 전화번호가 유효한지 확인.
      if (phone.isEmpty || !_isValidPhoneNumber(phone)) {
        setState(() {
          _errorMessage = '전화번호를 010-0000-0000 형식으로 입력해주세요.';            // 오류 메시지 설정.
        });
        return;
      }

      // 닉네임 중복 여부를 확인.
      if (await _isNicknameExists(nickname)) {
        setState(() {
          _errorMessage = '이미 존재하는 닉네임입니다. 다른 닉네임을 입력해주세요';       // 오류 메시지 설정.
        });
        return;
      }

      // 전화번호 중복 여부를 확인.
      if (await _isPhoneExists(phone)) {
        setState(() {
          _errorMessage = '이미 존재하는 전화번호입니다. 다른 전화번호를 입력해주세요';    // 오류 메시지 설정.
        });
        return;
      }

      // 비회원으로 익명 로그인.
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {                                                             // 사용자 객체가 null이 아닌 경우.
        final nonMemberData = {
          'nickname': nickname,                                                       // 닉네임 저장.
          'phoneNum': phone,                                                          // 전화번호 저장.
          'timestamp': FieldValue.serverTimestamp(),                                  // Firestore 서버 타임스탬프 저장.
          'isSaved': true,                                                            // 비회원 정보가 저장되었음을 나타내는 변수.
          'uid': user.uid,                                                            // 사용자 고유 ID를 저장.
        };

        await FirebaseFirestore.instance
            .collection('non_members')
            .add(nonMemberData);                                                      // Firestore에 비회원 정보를 저장.

        print('Non-member info saved successfully');                                  // 저장 성공 메시지 출력.
        Navigator.pushNamed(context, '/nonMemberHome');                               // 저장 후 홈 화면으로 이동.
      } else {
        print('Error: User is null');                                                 // 사용자 객체가 null인 경우 오류 메시지 출력.
      }
    } catch (e) {
      print('Error saving non-member info: $e');                                      // 비회원 정보 저장 중 오류 발생 시 메시지 출력.
    }
  }


  // 전화번호가 유효한지 확인하는 메소드.
  bool _isValidPhoneNumber(String phone) {
    final phoneRegExp = RegExp(r'^010-\d{4}-\d{4}$');                                 // '010-0000-0000' 형식을 검사하는 정규식.
    return phoneRegExp.hasMatch(phone);                                               // 전화번호가 정규식과 일치하는지 확인.
  }

  // 입력된 전화번호를 형식에 맞게 변환하는 메소드.
  String _formatPhoneNumber(String value) {
    value =
        value.replaceAll(RegExp(r'\D'), '');                                          // 숫자가 아닌 모든 문자를 제거.
    if (value.length > 3) {
      value = value.substring(0, 3) + '-' + value.substring(3);                       // 첫 3자리 뒤에 '-' 추가.
    }
    if (value.length > 8) {
      value = value.substring(0, 8) + '-' + value.substring(8);                       // 다음 4자리 뒤에 '-' 추가.
    }
    return value;                                                                     // 형식에 맞게 변환된 전화번호 반환.
  }

  @override
  Widget build(BuildContext context) {
    // 위젯의 UI를 빌드하는 메소드.
    return Scaffold(
      appBar: AppBar(
        title: Text('정보입력'),                                                       // 앱 바의 제목을 설정.
        leading: IconButton(
          icon: Icon(Icons.arrow_back),                                               // 뒤로가기 아이콘 설정.
          onPressed: () {
            Navigator.pop(context);                                                   // 아이콘을 눌렀을 때 이전 화면으로 돌아감.
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),                                          // 화면의 모든 가장자리에 16px의 패딩을 추가.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,                               // 자식 위젯들을 왼쪽으로 정렬.
          children: [
            SizedBox(height: 50),                                                     // 상단 여백 50px 추가.
            Text(
              '닉네임',                                                                // 닉네임 레이블 텍스트.
              style: TextStyle(
                color: Color(0xFF1C1C21),                                             // 텍스트 색상 설정.
                fontSize: 18,                                                         // 텍스트 크기 설정.
                fontFamily: 'Epilogue',                                               // 텍스트 폰트 설정.
              ),
            ),
            TextFormField(
              controller: _nicknameController,                                        // 닉네임 입력 필드에 텍스트 컨트롤러 연결.
              decoration: InputDecoration(),                                          // 기본 입력 필드 스타일 사용.
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]')),                            // 한글, 영문, 숫자만 허용하는 필터.
                LengthLimitingTextInputFormatter(7),                                  // 최대 7글자 입력 제한.
              ],
              keyboardType: TextInputType.text,                                       // 텍스트 입력 타입으로 설정.
            ),
            SizedBox(height: 30),                                                     // 닉네임 필드와 전화번호 필드 사이에 30px 간격 추가.
            Text(
              '전화번호',                                                              // 전화번호 레이블 텍스트.
              style: TextStyle(
                color: Color(0xFF1C1C21),                                             // 텍스트 색상 설정.
                fontSize: 18,                                                         // 텍스트 크기 설정.
                fontFamily: 'Epilogue',                                               // 텍스트 폰트 설정.
              ),
            ),
            TextFormField(
              controller: _phoneController,                                           // 전화번호 입력 필드에 텍스트 컨트롤러 연결.
              decoration: InputDecoration(
                hintText: '010-0000-0000',                                            // 입력 필드의 힌트 텍스트 설정.
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),                  // 숫자와 '-'만 허용하는 필터.
                LengthLimitingTextInputFormatter(13),                                 // 최대 13자리 입력 제한.
                TextInputFormatter.withFunction(
                  (oldValue, newValue) {
                    String newText = _formatPhoneNumber(newValue.text);               // 입력된 텍스트를 형식에 맞게 변환.
                    if (!newText.startsWith('010-')) {
                      newText = '010-' + newText.replaceAll('010-', '');              // 전화번호가 '010-'으로 시작하도록 강제.
                    }
                    return TextEditingValue(
                      text: newText,                                                  // 변환된 텍스트를 반환.
                      selection:
                          TextSelection.collapsed(offset: newText.length),            // 커서를 텍스트 끝으로 이동.
                    );
                  },
                ),
              ],
              keyboardType: TextInputType.number,                                      // 숫자 입력 타입으로 설정.
            ),
            SizedBox(height: 30),                                                      // 전화번호 필드와 오류 메시지 사이에 30px 간격 추가.
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!, // 오류 메시지를 표시.
                style: TextStyle(color: Colors.red),                                   // 오류 메시지의 색상을 빨간색으로 설정.
              ),
              SizedBox(height: 30),                                                    // 오류 메시지와 버튼 사이에 30px 간격 추가.
            ],
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveNonMemberInfo();                                          // 버튼이 눌렸을 때 비회원 정보를 저장.
                },
                child: Text('다음'),                                                   // 버튼의 텍스트를 '다음'으로 설정.
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlueAccent),               // 버튼 배경색을 밝은 파란색으로 설정.
                  foregroundColor: MaterialStateProperty.all(Colors.black),            // 버튼 텍스트 색상을 검정색으로 설정.
                  minimumSize: MaterialStateProperty.all(Size(200, 50)),               // 버튼의 최소 크기를 설정.
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 10)),                           // 버튼의 내부 여백을 설정.
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),                         // 버튼의 모서리를 둥글게 설정.
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
