import 'package:flutter/material.dart';                                    
import 'package:cloud_firestore/cloud_firestore.dart';                      
import 'package:firebase_auth/firebase_auth.dart';                           
import 'package:flutter/widgets.dart';                                      
import 'package:waitez/reservationBottom.dart';                              
import 'UserReservation.dart';                                              
import 'dart:async';                                                        
import 'reservationBottom.dart';                                             
import 'package:intl/intl.dart';                                             

class RestaurantInfo extends StatefulWidget {                                 // StatefulWidget을 확장한 RestaurantInfo 클래스 정의
  final String restaurantId;                                                 // 레스토랑 ID를 저장하는 final 변수 정의

  RestaurantInfo({required this.restaurantId, Key? key}) : super(key: key);  // 생성자에서 restaurantId를 초기화

  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();              // _RestaurantInfoState 클래스 생성
}

class _RestaurantInfoState extends State<RestaurantInfo> {                   // 상태를 관리하는 _RestaurantInfoState 클래스 정의
  bool isFavorite = false;                                                   // 즐겨찾기 상태를 나타내는 불리언 변수
  bool isOpen = false;                                                       // 레스토랑 오픈 여부를 나타내는 불리언 변수
  bool isWithinBusinessHours = false;                                        // 영업 시간 내인지 여부를 나타내는 불리언 변수
  Map<String, dynamic>? restaurantData;                                      // 레스토랑 정보를 담을 맵
  List<Map<String, dynamic>> menuItems = [];                                 // 메뉴 아이템을 담을 리스트
  Timer? _timer;                                                             // 타이머 변수 선언

  @override
  void initState() {                                                         // 위젯 초기화 시 호출되는 메서드
    super.initState();                                                       // 부모 클래스의 initState 호출
    _fetchRestaurantDetails();                                               // 레스토랑 상세 정보를 가져오는 함수 호출
    _fetchMenuItems();                                                       // 메뉴 아이템을 가져오는 함수 호출
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {                  // 매 분마다 실행되는 타이머 설정
      _checkBusinessHours();                                                 // 영업 시간 체크 함수 호출
    });
  }

  @override
  void dispose() {                                                           // 위젯이 소멸될 때 호출되는 메서드
    _timer?.cancel();                                                        // 타이머 해제
    super.dispose();                                                         // 부모 클래스의 dispose 호출
  }

  Future<void> _fetchRestaurantDetails() async {                             // 비동기로 레스토랑 상세 정보를 가져오는 메서드
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance                // Firestore에서 레스토랑 문서를 가져옴
          .collection('restaurants')                                         // 'restaurants' 컬렉션 참조
          .doc(widget.restaurantId)                                          // 해당 레스토랑 ID로 문서 참조
          .get();                                                            // 문서 가져오기
      if (doc.exists) {                                                      // 문서가 존재하는지 확인
        setState(() {                                                        // 상태 업데이트
          restaurantData = doc.data() as Map<String, dynamic>?;              // 레스토랑 데이터를 맵으로 저장
          _checkBusinessHours();                                             // 영업 시간 체크 함수 호출
        });
      } else {
        print('Restaurant not found');                                       // 문서를 찾지 못한 경우 콘솔에 메시지 출력
        ScaffoldMessenger.of(context).showSnackBar(                          // 사용자에게 스낵바로 알림
          SnackBar(content: Text('Restaurant not found')),
        );
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');                        // 오류 발생 시 콘솔에 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _fetchMenuItems() async {                                     // 비동기로 메뉴 아이템을 가져오는 메서드
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance         // Firestore에서 메뉴 컬렉션 가져옴
          .collection('restaurants')                                         // 'restaurants' 컬렉션 참조
          .doc(widget.restaurantId)                                          // 해당 레스토랑 ID로 문서 참조
          .collection('menus')                                               // 'menus' 서브컬렉션 참조
          .get();                                                            // 문서들 가져오기

      setState(() {
        menuItems = querySnapshot.docs                                        // 문서 리스트를 맵 리스트로 변환하여 menuItems에 저장
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching menu items: $e');                                // 오류 발생 시 콘솔에 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching menu items: $e')),
      );
    }
  }

  void toggleFavorite() {                                                    // 즐겨찾기 상태를 토글하는 메서드
    setState(() {
      isFavorite = !isFavorite;                                              // 현재 즐겨찾기 상태를 반전
    });
  }

  void navigateToDetails(Map<String, dynamic> menuItem) {                    // 메뉴 상세 화면으로 네비게이트하는 메서드
    Navigator.push(                                                          // 화면 전환을 위한 Navigator 사용
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetailsPage(menuItem: menuItem),           // MenuDetailsPage로 이동
      ),
    );
  }

  Future<void> _saveReservation() async {                                    // 예약 정보를 저장하는 메서드
    try {
      final user = FirebaseAuth.instance.currentUser;                        // 현재 사용자 가져오기

      if (user == null) {                                                    // 사용자가 없는 경우
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인이 필요합니다.')),                    // 스낵바로 로그인 필요 알림
        );
        return;
      }

      String nickname = '';
      String phone = '';

      // 사용자 정보를 확인
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_members')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (userDoc.exists) {                                                  // 사용자가 존재하는 경우
        nickname = (userDoc.data() as Map<String, dynamic>)['nickname'] ?? ''; // 닉네임 가져오기
        phone = (userDoc.data() as Map<String, dynamic>)['phoneNum'] ?? '';  // 전화번호 가져오기
      } else if (nonMemberQuery.docs.isNotEmpty) {                           // 비회원인 경우
        final nonMemberData =
            nonMemberQuery.docs.first.data() as Map<String, dynamic>;
        nickname = nonMemberData['nickname'] ?? '';                          // 비회원 닉네임 가져오기
        phone = nonMemberData['phoneNum'] ?? '';                             // 비회원 전화번호 가져오기
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 정보를 찾을 수 없습니다.')),            // 사용자 정보가 없을 경우 알림
        );
        return;
      }

      await FirebaseFirestore.instance.collection('reservations').add({      // Firestore에 예약 정보 저장
        'userId': user.uid,
        'nickname': nickname,
        'phone': phone,
        'restaurantId': widget.restaurantId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation saved successfully')),           // 예약 성공 알림
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Reservation()),              // 예약 화면으로 이동
      );
    } catch (e) {
      print('Error saving reservation: $e');                                 // 예약 저장 중 오류 발생 시 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving reservation: $e')),             // 오류 발생 시 사용자에게 알림
      );
    }
  }

  // 영업 시간 체크 메서드 추가
  void _checkBusinessHours() {                                               // 레스토랑의 영업 시간을 확인하는 메서드
    if (restaurantData == null) return;

    String businessHours = restaurantData!['businessHours'] ?? '';           // 영업 시간을 가져옴
    if (businessHours.isEmpty) return;

    List<String> hours = businessHours.split(' ~');                          // 영업 시간을 분리하여 리스트로 만듦
    if (hours.length != 2) return;

    try {
      DateTime now = DateTime.now();                                         // 현재 시간 가져오기
      DateFormat format = DateFormat('hh:mm a');                             // 시간 형식을 정의
      DateTime openTime = format.parse(hours[0].trim());                     // 오픈 시간 파싱
      DateTime closeTime = format.parse(hours[1].trim());                    // 종료 시간 파싱

      openTime = DateTime(
          now.year, now.month, now.day, openTime.hour, openTime.minute);     // 오늘 날짜에 맞게 오픈 시간 설정
      closeTime = DateTime(
          now.year, now.month, now.day, closeTime.hour, closeTime.minute);   // 오늘 날짜에 맞게 종료 시간 설정

      if (now.isAfter(openTime) && now.isBefore(closeTime)) {                // 현재 시간이 오픈과 종료 시간 사이인지 확인
        setState(() {
          isWithinBusinessHours = true;                                      // 영업 시간 내에 있는 경우 상태를 업데이트
        });
      } else {
        setState(() {
          isWithinBusinessHours = false;                                     // 영업 시간 외인 경우 상태를 업데이트
        });
      }
    } catch (e) {
      print('Error parsing business hours: $e');                             // 오류 발생 시 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing business hours: $e')),         // 오류 발생 시 사용자에게 알림
      );
    }
  }

  @override
  Widget build(BuildContext context) {                                       // UI 빌드 메서드
    if (restaurantData == null) {                                            // 레스토랑 데이터가 없는 경우 로딩 화면 표시
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
        title: Text(
          restaurantData!['restaurantName'] ?? 'Unknown',                    // 레스토랑 이름 표시
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 20,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.07,
            letterSpacing: -0.27,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 358,
                height: 201,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(restaurantData!['photoUrl'] ?? ''),   // 레스토랑 사진 표시
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              restaurantData!['restaurantName'] ?? 'Unknown',                // 레스토랑 이름 표시
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 20,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                  SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      restaurantData!['location'] ?? 'Unknown',              // 레스토랑 주소 표시
                      style: TextStyle(fontSize: 15),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                    restaurantData!['businessHours'] ?? 'Unknown',           // 레스토랑 영업 시간 표시
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                children: [
                  Text(
                    '설명',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      restaurantData!['description'] ?? 'Unknown',           // 레스토랑 설명 표시
                      style: TextStyle(fontSize: 15),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'MENU',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),    // 메뉴 타이틀 표시
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(                                       // 메뉴 리스트를 생성하는 ListView.builder
                itemCount: menuItems.length,                                 // 메뉴 아이템 개수 설정
                itemBuilder: (context, index) {
                  final menuItem = menuItems[index];
                  return ListTile(
                    title: Text(menuItem['menuName'] ?? 'Unknown'),          // 메뉴 이름 표시
                    subtitle: Text('${menuItem['price'] ?? '0'}원'),         // 메뉴 가격 표시
                    onTap: () {},
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isWithinBusinessHours
                      ? _saveReservation
                      : null,                                                // 영업 시간 내에만 예약 버튼 활성화
                  child: Text('예약하기'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        isWithinBusinessHours ? Colors.blue[500] : Colors.grey),
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
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: reservationBottom(),                               // 하단 네비게이션 바
    );
  }
}

class MenuDetailsPage extends StatelessWidget {                               // 메뉴 상세 페이지를 위한 StatelessWidget 정의
  final Map<String, dynamic> menuItem;                                        // 메뉴 아이템을 저장하는 맵

  MenuDetailsPage({required this.menuItem});                                  // 생성자에서 menuItem 초기화

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menuItem['menuName'] ?? 'Unknown',                                  // 메뉴 이름을 앱바에 표시
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
                child: Divider(color: Colors.black, thickness: 2.0)),        // 메뉴를 구분하는 구분선 표시
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 358,
                height: 201,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(menuItem['photoUrl'] ?? ''),          // 메뉴 사진 표시
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              menuItem['menuName'] ?? 'Unknown',                             // 메뉴 이름 표시
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
              '가격: ${menuItem['price'] ?? '0'}원',                         // 메뉴 가격 표시
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
              menuItem['description'] ?? '상세 설명이 없습니다.',             // 메뉴 설명 표시
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
                    SnackBar(content: Text('장바구니에 추가되었습니다.')),       // 버튼 클릭 시 장바구니에 추가됨을 알림
                  );
                },
                child: Text('장바구니에 추가'),                               // 장바구니에 추가 버튼
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: reservationBottom(),                               // 하단 네비게이션 바
    );
  }
}
