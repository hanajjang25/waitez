import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Positioned(
                  left: (MediaQuery.of(context).size.width - 350),
                  top: (MediaQuery.of(context).size.height - 750),
                  child: Container(
                    width: 232,
                    height: 232,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage("https://via.placeholder.com/232x232"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    width: 375,
                    height: 812,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.47999998927116394),
                    ),
                  ),
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 450),
                  top: (MediaQuery.of(context).size.height - 600),
                  child: Container(
                    width: 450,
                    height: 600,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 250),
                  top: (MediaQuery.of(context).size.height - 580),
                  child: Container(
                    width: 48,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 4,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFD2D4D8),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 370),
                  top: (MediaQuery.of(context).size.height - 550),
                  child: Container(
                    width: 238,
                    height: 31,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 195,
                          top: 0,
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF1A94FF),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 231,
                            height: 31,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Text(
                                    'Create Account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF89909E),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 203,
                                  top: 31,
                                  child: Container(
                                    width: 28,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 2,
                                          strokeAlign:
                                              BorderSide.strokeAlignCenter,
                                          color: Color(0xFF1A94FF),
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
                Positioned(
                  left: (MediaQuery.of(context).size.width - 400),
                  top: (MediaQuery.of(context).size.height - 480),
                  child: Container(
                    width: 327,
                    height: 82,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 15,
                          child: Text(
                            'Email address',
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0.18,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 34,
                          child: Container(
                            width: 327,
                            height: 48,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 12,
                                  top: 6,
                                  child: Text(
                                    'Eg namaemail@emailkamu.com',
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 0.25,
                                      letterSpacing: 0.24,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 327,
                                    height: 48,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: Color(0xFFBEC5D1)),
                                        borderRadius: BorderRadius.circular(12),
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
                Positioned(
                  left: (MediaQuery.of(context).size.width - 400),
                  top: (MediaQuery.of(context).size.height - 370),
                  child: Container(
                    width: 327,
                    height: 82,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0.18,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 34,
                          child: Container(
                            width: 327,
                            height: 48,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 12,
                                  top: 9,
                                  child: Text(
                                    '**** **** ****',
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0.25,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 327,
                                    height: 48,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: Color(0xFFBEC5D1)),
                                        borderRadius: BorderRadius.circular(12),
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
                Positioned(
                  left: (MediaQuery.of(context).size.width - 360),
                  top: (MediaQuery.of(context).size.height - 230),
                  child: Container(
                    width: 256,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 64, vertical: 16),
                    decoration: ShapeDecoration(
                      color: Color(0xFFF4F4F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 360),
                  top: (MediaQuery.of(context).size.height - 160),
                  child: Container(
                    width: 256,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 64, vertical: 16),
                    decoration: ShapeDecoration(
                      color: Color(0xFFF4F4F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Login with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 305),
                  top: (MediaQuery.of(context).size.height - 170),
                  child: Container(
                    width: 148,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFD2D4D8),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 200),
                  top: (MediaQuery.of(context).size.height - 260),
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Color(0xFF1A94FF),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0.18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
