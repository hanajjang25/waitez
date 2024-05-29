import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'MemberHistory.dart';
import 'UserBottom.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.07,
            letterSpacing: -0.27,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/malatang.png")),
              SizedBox(height: 10),
              Text(
                '최승찰',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 80),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/memberInfo');
                      },
                      child: Text('회원정보 수정'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/memberInfo');
                      },
                      child: Text('로그아웃'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('hello@gmail.com'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('(82) 1234-5678'),
                ],
              ),
              SizedBox(height: 30),
              SingleChildScrollView(
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Past Reservations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ReservationCard(
                    imageAsset: "assets/images/malatang.png",
                    restaurantName: '마라마라탕탕',
                    date: '3/20/22 5:30 PM',
                    buttonText: '자세히 보기',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => History(
                            restaurantName: '마라마라탕탕',
                            date: '3/20/22 5:30 PM',
                            imageAsset: 'assets/images/malatang.png',
                            menuItems: ['마라탕', '마라샹궈', '우육면'],
                          ),
                        ),
                      );
                    },
                  ),
                  ReservationCard(
                    imageAsset: "assets/images/malatang.png",
                    restaurantName: '김밥헤븐',
                    date: '2/14/22 8:30 PM',
                    buttonText: '자세히 보기',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => History(
                            restaurantName: '김밥헤븐',
                            date: '2/14/22 8:30 PM',
                            imageAsset: 'assets/images/malatang.png',
                            menuItems: ['김밥', '떡볶이', '순대'],
                          ),
                        ),
                      );
                    },
                  ),
                  ReservationCard(
                    imageAsset: "assets/images/malatang.png",
                    restaurantName: '뜨르들로로',
                    date: '1/15/22 7:00 PM',
                    buttonText: '자세히 보기',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => History(
                            restaurantName: '뜨르들로로',
                            date: '1/15/22 7:00 PM',
                            imageAsset: 'assets/images/malatang.png',
                            menuItems: ['뜨르들로', '아메리카노', '패스츄리'],
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String imageAsset;
  final String restaurantName;
  final String date;
  final String buttonText;
  final VoidCallback onPressed;

  ReservationCard({
    required this.imageAsset,
    required this.restaurantName,
    required this.date,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(imageAsset),
        title: Text(restaurantName),
        subtitle: Text(date),
        trailing: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ),
    );
  }
}
