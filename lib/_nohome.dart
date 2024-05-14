import 'package:flutter/material.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 448,
          height: 949,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 42,
                child: Container(
                  width: 16,
                  height: 12,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 12,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 6,
                        child: Container(
                          width: 16,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 12,
                        child: Container(
                          width: 12,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF374151),
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
                left: 396,
                top: 32,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/32x32"),
                      fit: BoxFit.fill,
                    ),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 178,
                top: 32,
                child: Text(
                  'Agrabad 435, Chittagong',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0.19,
                  ),
                ),
              ),
              Positioned(
                left: 156,
                top: 40,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: FlutterLogo(),
                ),
              ),
              Positioned(
                left: 71,
                top: 82,
                child: Container(
                  width: 327,
                  height: 36,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 327,
                          height: 36,
                          decoration: ShapeDecoration(
                            color: Color(0xFFE6E7E9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 31.53,
                        top: 4,
                        child: Container(
                          width: 73.57,
                          height: 28,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 25.69,
                                top: 0,
                                child: SizedBox(
                                  width: 47.88,
                                  child: Text(
                                    'Search',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 0.19,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 6,
                                child: Container(
                                  width: 18.69,
                                  height: 16,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: FlutterLogo(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 500,
                top: 380,
                child: Container(
                  width: 148,
                  height: 196,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 148,
                          height: 196,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          width: 128,
                          height: 166,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 128,
                                  height: 103.30,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 128,
                                          height: 103.30,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFC4C4C4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 142,
                                        top: 0,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(1.57),
                                          child: Container(
                                            width: 103.51,
                                            height: 156,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://via.placeholder.com/104x156"),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
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
                                left: 0,
                                top: 119.22,
                                child: Container(
                                  width: 128,
                                  height: 46.78,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: SizedBox(
                                          width: 128,
                                          height: 18.91,
                                          child: Text(
                                            'Dumpling',
                                            style: TextStyle(
                                              color: Color(0xFF1F2937),
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 22.89,
                                        child: Container(
                                          width: 128,
                                          height: 23.89,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 1,
                                                child: Container(
                                                  width: 8.30,
                                                  height: 10.95,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://via.placeholder.com/8x11"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 14,
                                                top: 0,
                                                child: SizedBox(
                                                  width: 114,
                                                  height: 23.89,
                                                  child: Text(
                                                    'Ambrosia Hotel &\nRestaurant',
                                                    style: TextStyle(
                                                      color: Color(0xFF6B7280),
                                                      fontSize: 10,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 49,
                top: 509,
                child: Container(
                  width: 344.97,
                  height: 38,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 217,
                          height: 38,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 1,
                                top: 0,
                                child: Text(
                                  'Explore Restaurant',
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 23,
                                child: SizedBox(
                                  width: 217,
                                  child: Text(
                                    'Check your city Near by Restaurant',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 290,
                        top: 1,
                        child: Container(
                          width: 54.97,
                          height: 36,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 61,
                top: 660,
                child: Container(
                  width: 340,
                  height: 88,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 340,
                          height: 88,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x0F222222),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/64x64"),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 91,
                        top: 20,
                        child: Container(
                          width: 137,
                          height: 49,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 25,
                                child: Container(
                                  width: 137,
                                  height: 24,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 4,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: FlutterLogo(),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        top: 0,
                                        child: SizedBox(
                                          width: 117,
                                          child: Text(
                                            'Zakir Hossain Rd, Chittagong',
                                            style: TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 1,
                                top: 0,
                                child: Text(
                                  'Tava Restaurant',
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 240,
                        top: 48,
                        child: Container(
                          width: 88,
                          height: 28,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 88,
                                  height: 28,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF1A94FF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 29,
                                top: 6,
                                child: Text(
                                  'Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 61,
                top: 754,
                child: Container(
                  width: 340,
                  height: 88,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 340,
                          height: 88,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x0F222222),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/64x64"),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 91,
                        top: 20,
                        child: Container(
                          width: 137,
                          height: 49,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 25,
                                child: Container(
                                  width: 137,
                                  height: 24,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 4,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: FlutterLogo(),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        top: 0,
                                        child: SizedBox(
                                          width: 117,
                                          child: Text(
                                            '6 Surson Road, Chittagong',
                                            style: TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 1,
                                top: 0,
                                child: Text(
                                  'Haatkhola',
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 240,
                        top: 48,
                        child: Container(
                          width: 88,
                          height: 28,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 88,
                                  height: 28,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF1A94FF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 29,
                                top: 6,
                                child: Text(
                                  'Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 61,
                top: 566,
                child: Container(
                  width: 340,
                  height: 88,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 340,
                          height: 88,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x0F222222),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/64x64"),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 91,
                        top: 20,
                        child: Container(
                          width: 224,
                          height: 49,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 25,
                                child: Container(
                                  width: 137,
                                  height: 24,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 4,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: FlutterLogo(),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        top: 0,
                                        child: SizedBox(
                                          width: 117,
                                          child: Text(
                                            'kazi Deiry, Taiger Pass\nChittagong',
                                            style: TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 1,
                                top: 0,
                                child: Text(
                                  'Ambrosia Hotel & Restaurant',
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 240,
                        top: 48,
                        child: Container(
                          width: 88,
                          height: 28,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 88,
                                  height: 28,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF1A94FF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 29,
                                top: 6,
                                child: Text(
                                  'Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -13,
                top: 886,
                child: Container(
                  width: 375,
                  height: 64,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 14,
                        top: 1,
                        child: Container(
                          width: 448,
                          height: 64,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x16000000),
                                blurRadius: 14,
                                offset: Offset(0, -5),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 288,
                        top: 16,
                        child: Container(
                          width: 32,
                          height: 32,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: FlutterLogo(),
                        ),
                      ),
                      Positioned(
                        left: 56,
                        top: 14,
                        child: Container(
                          width: 36,
                          height: 36,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: FlutterLogo(),
                        ),
                      ),
                      Positioned(
                        left: 172,
                        top: 14,
                        child: Container(
                          width: 36,
                          height: 36,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: FlutterLogo(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 374,
                top: 903,
                child: Container(
                  width: 32,
                  height: 32,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: FlutterLogo(),
                ),
              ),
              Positioned(
                left: 52,
                top: 156,
                child: Container(
                  height: 310,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 310,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 310,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 154,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 72,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                "https://via.placeholder.com/108x72"),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Opacity(
                                                              opacity: 0,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 36,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      left: 0,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 36,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 72,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Opacity(
                                                              opacity: 0,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 36,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      left: 0,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 36,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 72,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 42,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                      child:
                                                                          Text(
                                                                        '매장',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFF27272A),
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              0.09,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                'for here',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF7F7F89),
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0.12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Transform(
                                                transform: Matrix4.identity()
                                                  ..translate(0.0, 0.0)
                                                  ..rotateZ(-1.57),
                                                child: Container(
                                                    width: 48,
                                                    child: FlutterLogo()),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 72,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                "https://via.placeholder.com/108x72"),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Opacity(
                                                              opacity: 0,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 36,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      left: 0,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 36,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 72,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Opacity(
                                                              opacity: 0,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 36,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      left: 0,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 36,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 72,
                                                                      top: 0,
                                                                      child:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.70,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 0.50, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Opacity(
                                                                                opacity: 0.70,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: 18,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Transform(
                                                                                        transform: Matrix4.identity()
                                                                                          ..translate(0.0, 0.0)
                                                                                          ..rotateZ(-0.52),
                                                                                        child: Container(
                                                                                          width: double.infinity,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.50,
                                                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 42,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                      child:
                                                                          Text(
                                                                        '포장',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFF27272A),
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              0.09,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                'to go',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF7F7F89),
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0.12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    height: 144,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 112,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                      child:
                                                                          Text(
                                                                        '예약하기',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFF27272A),
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              0.09,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                'resrvation',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF7F7F89),
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0.12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 108,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              "https://via.placeholder.com/108x72"),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Opacity(
                                                            opacity: 0,
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 36,
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    left: 0,
                                                                    top: 0,
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.70,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(width: 0.50, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 36,
                                                                    top: 0,
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.70,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(width: 0.50, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 72,
                                                                    top: 0,
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.70,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(width: 0.50, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Opacity(
                                                            opacity: 0,
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 36,
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    left: 0,
                                                                    top: 0,
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.70,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(width: 0.50, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 36,
                                                                    top: 0,
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.70,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(width: 0.50, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 72,
                                                                    top: 0,
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.70,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(width: 0.50, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Opacity(
                                                                              opacity: 0.70,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 18,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Transform(
                                                                                      transform: Matrix4.identity()
                                                                                        ..translate(0.0, 0.0)
                                                                                        ..rotateZ(-0.52),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                              width: 0.50,
                                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 32,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12),
                                                            decoration:
                                                                ShapeDecoration(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Color(
                                                                        0xFF1A94FF)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child: Stack(
                                                                    children: [
                                                                      Positioned(
                                                                        left:
                                                                            1.67,
                                                                        top:
                                                                            1.67,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              16.67,
                                                                          height:
                                                                              16.67,
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          decoration:
                                                                              BoxDecoration(),
                                                                          child:
                                                                              FlutterLogo(),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Reserve a table',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF1A94FF),
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        0.11,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      height: 32,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 32,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12),
                                                            decoration:
                                                                ShapeDecoration(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Color(
                                                                        0xFF1A94FF)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'My reservations',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF1A94FF),
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        0.11,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
