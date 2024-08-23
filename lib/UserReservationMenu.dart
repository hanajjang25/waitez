import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserCart.dart';
import 'reservationBottom.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification.dart';

class UserReservationMenu extends StatefulWidget {                               // 예약 메뉴 화면을 위한 Stateful 위젯
  @override
  _UserReservationMenuState createState() => _UserReservationMenuState();       // 상태 관리 객체 생성
}

class _UserReservationMenuState extends State<UserReservationMenu> {            // 예약 메뉴 화면 상태 관리 클래스
  bool isFavorite = false;                                                      // 즐겨찾기 여부를 나타내는 변수
  Map<String, dynamic>? restaurantData;                                         // 음식점 데이터를 저장할 변수
  List<Map<String, dynamic>> menuItems = [];                                    // 메뉴 항목들을 저장할 리스트
  String? restaurantId;                                                         // 음식점 ID를 저장할 변수
  String? reservationId;                                                        // 예약 ID를 저장할 변수
  String? nickname;                                                             // 사용자 닉네임을 저장할 변수
  bool hasExistingReservation = false;                                          // 기존 예약 여부를 나타내는 변수

  @override
  void initState() {                                                            // 초기화 메서드
    super.initState();                                                          // 부모 클래스의 initState 호출
    _checkExistingReservations();                                               // 기존 예약이 있는지 확인
    _fetchLatestReservation();                                                  // 최신 예약 정보 가져오기
  }

  Future<void> _checkExistingReservations() async {                             // 기존 예약 확인 메서드
    try {
      final user = FirebaseAuth.instance.currentUser;                           // 현재 로그인된 사용자 가져오기
      if (user != null) {                                                       // 사용자가 로그인된 경우
        final today = DateTime.now();                                           // 현재 날짜 가져오기
        final startOfDay = DateTime(today.year, today.month, today.day);        // 오늘의 시작 시간 계산
        final userNickname = user.isAnonymous                                   // 익명 사용자 닉네임 가져오기
            ? await _fetchAnonymousNickname(user.uid)
            : user.displayName;
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('nickname', isEqualTo: userNickname)
            .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
            .where('status', isEqualTo: 'confirmed')
            .get();                                                             // 오늘의 예약을 가져오는 쿼리 실행

        if (reservationQuery.docs.isNotEmpty) {                                 // 기존 예약이 존재하는 경우
          setState(() {
            hasExistingReservation = true;                                      // 기존 예약 여부를 true로 설정
          });
        }
      }
    } catch (e) {
      print('Error checking existing reservations: $e');                        // 에러 로그 출력
    }
  }

  Future<void> _fetchLatestReservation() async {                                // 최신 예약 정보 가져오기 메서드
    try {
      final user = FirebaseAuth.instance.currentUser;                           // 현재 로그인된 사용자 가져오기
      if (user != null) {                                                       // 사용자가 로그인된 경우
        if (user.isAnonymous) {                                                 // 익명 사용자일 경우
          final nickname = await _fetchAnonymousNickname(user.uid);             // 익명 사용자 닉네임 가져오기
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: nickname)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();                                                           // 최신 예약 가져오기

          if (reservationQuery.docs.isNotEmpty) {                               // 예약이 존재하는 경우
            final reservationDoc = reservationQuery.docs.first;
            setState(() {
              restaurantId = reservationDoc['restaurantId'];                    // 음식점 ID 설정
              reservationId = reservationDoc.id;                                // 예약 ID 설정
            });
            if (restaurantId != null) {                                         // 음식점 ID가 존재하는 경우
              _fetchRestaurantDetails();                                        // 음식점 세부 정보 가져오기
              _fetchMenuItems();                                                // 메뉴 항목 가져오기
            } else {
              _showNoReservationFound();                                        // 예약이 없음을 알림
            }
          } else {
            _showNoReservationFound();                                          // 예약이 없음을 알림
          }
        } else {
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: user.displayName)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();                                                           // 최신 예약 가져오기

          if (reservationQuery.docs.isNotEmpty) {                               // 예약이 존재하는 경우
            final reservationDoc = reservationQuery.docs.first;
            setState(() {
              restaurantId = reservationDoc['restaurantId'];                    // 음식점 ID 설정
              reservationId = reservationDoc.id;                                // 예약 ID 설정
            });
            if (restaurantId != null) {                                         // 음식점 ID가 존재하는 경우
              _fetchRestaurantDetails();                                        // 음식점 세부 정보 가져오기
              _fetchMenuItems();                                                // 메뉴 항목 가져오기
            } else {
              _showNoReservationFound();                                        // 예약이 없음을 알림
            }
          } else {
            _showNoReservationFound();                                          // 예약이 없음을 알림
          }
        }
      } else {
        _showUserNotLoggedIn();                                                 // 사용자 로그인 안 됨 알림
      }
    } catch (e) {
      _showErrorFetchingReservationInfo(e);                                     // 예약 정보 가져오는 중 에러 알림
    }
  }

  Future<String> _fetchAnonymousNickname(String uid) async {                    // 익명 사용자 닉네임 가져오기 메서드
    try {
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_members')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();                                                               // 비회원 정보 가져오기

      if (nonMemberQuery.docs.isNotEmpty) {                                     // 비회원 정보가 존재하는 경우
        print('Anonymous user found with UID: $uid');
        return nonMemberQuery.docs.first['nickname'];                           // 닉네임 반환
      } else {
        print('No matching documents found for anonymous user UID: $uid');
        throw Exception('Anonymous user nickname not found.');                 // 에러 발생
      }
    } catch (e) {
      print('Error fetching anonymous user nickname: $e');                      // 에러 로그 출력
      throw e;                                                                  // 에러 던지기
    }
  }

  Future<void> _fetchRestaurantDetails() async {                                // 음식점 세부 정보 가져오기 메서드
    if (restaurantId != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantId)
            .get();                                                             // 음식점 문서 가져오기
        if (doc.exists) {
          setState(() {
            restaurantData = doc.data() as Map<String, dynamic>?;               // 음식점 데이터 설정
          });
        } else {
          _showRestaurantNotFound();                                            // 음식점이 없음을 알림
        }
      } catch (e) {
        _showErrorFetchingRestaurantDetails(e);                                 // 음식점 세부 정보 가져오는 중 에러 알림
      }
    }
  }

  Future<void> _fetchMenuItems() async {                                        // 메뉴 항목 가져오기 메서드
    if (restaurantId != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menus')
            .get();                                                             // 메뉴 항목 가져오기

        setState(() {
          menuItems = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();                                                        // 메뉴 항목 설정
        });
      } catch (e) {
        _showErrorFetchingMenuItems(e);                                         // 메뉴 항목 가져오는 중 에러 알림
      }
    }
  }

  Future<int> _getNextWaitingNumber(String type) async {                        // 다음 대기번호 가져오기 메서드
    int waitingNumber = 1;
    await FirebaseFirestore.instance.runTransaction((transaction) async {       // Firestore 트랜잭션 사용
      DocumentSnapshot snapshot = await transaction.get(
          FirebaseFirestore.instance.collection('waitingNumbers').doc(type));   // 대기번호 문서 가져오기

      if (!snapshot.exists) {                                                   // 대기번호 문서가 존재하지 않는 경우
        transaction.set(
            FirebaseFirestore.instance.collection('waitingNumbers').doc(type),
            {'currentNumber': 1});                                              // 대기번호를 1로 설정
      } else {
        int currentNumber = snapshot['currentNumber'];
        waitingNumber = currentNumber + 1;                                      // 대기번호 증가
        transaction.update(
            FirebaseFirestore.instance.collection('waitingNumbers').doc(type),
            {'currentNumber': waitingNumber});                                  // 대기번호 업데이트
      }
    });
    return waitingNumber;                                                       // 대기번호 반환
  }

  Future<void> _confirmReservation() async {                                    // 예약 확인 메서드
    if (hasExistingReservation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 오늘 예약된 내역이 있습니다. 새로운 예약을 할 수 없습니다.')), // 중복 예약 알림
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;                             // 현재 사용자 가져오기
    if (user != null) {
      final userNickname = user.isAnonymous
          ? await _fetchAnonymousNickname(user.uid)
          : user.displayName;
      final cartQuery = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .collection('cart')
          .where('nickname', isEqualTo: userNickname)
          .get();                                                               // 장바구니 항목 가져오기

      if (cartQuery.docs.isEmpty) {                                             // 장바구니가 비어 있는 경우
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메뉴 주문을 필수로 해야 합니다')),               // 메뉴 주문 필요 알림
        );
        return;
      }

      if (reservationId != null) {                                              // 예약 ID가 존재하는 경우
        try {
          DocumentSnapshot reservationSnapshot = await FirebaseFirestore
              .instance
              .collection('reservations')
              .doc(reservationId)
              .get();                                                           // 예약 문서 가져오기
          if (reservationSnapshot.exists) {
            String type =
                reservationSnapshot['type'] == 1 ? 'store' : 'takeout';
            int waitingNumber = await _getNextWaitingNumber(type);              // 대기번호 가져오기

            await FirebaseFirestore.instance
                .collection('reservations')
                .doc(reservationId)
                .update({
              'status': 'confirmed',
              'waitingNumber': waitingNumber,
            });                                                                 // 예약 상태 업데이트

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Reservation confirmed with waiting number $waitingNumber.')), // 예약 확인 알림
            );

            if (user.isAnonymous) {
              Navigator.pushNamed(context, '/nonMemberWaitingNumber');          // 익명 사용자 대기번호 페이지로 이동
            } else {
              Navigator.pushNamed(context, '/waitingNumber');                   // 대기번호 페이지로 이동
            }
          }
        } catch (e) {
          _showErrorConfirmingReservation(e);                                   // 예약 확인 중 에러 알림
        }
      } else {
        _showNoReservationFoundToConfirm();                                     // 예약이 없음을 알림
      }
    }
  }

  void _showNoReservationFound() {                                              // 예약이 없음을 알리는 메서드
    print('No recent reservation found for this user.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No recent reservation found.')),
    );
  }

  void _showUserNotLoggedIn() {                                                 // 사용자 로그인 안 됨 알림 메서드
    print('User is not logged in.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User is not logged in.')),
    );
  }

  void _showErrorFetchingReservationInfo(e) {                                   // 예약 정보 가져오는 중 에러 알림 메서드
    print('Error fetching reservation info: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching reservation info: $e')),
    );
  }

  void _showRestaurantNotFound() {                                              // 음식점이 없음을 알림 메서드
    print('Restaurant not found');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Restaurant not found')),
    );
  }

  void _showErrorFetchingRestaurantDetails(e) {                                 // 음식점 세부 정보 가져오는 중 에러 알림 메서드
    print('Error fetching restaurant details: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching restaurant details: $e')),
    );
  }

  void _showErrorFetchingMenuItems(e) {                                         // 메뉴 항목 가져오는 중 에러 알림 메서드
    print('Error fetching menu items: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching menu items: $e')),
    );
  }

  void _showErrorConfirmingReservation(e) {                                     // 예약 확인 중 에러 알림 메서드
    print('Error confirming reservation: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error confirming reservation: $e')),
    );
  }

  void _showNoReservationFoundToConfirm() {                                     // 예약이 없음을 알림 메서드
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No reservation found to confirm.')),
    );
  }

 @override
  Widget build(BuildContext context) {                                          // 화면 UI 빌드 메서드
    if (restaurantData == null) {                                               // 음식점 데이터가 없는 경우
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),                                             // 로딩 중 표시
        ),
        body: Center(
          child: CircularProgressIndicator(),                                    // 로딩 인디케이터 표시
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurantData!['restaurantName'] ?? 'Unknown',                       // 음식점 이름 표시
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
            icon: Icon(Icons.shopping_cart),                                     // 장바구니 아이콘
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => cart()),                // 장바구니 페이지로 이동
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),                                                // 상단 여백
            Center(
              child: Container(
                width: 358,
                height: 201,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(restaurantData!['photoUrl'] ?? ''),     // 음식점 사진 표시
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),                                                // 음식점 사진과 텍스트 간격
            Text(
              restaurantData!['restaurantName'] ?? 'Unknown',                   // 음식점 이름 표시
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                height: 1.5,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 30),                                                // 음식점 이름과 세부 정보 간격
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
                      height: 1.5,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),                                           // 주소 텍스트와 주소 내용 간격
                  Expanded(
                    child: Text(
                      restaurantData!['location'] ?? 'Unknown',                 // 음식점 주소 표시
                      style: TextStyle(fontSize: 15),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),                                                // 주소와 영업시간 간격
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
                      height: 1.5,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),                                           // 영업시간 텍스트와 영업시간 내용 간격
                  Expanded(
                    child: Text(
                      restaurantData!['businessHours'] ?? 'Unknown',            // 음식점 영업시간 표시
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),                                                // 영업시간과 설명 간격
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
                      height: 1.5,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),                                           // 설명 텍스트와 설명 내용 간격
                  Expanded(
                    child: Text(
                      restaurantData!['description'] ?? 'Unknown',              // 음식점 설명 표시
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),                                                // 설명과 메뉴 간격
            Text(
              'MENU',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),      // 메뉴 제목 표시
            ),
            SizedBox(height: 10),                                                // 메뉴 제목과 항목 간격
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {                                  // 메뉴 항목 빌드
                  final menuItem = menuItems[index];
                  return ListTile(
                    title: Text(menuItem['menuName'] ?? 'Unknown'),             // 메뉴 이름 표시
                    subtitle: Text('${menuItem['price'] ?? '0'}원'),             // 메뉴 가격 표시
                    onTap: () => navigateToDetails(menuItem),                   // 메뉴 선택 시 상세 페이지로 이동
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {                                          // 예약하기 버튼 클릭 시
                    await _confirmReservation();                                 // 예약 확인 메서드 호출
                  },
                  child: Text('예약하기'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[500]),
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
              height: 50,                                                       // 하단 여백
            )
          ],
        ),
      ),
      bottomNavigationBar: reservationBottom(),                                 // 하단 네비게이션 바
    );
  }

  void navigateToDetails(Map<String, dynamic>? menuItem) {                      // 메뉴 상세 페이지로 이동 메서드
    if (menuItem != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuDetailsPage(
            menuItem: menuItem,
            restaurantId: restaurantId,
            reservationId: reservationId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu item details are missing')),               // 메뉴 항목 세부 정보 없음 알림
      );
    }
  }
}

class MenuDetailsPage extends StatefulWidget {                                   // 메뉴 상세 페이지 위젯
  final Map<String, dynamic> menuItem;                                          // 메뉴 항목 데이터
  final String? restaurantId;                                                   // 음식점 ID
  final String? reservationId;                                                  // 예약 ID

  MenuDetailsPage({
    required this.menuItem,
    required this.restaurantId,
    required this.reservationId,
  });

  @override
  _MenuDetailsPageState createState() => _MenuDetailsPageState();               // 메뉴 상세 페이지 상태 관리 객체 생성
}

class _MenuDetailsPageState extends State<MenuDetailsPage> {                    // 메뉴 상세 페이지 상태 관리 클래스
  Future<void> addToCart(BuildContext context) async {                          // 장바구니에 추가하는 메서드
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userNickname = user?.isAnonymous ?? false
          ? await _fetchAnonymousNickname(user!.uid)
          : user?.displayName;

      if (user != null && widget.reservationId != null) {                       // 사용자가 로그인되어 있고 예약 ID가 있는 경우
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(widget.reservationId)
            .collection('cart')
            .add({
          'nickname': userNickname,                                             // 사용자 닉네임
          'restaurantId': widget.restaurantId,                                  // 음식점 ID
          'menuItem': widget.menuItem,                                          // 메뉴 항목
          'quantity': 1, // 기본 수량을 1로 설정                                      // 기본 수량 1 설정
          'timestamp': FieldValue.serverTimestamp(),                            // 타임스탬프 추가
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('장바구니에 추가되었습니다.')),                 // 장바구니 추가 알림
          );
        }
      } else {
        print('User is not logged in or reservationId is null.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('User is not logged in or reservationId is null.')),  // 사용자 로그인 또는 예약 ID 누락 알림
          );
        }
      }
    } catch (e) {
      print('Error adding to cart: $e');                                        // 에러 로그 출력
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),                 // 장바구니 추가 중 에러 알림
        );
      }
    }
  }

  Future<String> _fetchAnonymousNickname(String uid) async {                   // 익명 사용자 닉네임 가져오기 메서드
    try {
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_members')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();                                                               // 비회원 정보 가져오기

      if (nonMemberQuery.docs.isNotEmpty) {                                     // 비회원 정보가 존재하는 경우
        print('Anonymous user found with UID: $uid');
        return nonMemberQuery.docs.first['nickname'];                           // 닉네임 반환
      } else {
        print('No matching documents found for anonymous user UID: $uid');
        throw Exception('Anonymous user nickname not found.');                 // 에러 발생
      }
    } catch (e) {
      print('Error fetching anonymous user nickname: $e');                      // 에러 로그 출력
      throw e;                                                                  // 에러 던지기
    }
  }

  @override
  Widget build(BuildContext context) {                                          // 화면 UI 빌드 메서드
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menuItem['menuName'] ?? 'Unknown',                             // 메뉴 이름 표시
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            height: 1.5,
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
            SizedBox(height: 20),                                                // 상단 여백
            Text(
              'MENU',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),                                                // 메뉴 제목과 구분선 간격
            Container(
                width: 500,
                child: Divider(color: Colors.black, thickness: 2.0)),            // 구분선
            SizedBox(height: 20),                                                // 구분선과 이미지 간격
            Center(
              child: Container(
                width: 358,
                height: 201,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.menuItem['photoUrl'] ??
                        'https://via.placeholder.com/358x201'), // Replace with actual image URL
                    fit: BoxFit.cover,                                          // 이미지 맞춤 설정
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),                                                // 이미지와 메뉴 이름 간격
            Text(
              widget.menuItem['menuName'] ?? 'Unknown',                         // 메뉴 이름 표시
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 24,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),                                                // 메뉴 이름과 가격 간격
            Text(
              '가격: ${widget.menuItem['price'] ?? '0'}원',                       // 메뉴 가격 표시
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 20,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 20),                                                // 가격과 설명 간격
            Text(
              widget.menuItem['description'] ?? '상세 설명이 없습니다.',            // 메뉴 설명 표시
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 20),                                                // 설명과 원산지 간격
            Text(
              '원산지: ${widget.menuItem['price'] ?? '0'}원',                    // 메뉴 원산지 표시
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 100),                                               // 원산지와 버튼 간격
            Center(
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
                ),
                onPressed: () => addToCart(context),                            // 장바구니에 추가 버튼 클릭 시
                child: Text(
                  '장바구니에 추가',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 15,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
