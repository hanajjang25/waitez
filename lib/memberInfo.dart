import 'package:flutter/material.dart';              
import 'package:firebase_auth/firebase_auth.dart';        
import 'package:cloud_firestore/cloud_firestore.dart';    
import 'package:flutter/services.dart';                  
import 'notification.dart';                              
import 'UserHome.dart';                                 

class memberInfo extends StatefulWidget {                   // 회원 정보 페이지의 StatefulWidget
  @override
  _MemberInfoState createState() => _MemberInfoState();     // 상태 관리 클래스 생성
}

class _MemberInfoState extends State<memberInfo> {          // 상태 관리 클래스 정의
  final FirebaseAuth _auth = FirebaseAuth.instance;         // FirebaseAuth 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore 인스턴스 생성
  final TextEditingController _nicknameController = TextEditingController(); // 닉네임 입력 컨트롤러
  final TextEditingController _emailController = TextEditingController();    // 이메일 입력 컨트롤러
  final TextEditingController _phoneController = TextEditingController();    // 전화번호 입력 컨트롤러
  final TextEditingController _passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러
  final TextEditingController _confirmPasswordController = TextEditingController(); // 비밀번호 확인 입력 컨트롤러
  final TextEditingController _businessNumberController = TextEditingController();  // 사업자등록번호 입력 컨트롤러

  bool _isPasswordObscured = true;                          // 비밀번호 가리기 여부 설정
  bool _isConfirmPasswordObscured = true;                   // 비밀번호 확인 가리기 여부 설정

  @override
  void initState() {                                         // 위젯 초기화 시 호출되는 메서드
    super.initState();
    _loadUserInfo();                                         // 사용자 정보 불러오기
  }

  Future<void> _loadUserInfo() async {                       // 사용자 정보를 Firestore에서 불러오는 메서드
    User? user = _auth.currentUser;                          // 현재 로그인된 사용자 가져오기
    if (user != null) {                                      // 사용자가 존재하면
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get(); // Firestore에서 사용자 문서 가져오기
        if (userDoc.exists) {                                // 문서가 존재하면
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;        // 문서 데이터를 Map으로 변환
          setState(() {                                      // 상태 갱신
            _nicknameController.text = userData['nickname'] ?? ''; // 닉네임 설정
            _emailController.text = userData['email'] ?? '';        // 이메일 설정
            _phoneController.text = userData['phoneNum'] ?? '';     // 전화번호 설정
            _businessNumberController.text = userData['resNum'] ?? ''; // 사업자번호 설정
          });
        } else {
          print('User document does not exist');             // 문서가 없을 경우 로그 출력
        }
      } catch (e) {
        print('Failed to load user info: $e');               // 예외 발생 시 로그 출력
      }
    } else {
      print('No user is signed in');                         // 로그인이 안된 경우 로그 출력
    }
  }

  Future<void> _deleteUserAccount() async {                  // 사용자 계정을 삭제하는 메서드
    User? user = _auth.currentUser;                          // 현재 사용자 가져오기
    if (user != null) {                                      // 사용자가 존재하면
      try {
        String userEmail = user.email!;                      // 사용자의 이메일 가져오기
        await user.delete();                                 // Firebase Authentication에서 사용자 삭제
        QuerySnapshot userSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();                                          // Firestore에서 사용자 문서 검색
        for (var doc in userSnapshot.docs) {                 // 검색된 문서 모두 삭제
          await _firestore.collection('users').doc(doc.id).delete();
        }
        FlutterLocalNotification.showNotification(           // 성공 알림 표시
          '회원탈퇴',
          '회원탈퇴가 성공적으로 처리되었습니다.',
        );
        print('User account deleted');                       // 성공 로그 출력
        Navigator.of(context).pushReplacementNamed('/login'); // 로그인 화면으로 이동
      } catch (e) {                                          // 오류 발생 시 처리
        print('Failed to delete user account: $e');          // 오류 로그 출력
        if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('보안을 위해 최근 로그인이 필요합니다. 다시 로그인 후 시도해주세요.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원탈퇴 중 오류가 발생했습니다. 다시 시도해주세요.')),
          );
        }
      }
    }
  }

  Future<void> _updateUserInfo() async {                     // 사용자 정보를 업데이트하는 메서드
    if (_validateForm()) {                                   // 폼 검증
      User? user = _auth.currentUser;                        // 현재 사용자 가져오기
      if (user != null) {                                    // 사용자가 존재하면
        try {
          Map<String, dynamic> updateData = {                // 업데이트할 데이터 생성
            'phoneNum': _phoneController.text,
            'resNum': _businessNumberController.text,
          };

          if (_passwordController.text.isNotEmpty) {         // 비밀번호가 비어있지 않다면
            await user.updatePassword(_passwordController.text); // 비밀번호 업데이트
          }

          await _firestore.collection('users').doc(user.uid).update(updateData); // Firestore 업데이트

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('정보가 성공적으로 업데이트되었습니다.')),
          );

          Navigator.pushReplacement(                          // 업데이트 완료 후 UserHome으로 이동
            context,
            MaterialPageRoute(builder: (context) => home()),
          );
        } catch (e) {
          print('Failed to update user info: $e');           // 오류 발생 시 로그 출력
        }
      }
    }
  }

  bool _validateForm() {                                     // 폼의 유효성을 검사하는 메서드
    if (!_validatePhone(_phoneController.text)) {            // 전화번호 형식 검증
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전화번호 형식이 올바르지 않습니다.')),
      );
      return false;                                          // 유효하지 않으면 false 반환
    }

    if (_passwordController.text.isNotEmpty) {               // 비밀번호가 비어있지 않으면
      if (_passwordController.text.length < 6 ||             // 비밀번호 길이와 형식 검증
          !_passwordController.text.contains(RegExp(r'[a-z]'))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호는 6글자 이상이며 영어 소문자를 포함해야 합니다.')),
        );
        return false;                                        // 유효하지 않으면 false 반환
      }

      if (_passwordController.text != _confirmPasswordController.text) { // 비밀번호 일치 여부 검증
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
        );
        return false;                                        // 유효하지 않으면 false 반환
      }
    }

    return true;                                             // 모든 검증 통과 시 true 반환
  }

  bool _validatePhone(String phone) {                        // 전화번호 형식 검증 메서드
    return RegExp(r'^010-\d{4}-\d{4}$').hasMatch(phone);     // 010-0000-0000 형식 검증
  }

  Future<void> _checkRestaurantBeforeDelete() async {        // 회원 탈퇴 전에 레스토랑 소유 여부를 확인하는 메서드
    User? user = _auth.currentUser;                          // 현재 사용자 가져오기
    if (user != null && _businessNumberController.text.isNotEmpty) { // 사업자번호가 비어있지 않으면
      QuerySnapshot restaurantSnapshot = await _firestore
          .collection('restaurants')
          .where('registrationNumber',
              isEqualTo: _businessNumberController.text)
          .get();                                            // 사업자번호로 레스토랑 검색

      if (restaurantSnapshot.docs.isNotEmpty) {              // 레스토랑 문서가 존재하면
        var restaurantData =
            restaurantSnapshot.docs.first.data() as Map<String, dynamic>;
        if (restaurantData['isDeleted'] == false) {          // 레스토랑이 삭제되지 않은 경우
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('음식점 삭제 후 회원탈퇴를 진행해주세요.')),
          );
          return;
        }
      }
    }

    _deleteUserAccount();                                    // 레스토랑이 삭제되었거나 없으면 회원탈퇴 진행
  }

  void showDeleteAccountDialog() {                           // 회원 탈퇴 확인 다이얼로그를 표시하는 메서드
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원탈퇴 확인'),
          content: Text('정말로 회원탈퇴를 진행하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),  // 취소 버튼을 눌렀을 때 다이얼로그 닫기
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();                 // 확인 버튼을 눌렀을 때 다이얼로그 닫기
                _checkRestaurantBeforeDelete();              // 회원탈퇴 진행
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {                       // 화면을 그리는 빌드 메서드
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 정보'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임',
              ),
              enabled: false,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
              ),
              enabled: false,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '전화번호',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                PhoneNumberTextInputFormatter(),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _businessNumberController,
              decoration: InputDecoration(
                labelText: '사업자등록번호 (선택사항)',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordObscured
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
              ),
              obscureText: _isPasswordObscured,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordObscured
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                    });
                  },
                ),
              ),
              obscureText: _isConfirmPasswordObscured,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateUserInfo,
              child: Text('정보 수정'),
            ),
            ElevatedButton(
              onPressed: showDeleteAccountDialog,
              child: Text('회원탈퇴'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
