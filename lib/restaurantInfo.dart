import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'UserReservation.dart'; // UserReservation 클래스를 임포트

class RestaurantInfo extends StatefulWidget {
  final String restaurantId;

  RestaurantInfo({required this.restaurantId, Key? key}) : super(key: key);

  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  bool isFavorite = false;
  Map<String, dynamic>? restaurantData;
  List<Map<String, dynamic>> menuItems = [];
  String? userNickname;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetails();
    _fetchMenuItems();
    _fetchUserNickname();
  }

  Future<void> _fetchUserNickname() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userNickname = userDoc['nickname'];
            _phoneController.text = userDoc['phoneNum'] ?? '';
          });
        } else {
          print('User not found');
        }
      }
    } catch (e) {
      print('Error fetching user nickname: $e');
    }
  }

  Future<void> _fetchRestaurantDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .get();
      if (doc.exists) {
        setState(() {
          restaurantData = doc.data() as Map<String, dynamic>?;
        });
      } else {
        print('Restaurant not found');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurant not found')),
        );
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _fetchMenuItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .collection('menus')
          .get();

      setState(() {
        menuItems = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching menu items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching menu items: $e')),
      );
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void navigateToDetails(Map<String, dynamic> menuItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetailsPage(menuItem: menuItem),
      ),
    );
  }

  Future<void> _saveReservation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      String nickname = userNickname ?? _nicknameController.text;

      if (nickname.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('닉네임을 입력해주세요.')),
        );
        return;
      }

      // 로그인이 되어 있지 않으면 non_members 테이블에서 닉네임 비교
      if (user == null) {
        final nonMemberQuery = await FirebaseFirestore.instance
            .collection('non_members')
            .where('nickname', isEqualTo: nickname)
            .get();

        if (nonMemberQuery.docs.isNotEmpty) {
          final nonMemberData = nonMemberQuery.docs.first.data();
          nickname = nonMemberData['nickname'];
          _phoneController.text = nonMemberData['phoneNum'];
        }
      }

      await FirebaseFirestore.instance.collection('reservations').add({
        'userId': user?.uid ?? 'guest',
        'nickname': nickname,
        'phone': _phoneController.text,
        'restaurantId': widget.restaurantId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation saved successfully')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Reservation()),
      ); // 예약하기 버튼 클릭 시 UserReservation 화면으로 이동
    } catch (e) {
      print('Error saving reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving reservation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (restaurantData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantData!['restaurantName'] ?? 'Unknown'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 358,
                height: 201,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(restaurantData!['photoUrl'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              restaurantData!['restaurantName'] ?? 'Unknown',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                children: [
                  Text(
                    '주소',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    restaurantData!['location'] ?? 'Unknown',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                children: [
                  Text(
                    '영업시간',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    restaurantData!['businessHours'] ?? 'Unknown',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'MENU',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menuItems[index];
                  return ListTile(
                    title: Text(menuItem['menuName'] ?? 'Unknown'),
                    subtitle: Text('${menuItem['price'] ?? '0'}원'),
                    onTap: () {},
                  );
                },
              ),
            ),
            if (userNickname == null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: '닉네임',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveReservation, // 예약하기 버튼 클릭 시 예약 정보 저장 및 화면 전환
                  child: Text('예약하기'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF1A94FF)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class MenuDetailsPage extends StatelessWidget {
  final Map<String, dynamic> menuItem;

  MenuDetailsPage({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menuItem['menuName'] ?? 'Unknown',
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            height: 0.07,
            letterSpacing: -0.27,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'MENU',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 0.07,
                letterSpacing: -0.27,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Container(
                width: 500,
                child: Divider(color: Colors.black, thickness: 2.0)),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 358,
                height: 201,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(menuItem['photoUrl'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              menuItem['menuName'] ?? 'Unknown',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 24,
                fontFamily: 'Epilogue',
                height: 0.07,
                letterSpacing: -0.27,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 50),
            Text(
              '가격: ${menuItem['price'] ?? '0'}원',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 20,
                fontFamily: 'Epilogue',
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 50),
            Text(
              menuItem['description'] ?? '상세 설명이 없습니다.',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('장바구니에 추가되었습니다.')),
                  );
                },
                child: Text('장바구니에 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
