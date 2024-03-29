import 'package:flutter/material.dart';

class memberInfo extends StatelessWidget {
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
                '회원정보',
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
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), // 테두리 설정
                        borderRadius: BorderRadius.zero,
                        color: Colors.grey.withOpacity(0.1), // 비활성 상태일 때의 배경색
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0), // 내부 패딩 설정
                        child: Text(
                          '아이디',
                          style: TextStyle(
                            color: Colors.grey, // 텍스트 색상 설정
                          ),
                        ),
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
                            MaterialStateProperty.resolveWith<Color>(
                          (states) {
                            // 버튼의 배경색 지정
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.grey; // 비활성 상태일 때 배경색
                            }
                            return Colors.transparent; // 활성 상태일 때 배경색
                          },
                        ),
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
                  labelText: '기존 비밀번호',
                ),
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
            Row(
              children: [
                SizedBox(width: 10), // 왼쪽 여백
                SizedBox(
                  width: 100,
                  height: 50,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Colors.transparent;
                      }),
                    ),
                    child: Center(
                      child: Text(
                        '회원탈퇴',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
