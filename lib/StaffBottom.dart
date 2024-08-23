import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RestaurantEdit.dart';

class staffBottom extends StatelessWidget {                           // 직원용 BottomNavigationBar를 위한 StatelessWidget 클래스.
  void _showNumberConfirmDialog(BuildContext context) {               // 등록번호 확인을 위한 다이얼로그를 표시하는 메소드.
    final TextEditingController _controller = TextEditingController(); // 입력된 등록번호를 관리하기 위한 컨트롤러.
    final _formKey = GlobalKey<FormState>();                          // 폼 상태를 관리하기 위한 GlobalKey.

    showDialog(                                                       // 다이얼로그를 화면에 표시.
      context: context,                                               // 현재 컨텍스트를 전달.
      builder: (BuildContext context) {
        return AlertDialog(                                           // 다이얼로그를 AlertDialog 형태로 구성.
          title: Text('등록번호'),                                      // 다이얼로그 제목 설정.
          content: Form(                                              // 다이얼로그 내용에 폼 추가.
            key: _formKey,                                             // 폼의 키 설정.
            child: Column(
              mainAxisSize: MainAxisSize.min,                         // 자식 위젯들의 최소 크기로 높이 설정.
              children: [
                Text('등록번호를 입력해주세요.'),                       // 안내 텍스트.
                TextFormField(                                        // 등록번호를 입력받는 필드.
                  controller: _controller,                            // 입력된 텍스트를 컨트롤러에 저장.
                  keyboardType: TextInputType.number,                 // 숫자 입력 타입 설정.
                  decoration: InputDecoration(hintText: '등록번호'),   // 힌트 텍스트 설정.
                  validator: (value) {                                // 입력 값의 유효성을 검사.
                    if (value == null || value.isEmpty) {             // 값이 비어있는 경우.
                      return '등록번호를 입력해주세요.';               // 오류 메시지 반환.
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {       // 숫자가 아닌 값이 포함된 경우.
                      return '숫자만 입력이 가능합니다.';             // 오류 메시지 반환.
                    }
                    return null;                                      // 유효한 입력인 경우 오류 없음.
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {                                   // 확인 버튼을 눌렀을 때 실행.
                if (_formKey.currentState!.validate()) {              // 폼이 유효한지 확인.
                  String registrationNumber = _controller.text;       // 입력된 등록번호를 저장.
                  User? user = FirebaseAuth.instance.currentUser;     // 현재 로그인된 사용자 정보를 가져옴.
                  if (user != null) {
                    try {
                      final userDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();                                     // Firestore에서 사용자 문서를 가져옴.
                      if (userDoc.exists &&
                          userDoc.data()!.containsKey('resNum')) {    // 사용자 문서에 등록번호가 존재하는지 확인.
                        String userRegistrationNumber = userDoc['resNum']; // 사용자의 등록번호를 가져옴.
                        if (userRegistrationNumber == registrationNumber) { // 입력된 등록번호와 사용자의 등록번호가 일치하는지 확인.
                          Navigator.push(                            // 일치하면 음식점 수정 페이지로 이동.
                            context,
                            MaterialPageRoute(
                              builder: (context) => editregRestaurant(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('등록번호가 일치하지 않습니다.')), // 등록번호 불일치 메시지 표시.
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('등록번호 필드가 존재하지 않습니다.')), // 등록번호가 없는 경우 메시지 표시.
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('사용자 정보를 불러오는 중 오류가 발생했습니다.')), // 사용자 정보 로드 중 오류 메시지 표시.
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')), // 사용자가 로그인되지 않은 경우 메시지 표시.
                    );
                  }
                }
              },
              child: Text('확인'),                                     // 확인 버튼 텍스트 설정.
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();                          // 취소 버튼을 누르면 다이얼로그 닫기.
              },
              child: Text('취소'),                                     // 취소 버튼 텍스트 설정.
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {                                // 위젯의 UI를 빌드하는 메소드.
    return BottomNavigationBar(
      selectedItemColor: Colors.black,                                // 선택된 아이템의 텍스트 색상.
      unselectedItemColor: Colors.black,                              // 비선택된 아이템의 텍스트 색상.
      type: BottomNavigationBarType.fixed,                            // 모든 아이템을 고정된 위치에 배치.
      selectedFontSize: 13,                                           // 선택된 아이템의 텍스트 크기 설정.
      unselectedFontSize: 13,                                         // 비선택된 아이템의 텍스트 크기 설정.
      onTap: (int index) {                                            // 각 아이템이 선택되었을 때의 동작 정의.
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/homeStaff');               // 홈 아이템을 선택하면 직원 홈으로 이동.
            break;
          case 1:
            Navigator.pushNamed(context, '/regRestaurant');           // 음식점 등록 아이템을 선택하면 음식점 등록 페이지로 이동.
            break;
          case 2:
            Navigator.pushNamed(context, '/MenuRegList');             // 메뉴 등록 아이템을 선택하면 메뉴 등록 페이지로 이동.
            break;
          case 3:
            _showNumberConfirmDialog(context);                        // 음식점 수정 아이템을 선택하면 등록번호 확인 다이얼로그 표시.
            break;
          case 4:
            Navigator.pushNamed(context, '/menuEdit');                // 메뉴 수정 아이템을 선택하면 메뉴 수정 페이지로 이동.
            break;
          case 5:
            Navigator.pushNamed(context, '/staffProfile');            // 프로필 아이템을 선택하면 직원 프로필 페이지로 이동.
            break;
          default:
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),  // 홈 아이템 추가.
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '음식점 등록'), // 음식점 등록 아이템 추가.
        BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: '메뉴 등록'), // 메뉴 등록 아이템 추가.
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: '음식점 수정'), // 음식점 수정 아이템 추가.
        BottomNavigationBarItem(icon: Icon(Icons.local_dining), label: '메뉴 수정'), // 메뉴 수정 아이템 추가.
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '프로필'), // 프로필 아이템 추가.
      ],
    );
  }
}
