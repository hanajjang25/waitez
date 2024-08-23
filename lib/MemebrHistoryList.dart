import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'UserBottom.dart';
import 'MemberHistory.dart';

class historyList extends StatefulWidget {
  @override
  _historyListState createState() => _historyListState();
}

class _historyListState extends State<historyList> {
  List<Map<String, dynamic>> reservations = []; // 예약 목록을 저장할 리스트
  String _searchQuery = ''; // 검색어를 저장할 변수
  String? nickname = null; // 사용자 닉네임을 저장할 변수

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // 사용자 데이터 가져오기
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
        if (mounted) {
          setState(() {
            nickname = userDoc['nickname'] ?? 'Unknown'; // 닉네임 설정
          });
        }
        if (nickname != null) {
          await _fetchReservations(nickname!); // 닉네임으로 예약 목록 가져오기
        }
      }
    }
  }

  // Firestore에서 예약 목록을 가져오는 함수
  Future<void> _fetchReservations(String nickname) async {
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('nickname', isEqualTo: nickname) // 닉네임으로 필터링
        .orderBy('timestamp', descending: true) // 최신순으로 정렬
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
            restaurantData?['photoUrl'] ?? 'assets/images/malatang.png'; // 식당 사진 설정
        reservation['address'] = restaurantData?['location'] ?? 'Unknown'; // 식당 주소 설정
        reservation['operatingHours'] =
            restaurantData?['businessHours'] ?? 'Unknown'; // 영업시간 설정
        reservation['type'] = (reservation['type'] == 1)
            ? '매장' // 매장 방문
            : (reservation['type'] == 2)
                ? '포장' // 포장 주문
                : 'Unknown'; // 알 수 없는 타입
        reservation['menuItems'] = await _fetchMenuItems(reservation['id']); // 메뉴 아이템 가져오기
        fetchedReservations.add(reservation); // 예약 목록에 추가
      } else {
        // 식당 정보가 없는 경우 기본값 설정
        reservation['restaurantName'] = 'Unknown';
        reservation['restaurantPhoto'] = 'assets/images/malatang.png';
        reservation['address'] = 'Unknown';
        reservation['operatingHours'] = 'Unknown';
        reservation['type'] = 'Unknown';
        reservation['menuItems'] = [];
      }
    }

    if (mounted) {
      setState(() {
        reservations = fetchedReservations; // 가져온 예약 목록을 상태에 설정
      });
    }
  }

  // 날짜 형식을 변환하는 함수
  String formatDate(Timestamp timestamp) {
    var date = timestamp.toDate();
    var localDate = date.toLocal(); // 로컬 시간대로 변환
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(localDate); // yyyy-MM-dd 형식으로 변환하여 반환
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

        if (menuItem['price'] is int) {
          price = menuItem['price']; // 가격 설정
        } else if (menuItem['price'] is String) {
          price = int.tryParse(menuItem['price']) ?? 0; // 가격을 문자열에서 정수로 변환
        }

        if (item['quantity'] is int) {
          quantity = item['quantity']; // 수량 설정
        } else if (item['quantity'] is String) {
          quantity = int.tryParse(item['quantity']) ?? 0; // 수량을 문자열에서 정수로 변환
        }

        menuItems.add({
          'name': menuItem['menuName'] ?? 'Unknown', // 메뉴 이름 설정
          'price': price, // 메뉴 가격 설정
          'quantity': quantity, // 메뉴 수량 설정
        });
      }
    }
    return menuItems; // 메뉴 아이템 리스트 반환
  }

  @override
  void dispose() {
    // 리소스 해제 또는 비동기 작업 취소 필요 시 사용
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 검색어에 따라 필터링된 예약 목록 생성
    final filteredReservations = reservations.where((reservation) {
      final restaurantName =
          reservation['restaurantName']?.toString().toLowerCase() ?? ''; // 식당 이름
      final searchQuery = _searchQuery.toLowerCase(); // 검색어
      return restaurantName.contains(searchQuery); // 식당 이름이 검색어를 포함하는지 확인
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('이력조회'), // 앱바 제목
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '검색', // 검색 필드 라벨
                border: OutlineInputBorder(), // 외곽선
                prefixIcon: Icon(Icons.search), // 검색 아이콘
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // 검색어 업데이트
                });
              },
            ),
            SizedBox(height: 10),
            // 예약 목록을 표시하는 리스트뷰
            Expanded(
              child: filteredReservations.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? '이력내역이 없습니다' // 이력 내역이 없을 경우 메시지
                            : '검색과 일치하는 음식점 이력조회가 존재하지 않습니다', // 검색어와 일치하는 항목이 없을 경우 메시지
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView(
                      children: filteredReservations.map((reservation) {
                        return ReservationCard(
                          imageAsset: reservation['restaurantPhoto'] ?? '',
                          restaurantName: reservation['restaurantName'] ?? '',
                          date: formatDate(reservation['timestamp']),
                          buttonText: '자세히 보기',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => History(
                                  restaurantName:
                                      reservation['restaurantName'] ??
                                          'Unknown', // 식당 이름
                                  date: formatDate(reservation['timestamp']),
                                  imageAsset: reservation['restaurantPhoto'] ??
                                      'assets/images/malatang.png', // 식당 이미지
                                  menuItems: reservation['menuItems'] ?? [], // 메뉴 아이템 리스트
                                  type: reservation['type'] ?? 'Unknown', // 방문 형태
                                  address: reservation['address'] ?? 'Unknown', // 식당 주소
                                  operatingHours:
                                      reservation['operatingHours'] ??
                                          'Unknown', // 영업시간
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
            ),
          ],
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
  final String buttonText; // 버튼 텍스트
  final VoidCallback onPressed; // 버튼 클릭 시 호출될 콜백 함수

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
        tileColor: Colors.blue[50], // 타일 배경색
        leading: SizedBox(
          width: 50, // 이미지 크기 제한
          child: imageAsset.startsWith('http')
              ? Image.network(imageAsset, fit: BoxFit.cover) // 네트워크 이미지
              : Image.asset(imageAsset, fit: BoxFit.cover), // 로컬 이미지
        ),
        title: Text(restaurantName), // 식당 이름 표시
        subtitle: Text(date), // 예약 날짜 표시
        trailing: ElevatedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blue[50], // 버튼 배경색
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
          ),
          onPressed: onPressed, // 버튼 클릭 시 호출될 함수
          child: Text(buttonText), // 버튼 텍스트
        ),
      ),
    );
  }
}

// 예약 내역 상세 페이지 위젯
class History extends StatelessWidget {
  final String restaurantName; // 식당 이름
  final String date; // 예약 날짜
  final String imageAsset; // 식당 이미지
  final List<Map<String, dynamic>> menuItems; // 메뉴 아이템 리스트
  final String type; // 방문 형태 (매장/포장)
  final String address; // 식당 주소
  final String operatingHours; // 영업시간

  History({
    required this.restaurantName,
    required this.date,
    required this.imageAsset,
    required this.menuItems,
    required this.type,
    required this.address,
    required this.operatingHours,
  });

  @override
  Widget build(BuildContext context) {
    // 총 금액 계산
    int totalPrice = menuItems.fold(0, (sum, item) {
      int price = item['price'] is int
          ? item['price']
          : int.parse(item['price'].toString()); // 가격 설정
      int quantity = item['quantity'] is int
          ? item['quantity']
          : int.parse(item['quantity'].toString()); // 수량 설정
      return sum + (price * quantity); // 총 금액 계산
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('이력조회'), // 앱바 제목
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 식당 이미지
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게 처리
                  child: Image.network(
                    imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // 식당 이름
              Text(
                restaurantName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // 방문 형태
              Text(
                '매장/포장 : $type',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 1.2,
                  letterSpacing: -0.27,
                ),
              ),
              SizedBox(height: 20),
              // 식당 주소
              Text(
                '주소 : $address',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 1.2,
                  letterSpacing: -0.27,
                ),
              ),
              SizedBox(height: 20),
              // 영업시간
              Text(
                '영업시간 : $operatingHours',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 1.2,
                  letterSpacing: -0.27,
                ),
              ),
              SizedBox(height: 20),
              // 예약 날짜
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              // 주문 내역 제목
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '주문내역:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // 메뉴 아이템 리스트
              Expanded(
                child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(menuItems[index]['name']), // 메뉴 이름
                      subtitle: Text('₩${menuItems[index]['price']}'), // 메뉴 가격
                      trailing: Text('수량: ${menuItems[index]['quantity']}'), // 메뉴 수량
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              // 총 금액
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('총 금액', style: TextStyle(fontSize: 18)),
                  Text('₩ $totalPrice', style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
