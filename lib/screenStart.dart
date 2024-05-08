import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class screenStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFF2FFFF)),
          child: Stack(
            children: [
              Positioned(
                left: 52,
                top: 223,
                child: SizedBox(
                  width: 255,
                  height: 41,
                  child: Text(
                    'Waitez',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 60,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w900,
                      height: 0,
                      letterSpacing: -0.30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 70,
                top: 325,
                child: Container(
                  width: 246,
                  height: 246,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/246x246"),
                      fit: BoxFit.cover,
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
