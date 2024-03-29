import 'package:flutter/material.dart';
import 'startPage.dart';
import 'login.dart';
import 'nonMember.dart';
import 'signUp.dart';
import 'memberInfo.dart';
import 'findID.dart';
import 'findPassword.dart';
import 'regRestaurant.dart';
import 'restaurantInfo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => login(),
        '/c': (context) => nonMember(),
        '/signup': (context) => signup(),
        '/memberInfo': (context) => memberInfo(),
        '/findID': (context) => findID(),
        '/findPassword': (context) => findPassword(),
        '/regRestaurant': (context) => regRestaurant(),
      },
    );
  }
}
