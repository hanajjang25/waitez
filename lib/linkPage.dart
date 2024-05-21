import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Waitez'),
          Wrap(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('로그인')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('회원가입')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/memberInfo');
                  },
                  child: Text('회원정보')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/findPassword');
                  },
                  child: Text('비밀번호찾기')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/regRestaurant');
                  },
                  child: Text('음식점 등록')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/waitingNumber');
                  },
                  child: Text('대기순번')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/restaurantInfo');
                  },
                  child: Text('음식점정보')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  child: Text('검색')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('home')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/favorite');
                  },
                  child: Text('즐겨찾기')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homeStaff');
                  },
                  child: Text('직원home')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/editRestaurant');
                  },
                  child: Text('음식점 수정')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Text('장바구니')),
            ],
          ),
        ]),
      ),
    );
  }
}
