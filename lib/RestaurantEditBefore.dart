import 'package:flutter/material.dart';
import 'RestaurantEdit.dart';

class RestaurantEditBefore extends StatefulWidget {                   // 음식점 수정을 위한 StatefulWidget 클래스.
  @override
  _EnterRegistrationNumberPageState createState() =>
      _EnterRegistrationNumberPageState();                            // 상태를 관리할 State 생성.
}

class _EnterRegistrationNumberPageState extends State<RestaurantEditBefore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음식점 수정'),                                    // 앱 바의 제목 설정.
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),                        // 모든 가장자리에 16px의 패딩 추가.
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,                         // 자식 위젯들의 최소 크기로 높이 설정.
              children: [
                Text(
                  '음식점 수정',                                      // 페이지 제목 텍스트.
                  style: TextStyle(
                    fontSize: 18,                                     // 텍스트 크기 설정.
                    fontWeight: FontWeight.bold,                      // 텍스트를 굵게 설정.
                  ),
                ),
                SizedBox(height: 20),                                 // 제목과 입력 필드 사이에 20px 간격 추가.
                TextFormField(
                  decoration: InputDecoration(labelText: '등록번호를 입력하세요.'), // 입력 필드의 라벨 설정.
                  validator: (value) {
                    if (value == null || value.isEmpty) {             // 값이 비어있는 경우.
                      return '등록번호를 입력하세요.';                 // 오류 메시지 반환.
                    }
                    return null;                                      // 모든 조건을 통과하면 오류 없음.
                  },
                ),
                SizedBox(height: 20),                                 // 입력 필드와 버튼 사이에 20px 간격 추가.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,        // 버튼들을 중앙에 정렬.
                  children: [
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),                        // 버튼의 모서리를 둥글게 설정.
                        )),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => editregRestaurant(), // 확인 버튼을 누르면 음식점 수정 페이지로 이동.
                          ),
                        );
                      },
                      child: Text('확인'),                            // 버튼 텍스트 설정.
                    ),
                    SizedBox(width: 10),                              // 두 버튼 사이에 10px 간격 추가.
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),                        // 버튼의 모서리를 둥글게 설정.
                        )),
                      ),
                      onPressed: () {
                        Navigator.pop(context);                       // 취소 버튼을 누르면 이전 화면으로 돌아감.
                      },
                      child: Text('취소'),                            // 버튼 텍스트 설정.
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditRegRestaurantPage extends StatelessWidget {                 // 음식점 수정 페이지를 나타내는 StatelessWidget.
  final String registrationNumber;                                    // 수정할 음식점의 등록번호를 저장할 변수.

  EditRegRestaurantPage({required this.registrationNumber});          // 생성자에서 등록번호를 받아 초기화.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Restaurant'),                               // 앱 바의 제목 설정.
      ),
      body: Center(
        child: Text(
            'Editing restaurant with registration number: $registrationNumber'), // 등록번호에 따라 음식점을 수정하는 페이지 텍스트 표시.
      ),
    );
  }
}
