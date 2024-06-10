import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'MemberHistory.dart';
import 'UserBottom.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nickname = '';
  String email = '';
  String phone = '';
  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          nickname = userDoc['nickname'] ?? 'Unknown';
          email = user.email ?? 'Unknown';
          phone = userDoc['phoneNum'] ?? 'Unknown';
        });
        // nickname을 설정한 후에 reservations를 가져옴
        await _fetchReservations(userDoc['nickname'] ?? 'Unknown');
      }
    }
  }

  Future<void> _fetchReservations(String nickname) async {
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('nickname', isEqualTo: nickname) // nickname으로 필터링
        .orderBy('timestamp', descending: true)
        .limit(3) // 최근 예약 3개만 가져오기
        .get();

    List<Map<String, dynamic>> fetchedReservations = [];

    for (var doc in reservationQuery.docs) {
      var reservation = doc.data();
      var restaurantId = reservation['restaurantId'];

      var restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .get();

      if (restaurantDoc.exists) {
        var restaurantData = restaurantDoc.data();
        reservation['restaurantName'] =
            restaurantData?['restaurantName'] ?? 'Unknown';
        reservation['restaurantPhoto'] =
            restaurantData?['photoUrl'] ?? 'assets/images/malatang.png';
      } else {
        reservation['restaurantName'] = 'Unknown';
        reservation['restaurantPhoto'] = 'assets/images/malatang.png';
      }

      fetchedReservations.add(reservation);
    }

    setState(() {
      reservations = fetchedReservations;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'isLoggedIn': false,
      });
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('로그아웃 하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  String formatDate(Timestamp timestamp) {
    var date = timestamp.toDate();
    var localDate = date.toLocal(); // 로컬 시간대로 변환
    var formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(localDate);
  }

  void _onMorePressed() {
    Navigator.pushNamed(context, '/historyList');
  }

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
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
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
                backgroundImage: AssetImage("assets/images/malatang.png"),
              ),
              SizedBox(height: 10),
              Text(
                nickname,
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
                        _confirmLogout(context);
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
                  Text(email),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(phone),
                ],
              ),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '이력조회',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _onMorePressed,
                  child: Text(
                    '더보기 > ',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 15,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                )
              ]),
              SizedBox(height: 10),
              ...reservations.map((reservation) {
                return ReservationCard(
                  imageAsset: reservation['restaurantPhoto'] ??
                      'assets/images/malatang.png',
                  restaurantName: reservation['restaurantName'] ?? 'Unknown',
                  date: formatDate(reservation['timestamp']),
                  buttonText: '자세히 보기',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => History(
                          restaurantName:
                              reservation['restaurantName'] ?? 'Unknown',
                          date: formatDate(reservation['timestamp']),
                          imageAsset: reservation['restaurantPhoto'] ??
                              'assets/images/malatang.png',
                          menuItems: reservation['menuItems'] ?? [],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
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
        leading: Image.network(imageAsset),
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
