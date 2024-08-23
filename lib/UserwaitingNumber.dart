import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'UserWaitingDetail.dart';
import 'UserBottom.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification.dart';

class waitingNumber extends StatefulWidget {                         // 대기번호 화면을 위한 StatefulWidget
  @override
  _WaitingNumberState createState() => _WaitingNumberState();        // State를 생성하여 반환
}

class _WaitingNumberState extends State<waitingNumber> {             // 대기번호 화면의 상태 클래스
  final FirebaseAuth _auth = FirebaseAuth.instance;                  // FirebaseAuth 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;   // Firestore 인스턴스 생성
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // FirebaseMessaging 인스턴스 생성
  String _nickname = '';                                             // 사용자 닉네임을 저장하는 변수
  bool _isLoading = true;                                            // 로딩 상태를 관리하는 변수

  @override
  void initState() {                                                 // 위젯 초기화 시 호출되는 메서드
    super.initState();                                               // 부모 클래스의 initState 호출
    _fetchUserNickname();                                            // 사용자 닉네임을 가져오는 메서드 호출
    _configureFCM();                                                 // Firebase Cloud Messaging 설정
  }

  Future<void> _configureFCM() async {                               // FCM 설정을 위한 비동기 메서드
    await _firebaseMessaging.requestPermission();                    // FCM 알림 권한 요청
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {     // FCM 메시지 수신 시 리스너
      RemoteNotification? notification = message.notification;       // 수신된 메시지의 알림 가져오기
      if (notification != null) {                                    // 알림이 존재하는 경우
        showDialog(                                                  // 알림 다이얼로그 표시
          context: context,                                          // 현재 컨텍스트 사용
          builder: (_) => AlertDialog(                               // 알림 다이얼로그 빌더
            title: Text(notification.title ?? 'Notification'),       // 알림 제목 설정
            content: Text(notification.body ?? 'No message body'),   // 알림 내용 설정
          ),
        );
      }
    });
  }
  
  Future<void> _fetchUserNickname() async {                          // 사용자 닉네임을 가져오는 비동기 메서드
    User? user = _auth.currentUser;                                  // 현재 로그인된 사용자 가져오기
    if (user != null) {                                              // 사용자가 로그인되어 있는 경우
      try {
        if (user.isAnonymous) {                                      // 사용자가 익명 로그인인 경우
          QuerySnapshot nonMemberSnapshot = await _firestore         // Firestore에서 익명 사용자 정보 가져오기
              .collection('non_members')
              .where('uid', isEqualTo: user.uid)
              .get();
          if (nonMemberSnapshot.docs.isNotEmpty) {                   // 익명 사용자 정보가 존재하는 경우
            setState(() {
              _nickname = nonMemberSnapshot.docs.first['nickname'] ?? ''; // 닉네임 설정
            });
          } else {                                                   // 익명 사용자 정보가 없는 경우
            print('No matching document for anonymous user UID: ${user.uid}');
            setState(() {
              _isLoading = false;                                    // 로딩 상태 해제
            });
            return;
          }
        } else {                                                     // 사용자가 일반 로그인인 경우
          DocumentSnapshot userSnapshot =
              await _firestore.collection('users').doc(user.uid).get();
          if (userSnapshot.exists) {                                 // 사용자 정보가 존재하는 경우
            setState(() {
              _nickname = userSnapshot['nickname'] ?? '';            // 닉네임 설정
            });
          } else {                                                   // 사용자 정보가 없는 경우
            print('User document does not exist');
            setState(() {
              _isLoading = false;                                    // 로딩 상태 해제
            });
            return;
          }
        }
        setState(() {
          _isLoading = false;                                        // 로딩 상태 해제
        });
      } catch (e) {                                                  // 오류 발생 시
        print('Error fetching user data: $e');
        setState(() {
          _isLoading = false;                                        // 로딩 상태 해제
        });
      }
    } else {                                                         // 사용자가 로그인되어 있지 않은 경우
      print('No user is signed in');
      setState(() {
        _isLoading = false;                                          // 로딩 상태 해제
      });
    }
  }

  Future<Map<String, String>> _fetchRestaurantDetails(String restaurantId) async { // 음식점 정보를 가져오는 메서드
    try {
      DocumentSnapshot restaurantSnapshot =
          await _firestore.collection('restaurants').doc(restaurantId).get();
      if (restaurantSnapshot.exists) {                               // 음식점 정보가 존재하는 경우
        return {
          'name': restaurantSnapshot['restaurantName'] ?? 'Unknown', // 음식점 이름 설정
          'location': restaurantSnapshot['location'] ?? 'Unknown',   // 음식점 위치 설정
          'photoUrl': restaurantSnapshot['photoUrl'] ?? '',          // 음식점 사진 URL 설정
        };
      } else {                                                       // 음식점 정보가 없는 경우
        return {'name': 'Unknown', 'location': 'Unknown', 'photoUrl': ''};
      }
    } catch (e) {                                                    // 오류 발생 시
      print('Error fetching restaurant details: $e');
      return {'name': 'Unknown', 'location': 'Unknown', 'photoUrl': ''};
    }
  }

  Stream<List<Map<String, dynamic>>> _fetchReservationsStream() {    // 예약 정보를 실시간으로 가져오는 스트림 메서드
    return _firestore
        .collection('reservations')
        .where('nickname', isEqualTo: _nickname)                     // 닉네임으로 필터링
        .where('status', isEqualTo: 'confirmed')                     // 상태가 "confirmed"인 예약만 가져오기
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> reservations = [];                  // 예약 목록을 저장할 리스트
      int maxWaitingNumber = 0;                                      // 최대 대기 번호를 추적할 변수

      DateTime now = DateTime.now();                                 // 현재 날짜 및 시간
      DateTime todayStart = DateTime(now.year, now.month, now.day);  // 오늘 시작 시간
      DateTime todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59); // 오늘 끝 시간

      for (var doc in snapshot.docs) {                               // 각 예약 문서를 순회
        var data = doc.data() as Map<String, dynamic>;               // 예약 데이터를 맵으로 변환
        var timestamp = (data['timestamp'] as Timestamp).toDate();   // 예약 시간 가져오기
        if (timestamp.isAfter(todayStart) && timestamp.isBefore(todayEnd)) { // 예약이 오늘인지 확인
          var restaurantId = data['restaurantId'] ?? '';             // 음식점 ID 가져오기
          var reservation = {
            'reservationId': doc.id,                                 // 예약 ID
            'nickname': data['nickname'] ?? '',                      // 닉네임
            'restaurantId': restaurantId,                            // 음식점 ID
            'numberOfPeople': data['numberOfPeople'] ?? 0,           // 인원수
            'type': data['type'] == 1 ? '매장' : '포장',              // 예약 유형(매장/포장)
            'timestamp': timestamp,                                  // 예약 시간
            'waitingNumber': (data['waitingNumber'] ?? 0) as int,    // 대기 번호
          };
          reservations.add(reservation);                             // 예약 리스트에 추가
          if (reservation['waitingNumber'] > maxWaitingNumber) {     // 최대 대기 번호 갱신
            maxWaitingNumber = reservation['waitingNumber'];
          }
        }
      }

      reservations.sort((a, b) => a['timestamp'].compareTo(b['timestamp'])); // 예약 시간을 기준으로 정렬

      for (var reservation in reservations) {                        // 각 예약을 순회
        if (reservation['waitingNumber'] == 0) {                     // 대기 번호가 0인 경우
          maxWaitingNumber++;                                        // 최대 대기 번호 증가
          reservation['waitingNumber'] = maxWaitingNumber;           // 대기 번호 할당
          _firestore
              .collection('reservations')
              .doc(reservation['reservationId'])
              .update({'waitingNumber': maxWaitingNumber});          // Firestore에 업데이트
        }
      }

      for (var reservation in reservations) {                        // 각 예약을 순회
        if (reservation['waitingNumber'] == 1) {                     // 대기 번호가 1인 경우
          FlutterLocalNotification.showNotification(                // 대기 번호 1번 알림 표시
            '대기순번 1번 안내',
            '음식점에 방문할 준비를 해주세요.',
          );
        }
      }

      return reservations;                                           // 예약 목록 반환
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,          // 제목을 가운데 정렬
          children: [
            Padding(
              padding: EdgeInsets.only(left: 170),                    // 왼쪽 여백 추가
              child: Text(
                '대기순번',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,                            // 자동으로 뒤로 가기 버튼 생성하지 않음
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),                          // 전체 패딩 설정
        child: _isLoading                                             // 로딩 상태에 따라 다르게 표시
            ? Center(child: CircularProgressIndicator())             // 로딩 중일 때 로딩 스피너 표시
            : StreamBuilder<List<Map<String, dynamic>>>(
                stream: _fetchReservationsStream(),                  // 예약 정보를 실시간으로 가져옴
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {                           // 데이터가 없을 때
                    return Center(child: CircularProgressIndicator()); // 로딩 스피너 표시
                  }

                  List<Map<String, dynamic>> storeReservations =
                      snapshot.data!.where((r) => r['type'] == '매장').toList(); // 매장 예약만 필터링
                  List<Map<String, dynamic>> takeoutReservations =
                      snapshot.data!.where((r) => r['type'] == '포장').toList(); // 포장 예약만 필터링

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,   // 자식들을 시작점에 정렬
                      children: [
                        _buildSectionTitle('매장'),                   // 매장 섹션 제목 생성
                        ..._buildQueueCards(context, storeReservations), // 매장 예약 카드들 생성
                        SizedBox(height: 20),                        // 20 픽셀 간격 추가
                        _buildSectionTitle('포장'),                   // 포장 섹션 제목 생성
                        ..._buildQueueCards(context, takeoutReservations), // 포장 예약 카드들 생성
                      ],
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: menuButtom(),                              // 하단 네비게이션 바 추가
    );
  }

  Widget _buildSectionTitle(String title) {                           // 섹션 제목을 생성하는 메서드
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,                   // 자식들을 시작점에 정렬
      children: [
        Text(
          title,                                                      // 섹션 제목 텍스트 설정
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
          ),
        ),
        Divider(color: Colors.black, thickness: 2.0),                 // 구분선 추가
      ],
    );
  }

  List<Widget> _buildQueueCards(BuildContext context, List<Map<String, dynamic>> reservations) { // 예약 카드를 생성하는 메서드
    if (reservations.isEmpty) {                                       // 예약이 없는 경우
      return [Text('No reservations found.')];                        // 예약 없음 텍스트 표시
    }
    return reservations.map((reservation) {                           // 각 예약을 순회하며 카드 생성
      return FutureBuilder<Map<String, String>>(
        future: _fetchRestaurantDetails(reservation['restaurantId']), // 음식점 정보 가져오기
        builder: (context, snapshot) {
          if (!snapshot.hasData) {                                    // 데이터가 없는 경우
            return Center(child: CircularProgressIndicator());        // 로딩 스피너 표시
          }
          var restaurantDetails = snapshot.data!;
          return _buildQueueCard(
            context,
            reservation['nickname'],
            restaurantDetails['name']!,
            restaurantDetails['location']!,
            restaurantDetails['photoUrl']!,
            reservation['numberOfPeople'],
            reservation['type'],
            reservation['timestamp'],
            reservation['reservationId'], // 예약 ID 전달
            reservation['waitingNumber'], // 대기 번호 전달
          );
        },
      );
    }).toList();
  }

 Widget _buildQueueCard(
    BuildContext context,
    String nickname,
    String restaurantName,
    String restaurantLocation,
    String restaurantPhotoUrl, // 사진 URL 추가
    int numberOfPeople,
    String type,
    DateTime timestamp,
    String reservationId, // 예약 ID 추가
    int waitingNumber, // 대기 번호 추가
  ) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(timestamp); // 날짜 형식 지정
    return GestureDetector(
      onTap: () {                                                    // 카드 클릭 시 동작
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => waitingDetail(
              restaurantName: restaurantName,
              queueNumber: waitingNumber,
              reservationId: reservationId, // 예약 ID 전달
            ),
          ),
        );
      },
      child: Card(
        color: Colors.blue[50], // 카드 배경색 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 카드 모서리 둥글게 설정
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8.0), // 카드 간격 설정
        child: Container(
          padding: EdgeInsets.all(16.0), // 카드 내부 패딩 설정
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // 자식들을 시작점에 정렬
            children: [
              Container(
                width: 60, // 대기 번호를 표시할 컨테이너의 너비
                height: 60, // 대기 번호를 표시할 컨테이너의 높이
                child: Center(
                  child: Text(
                    '$waitingNumber', // 대기 번호 표시
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 20,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20), // 대기 번호와 정보 사이의 간격
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 자식들을 시작점에 정렬
                children: [
                  SizedBox(height: 4.0), // 상단 간격
                  Text(
                    '$restaurantName', // 음식점 이름 표시
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 14,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 250, // 음식점 위치를 표시할 컨테이너의 너비
                    child: Wrap(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "주소: ", // 주소 텍스트
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: restaurantLocation, // 음식점 주소 표시
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (numberOfPeople != null)                         // 인원수가 존재하는 경우
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "인원수:", // 인원수 텍스트
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' $numberOfPeople'),
                        ],
                      ),
                    ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "날짜:", // 날짜 텍스트
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' $formattedDate'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
