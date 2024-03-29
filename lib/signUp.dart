import 'package:flutter/material.dart';

class signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // 양쪽에 50의 여백 추가
              child: Container(
                height: 1,
                width: double.maxFinite,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 70.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: '이름',
                  hintText: '※영어, 한글만 입력 가능합니다.',
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: '아이디',
                        hintText: '※아이디는 한번 설정 후 변경이 불가능합니다.',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    height: 60,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          // 버튼의 배경색 지정
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // 비활성 상태일 때 배경색
                          }
                          return Colors.transparent; // 활성 상태일 때 배경색
                        }),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black), // 테두리 설정
                            borderRadius: BorderRadius.circular(0), // 모서리 설정
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '중복확인',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black, // 텍스트 색상 설정
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 70.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: '비밀번호',
                  hintText: '※영어, 숫자, 특수문자 중 3종류 이상, 8자 이상',
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: '비밀번호 재입력',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    height: 60,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          // 버튼의 배경색 지정
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // 비활성 상태일 때 배경색
                          }
                          return Colors.transparent; // 활성 상태일 때 배경색
                        }),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black), // 테두리 설정
                            borderRadius: BorderRadius.circular(0), // 모서리 설정
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black, // 텍스트 색상 설정
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: '전화번호',
                        hintText: '예) 010-1234-5678',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    height: 60,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          // 버튼의 배경색 지정
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // 비활성 상태일 때 배경색
                          }
                          return Colors.transparent; // 활성 상태일 때 배경색
                        }),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black), // 테두리 설정
                            borderRadius: BorderRadius.circular(0), // 모서리 설정
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '인증번호 요청',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black, // 텍스트 색상 설정
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: '인증번호',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    height: 60,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          // 버튼의 배경색 지정
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // 비활성 상태일 때 배경색
                          }
                          return Colors.transparent; // 활성 상태일 때 배경색
                        }),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black), // 테두리 설정
                            borderRadius: BorderRadius.circular(0), // 모서리 설정
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black, // 텍스트 색상 설정
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                '사업자등록증',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text('파일 업로드'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text('회원가입'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
