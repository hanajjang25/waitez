import 'package:flutter/material.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: (MediaQuery.of(context).size.width - 300) / 2,
                top: (MediaQuery.of(context).size.height - 700),
                child: Container(
                  width: 300,
                  height: 456,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 300) / 2,
                top: (MediaQuery.of(context).size.height - 400) / 2,
                child: SizedBox(
                  width: 79,
                  height: 19,
                  child: Text(
                    '로그인',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 275) / 2,
                top: (MediaQuery.of(context).size.height - 340) / 2,
                child: Container(
                  width: 270,
                  height: 1, // 선의 높이
                  color: Colors.black, // 선의 색상
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 280) / 2,
                top: (MediaQuery.of(context).size.height - 300) / 2,
                child: Container(
                  width: 270,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFDCD),
                    shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 280) / 2,
                top: (MediaQuery.of(context).size.height - 150) / 2,
                child: Container(
                  width: 270,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFDCD),
                    shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 260) / 2,
                top: (MediaQuery.of(context).size.height - 280) / 2,
                child: SizedBox(
                  width: 40,
                  height: 30,
                  child: Text(
                    'Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 280) / 2,
                top: (MediaQuery.of(context).size.height - 130) / 2,
                child: SizedBox(
                  width: 87,
                  height: 30,
                  child: Text(
                    'Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 260) / 2,
                top: (MediaQuery.of(context).size.height + 120) / 2,
                child: SizedBox(
                  width: 87,
                  height: 30,
                  child: Text(
                    'Forgot Email?',
                    style: TextStyle(
                      color: Color(0xFF000AFF),
                      fontSize: 12,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 20) / 2,
                top: (MediaQuery.of(context).size.height + 120) / 2,
                child: SizedBox(
                  width: 136,
                  height: 30,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF000AFF),
                      fontSize: 12,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 275) / 2,
                top: (MediaQuery.of(context).size.height + 190) / 2,
                child: Container(
                  width: 270,
                  height: 1, // 선의 높이
                  color: Colors.black, // 선의 색상
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 260) / 2,
                top: (MediaQuery.of(context).size.height + 230) / 2,
                child: SizedBox(
                  width: 136,
                  height: 30,
                  child: Text(
                    'Waitez가 처음이신가요?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 180) / 2,
                top: (MediaQuery.of(context).size.height - 0) / 2,
                child: Container(
                  width: 160,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 110) / 2,
                top: (MediaQuery.of(context).size.height + 18) / 2,
                child: SizedBox(
                  width: 87,
                  height: 22,
                  child: Text(
                    '로그인',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 180) / 2,
                top: (MediaQuery.of(context).size.height + 300) / 2,
                child: Container(
                  width: 160,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 110) / 2,
                top: (MediaQuery.of(context).size.height + 320) / 2,
                child: SizedBox(
                  width: 87,
                  height: 30,
                  child: Text(
                    '회원가입',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
