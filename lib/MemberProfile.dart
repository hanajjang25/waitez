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
  String nickname = ''; // 닉네임 저장 변수
  String email = ''; // 이메일 저장 변수
  String phone = ''; // 전화번호 저장 변수
  List<Map<String, dynamic>> reservations = []; // 예약 내역을 저장할 리스트

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // 초기화 시 사용자 데이터를 가져옴
  }

  // Firestore에서 사용자 데이터를 가져오는 함수
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          nickname = userDoc['nickname'] ?? 'Unknown'; // 닉네임 설정
          email = user.email ?? 'Unknown'; // 이메일 설정
          phone = userDoc['phoneNum'] ?? 'Unknown'; // 전화번호 설정
        });
        // 닉네임 설정 후 예약 내역을 가져옴
        await _fetchReservations(userDoc['nickname'] ?? 'Unknown');
      }
    }
  }

  // 예약 내역을 Firestore에서 가져오는 함수
  Future<void> _fetchReservations(String nickname) async {
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('nickname', isEqualTo: nickname) // 닉네임으로 필터링
        .orderBy('timestamp', descending: true) // 최신순 정렬
        .limit(3) // 최근 예약 3개만 가져오기
        .get();

    List<Map<String, dynamic>> fetchedReservations = [];

    for (var doc in reservationQuery.docs) {
      var reservation = doc.data();
      reservation['id'] = doc.id; // 예약 ID를 포함
      var restaurantId = reservation['restaurantId'];

      var restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .get();

      if (restaurantDoc.exists) {
        var restaurantData = restaurantDoc.data();
        reservation['restaurantName'] =
            restaurantData?['restaurantName'] ?? 'Unknown'; // 식당 이름 설정
        reservation['restaurantPhoto'] =
            restaurantData?['photoUrl'] ?? 'assets/images/memberImage.png'; // 식당 사진 설정
        reservation['address'] = restaurantData?['location'] ?? 'Unknown'; // 식당 주소 설정
        reservation['operatingHours'] =
            restaurantData?['businessHours'] ?? 'Unknown'; // 영업시간 설정
        reservation['type'] = (reservation['type'] == 1)
            ? '매장'
            : (reservation['type'] == 2)
                ? '포장'
                : 'Unknown'; // 방문 형태 설정
        reservation['menuItems'] = await _fetchMenuItems(reservation['id']); // 메뉴 아이템 설정
        fetchedReservations.add(reservation);
      } else {
        // 식당 정보가 없을 경우 기본값 설정
        reservation['restaurantName'] = 'Unknown';
        reservation['restaurantPhoto'] = 'assets/images/memberImage.png';
        reservation['address'] = 'Unknown';
        reservation['operatingHours'] = 'Unknown';
        reservation['type'] = 'Unknown';
        reservation['menuItems'] = [];
      }
    }

    setState(() {
      reservations = fetchedReservations; // 가져온 예약 내역을 상태에 설정
    });
  }

  // 메뉴 아이템을 Firestore에서 가져오는 함수
  Future<List<Map<String, dynamic>>> _fetchMenuItems(
      String reservationId) async {
    final cartQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .collection('cart') // 예약 문서의 cart 컬렉션에 접근
        .get();

    List<Map<String, dynamic>> menuItems = [];
    for (var doc in cartQuery.docs) {
      var item = doc.data();
      var menuItem = item['menuItem'];
      if (menuItem != null) {
        int quantity = 0;
        int price = 0;

        if (menuItem['quantity'] is int) {
          quantity = menuItem['quantity']; // 수량 설정
        } else if (menuItem['quantity'] is String) {
          quantity = int.tryParse(menuItem['quantity']) ?? 0; // 수량 문자열을 정수로 변환
        }

        if (menuItem['price'] is int) {
          price = menuItem['price']; // 가격 설정
        } else if (menuItem['price'] is String) {
          price = int.tryParse(menuItem['price']) ?? 0; // 가격 문자열을 정수로 변환
        }

        menuItems.add({
          'name': menuItem['menuName'] ?? 'Unknown', // 메뉴 이름
          'price': price, // 메뉴 가격
          'quantity': quantity, // 메뉴 수량
        });
      }
    }
    return menuItems; // 메뉴 아이템 리스트 반환
  }

  // 로그아웃 처리 함수
  Future<void> _logout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'isLoggedIn': false, // 로그아웃 상태로 업데이트
      });
      await FirebaseAuth.instance.signOut(); // 로그아웃
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // 로그인 페이지로 이동
    }
  }

  // 로그아웃 확인 대화상자 표시 함수
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
                Navigator.of(context).pop(); // 대화상자 닫기
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
                _logout(context); // 로그아웃 처리
              },
            ),
          ],
        );
      },
    );
  }

  // 타임스탬프를 포맷팅하여 반환하는 함수
  String formatDate(Timestamp timestamp) {
    var date = timestamp.toDate();
    var localDate = date.toLocal(); // 로컬 시간대로 변환
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(localDate); // yyyy-MM-dd 형식으로 날짜 반환
  }

  // 더보기 버튼 클릭 시 호출되는 함수
  void _onMorePressed() {
    Navigator.pushNamed(context, '/historyList'); // 이력 조회 페이지로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로필',
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
              Navigator.pushNamed(context, '/setting'); // 설정 페이지로 이동
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 사용자 아바타
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/memberImage.png"),
              ),
              SizedBox(height: 10),
              // 사용자 닉네임
              Text(
                nickname,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // 회원정보 수정 및 로그아웃 버튼
              Padding(
                padding: EdgeInsets.only(left: 80),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/memberInfo'); // 회원정보 수정 페이지로 이동
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
                        _confirmLogout(context); // 로그아웃 확인 대화상자 표시
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
              // 이메일 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(email),
                ],
              ),
              SizedBox(height: 10),
              // 전화번호 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(phone),
                ],
              ),
              SizedBox(height: 30),
              // 이력 조회 제목 및 더보기 버튼
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
                TextButton(
                  onPressed: _onMorePressed, // 더보기 버튼 클릭 시
                  child: Text(
                    '더보기 > ',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 17,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              // 예약 내역 카드
              ...reservations.map((reservation) {
                return ReservationCard(
                  imageAsset: reservation['restaurantPhoto'] ?? '',
                  restaurantName: reservation['restaurantName'] ?? '',
                  date: formatDate(reservation['timestamp']),
                  onPressed: () {},
                );
              }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: menuButtom(), // 하단 네비게이션 바
    );
  }
}

// 예약 내역 카드 위젯
class ReservationCard extends StatelessWidget {
  final String imageAsset; // 식당 이미지
  final String restaurantName; // 식당 이름
  final String date; // 예약 날짜
  final VoidCallback onPressed; // 클릭 시 호출되는 콜백 함수

  ReservationCard({
    required this.imageAsset,
    required this.restaurantName,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: Colors.blue[50],
        leading: SizedBox(
          width: 50, // 적절한 크기로 제한
          child: imageAsset.startsWith('http')
              ? Image.network(imageAsset, fit: BoxFit.cover) // 네트워크 이미지
              : Image.asset(imageAsset, fit: BoxFit.cover), // 로컬 이미지
        ),
        title: Text(restaurantName), // 식당 이름 표시
        subtitle: Text(date), // 예약 날짜 표시
      ),
    );
  }
}
