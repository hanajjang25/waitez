import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                    Navigator.pushNamed(context, '/c');
                  },
                  child: Text('비회원')),
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
                    Navigator.pushNamed(context, '/findID');
                  },
                  child: Text('아이디찾기')),
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
            ],
          ),
        ]),
      ),
    );
  }
}
