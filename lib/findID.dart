import 'package:flutter/material.dart';

class findID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 70),
              child: Card(
                elevation: 3,
                shadowColor: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        '아이디 찾기',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2), // 양쪽에 50의 여백 추가
                        child: Container(
                          height: 1,
                          width: double.maxFinite,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 50),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '이름',
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '전화번호',
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // 가운데 정렬을 위한 MainAxisAlignment 설정
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text('아이디 찾기'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2), // 양쪽에 50의 여백 추가
                        child: Container(
                          height: 1,
                          width: double.maxFinite,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 150),
                    ],
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
