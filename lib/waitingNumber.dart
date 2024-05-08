import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class waitingNumber extends StatelessWidget {
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
                left: (MediaQuery.of(context).size.width - 80),
                top: 99,
                child: Container(
                  width: 20,
                  height: 11,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 20,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 6,
                        child: Container(
                          width: 20,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 210),
                top: 90,
                child: Container(
                  width: 36.43,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/36x30"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 180),
                top: 92,
                child: SizedBox(
                  width: 69,
                  height: 28,
                  child: Text(
                    '최승철',
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
                left: (MediaQuery.of(context).size.width - 100),
                top: 110,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(-3.14),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: StarBorder.polygon(sides: 3),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 435),
                top: (MediaQuery.of(context).size.height - 70),
                child: Container(
                  width: 100,
                  height: 60.08,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFDCD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 330),
                top: (MediaQuery.of(context).size.height - 70),
                child: Container(
                  width: 100,
                  height: 60.08,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFDCD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 225),
                top: (MediaQuery.of(context).size.height - 70),
                child: Container(
                  width: 100,
                  height: 60.08,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFDCD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 120),
                top: (MediaQuery.of(context).size.height - 70),
                child: Container(
                  width: 100,
                  height: 60.08,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFDCD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 430),
                top: (MediaQuery.of(context).size.height - 50),
                child: SizedBox(
                  width: 90,
                  height: 41,
                  child: Text(
                    '대기순번',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w900,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 325),
                top: (MediaQuery.of(context).size.height - 50),
                child: SizedBox(
                  width: 90,
                  height: 41,
                  child: Text(
                    '이력조회',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w900,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 220),
                top: (MediaQuery.of(context).size.height - 50),
                child: SizedBox(
                  width: 90,
                  height: 41,
                  child: Text(
                    '커뮤니티',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w900,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 115),
                top: (MediaQuery.of(context).size.height - 50),
                child: SizedBox(
                  width: 90,
                  height: 41,
                  child: Text(
                    '즐겨찾기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w900,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 400),
                top: (MediaQuery.of(context).size.height - 680),
                child: Container(
                  width: 330,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 400),
                top: (MediaQuery.of(context).size.height - 480),
                child: Container(
                  width: 330,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 400),
                top: (MediaQuery.of(context).size.height - 400),
                child: Container(
                  width: 330,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 390),
                top: (MediaQuery.of(context).size.height - 670),
                child: Container(
                  width: 58,
                  height: 53,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 58,
                          height: 53,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFFFDCD),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 12,
                        child: SizedBox(
                          width: 38,
                          height: 35,
                          child: Text(
                            '13',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w900,
                              height: 0,
                              letterSpacing: -0.30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 300),
                top: (MediaQuery.of(context).size.height - 655),
                child: SizedBox(
                  width: 130,
                  height: 30,
                  child: Text(
                    '김밥헤븐 단계점',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 390),
                top: (MediaQuery.of(context).size.height - 473),
                child: Container(
                  width: 58,
                  height: 53,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 58,
                          height: 53,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFFFDCD),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 9,
                        child: SizedBox(
                          width: 38,
                          height: 35,
                          child: Text(
                            '2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w900,
                              height: 0,
                              letterSpacing: -0.30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 300),
                top: (MediaQuery.of(context).size.height - 460),
                child: SizedBox(
                  width: 130,
                  height: 30,
                  child: Text(
                    '까눌렜네 단계점',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 390),
                top: (MediaQuery.of(context).size.height - 390),
                child: Container(
                  width: 58,
                  height: 53,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 58,
                          height: 53,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFFFDCD),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 9,
                        child: SizedBox(
                          width: 38,
                          height: 35,
                          child: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w900,
                              height: 0,
                              letterSpacing: -0.30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 300),
                top: (MediaQuery.of(context).size.height - 378),
                child: SizedBox(
                  width: 130,
                  height: 30,
                  child: Text(
                    '케이키 단계점',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 400),
                top: (MediaQuery.of(context).size.height - 750),
                child: SizedBox(
                  width: 69,
                  height: 28,
                  child: Text(
                    '매장',
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
                left: (MediaQuery.of(context).size.width - 410),
                top: (MediaQuery.of(context).size.height - 700),
                child: Container(
                  width: 350,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 400),
                top: (MediaQuery.of(context).size.height - 550),
                child: SizedBox(
                  width: 69,
                  height: 28,
                  child: Text(
                    '포장',
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
                left: (MediaQuery.of(context).size.width - 410),
                top: (MediaQuery.of(context).size.height - 500),
                child: Container(
                  width: 350,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
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
