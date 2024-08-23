import 'package:flutter/cupertino.dart';                   
import 'package:flutter/material.dart';                     
import 'package:firebase_auth/firebase_auth.dart';         
import 'package:cloud_firestore/cloud_firestore.dart';      
import 'package:intl/intl.dart';                          
import 'UserWaitingDetail.dart';                            
import 'UserBottom.dart';                                 
import 'NonMemberBottom.dart';                               

// 비회원 대기번호 화면을 표시하는 StatefulWidget
class nonMemberWaitingNumber extends StatefulWidget {
  @override
  _WaitingNumberState createState() => _WaitingNumberState(); // 상태 관리 클래스 생성
}

class _WaitingNumberState extends State<nonMemberWaitingNumber> {
  final FirebaseAuth _auth = FirebaseAuth.instance;           // Firebase 인증 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore 인스턴스 생성
  String _nickname = '';                                      // 사용자의 닉네임 저장 변수
  List<Map<String, dynamic>> _storeReservations = [];         // 매장 예약 목록 저장 변수
  List<Map<String, dynamic>> _takeoutReservations = [];       // 포장 예약 목록 저장 변수
  bool _isLoading = true;                                     // 로딩 상태를 나타내는 변수

  @override
  void initState() {
    super.initState();
    _fetchUserNickname();                                     // 사용자 닉네임을 가져오는 함수 호출
  }

  Future<void> _fetchUserNickname() async {
    User? user = _auth.currentUser;                           // 현재 로그인된 사용자 정보 가져오기
    if (user != null) {                                       // 사용자가 로그인되어 있을 경우
      try {
        if (user.isAnonymous) {                               // 사용자가 비회원(익명 로그인)일 경우
          QuerySnapshot nonMemberSnapshot = await _firestore
              .collection('non_members')
              .where('uid', isEqualTo: user.uid)
              .get();                                         // 비회원 컬렉션에서 UID로 문서 조회
          if (nonMemberSnapshot.docs.isNotEmpty) {            // 조회된 문서가 있을 경우
            setState(() {
              _nickname = nonMemberSnapshot.docs.first['nickname'] ?? ''; // 닉네임 설정
            });
          } else {
            print('No matching document for anonymous user UID: ${user.uid}');
            setState(() {
              _isLoading = false;                             // 로딩 상태 종료
            });
            return;
          }
        } else {                                              // 사용자가 회원일 경우
          DocumentSnapshot userSnapshot =
              await _firestore.collection('users').doc(user.uid).get(); // 사용자 컬렉션에서 문서 조회
          if (userSnapshot.exists) {
            setState(() {
              _nickname = userSnapshot['nickname'] ?? '';     // 닉네임 설정
            });
          } else {
            print('User document does not exist');
            setState(() {
              _isLoading = false;                             // 로딩 상태 종료
            });
            return;
          }
        }
        print('Nickname: $_nickname');                        // 디버깅용 닉네임 출력
        _fetchConfirmedReservations();                        // 예약 내역을 가져오는 함수 호출
      } catch (e) {
        print('Error fetching user data: $e');                // 오류 발생 시 메시지 출력
        setState(() {
          _isLoading = false;                                 // 로딩 상태 종료
        });
      }
    } else {
      print('No user is signed in');                          // 로그인된 사용자가 없을 경우
      setState(() {
        _isLoading = false;                                   // 로딩 상태 종료
      });
    }
  }

  Future<void> _fetchConfirmedReservations() async {
    try {
      QuerySnapshot reservationSnapshot = await _firestore
          .collection('reservations')
          .where('nickname', isEqualTo: _nickname)
          .where('status', isEqualTo: 'confirmed')
          .get();                                             // 확인된 예약 내역 조회

      List<Map<String, dynamic>> storeReservations = [];      // 매장 예약 목록 임시 저장 변수
      List<Map<String, dynamic>> takeoutReservations = [];    // 포장 예약 목록 임시 저장 변수

      DateTime now = DateTime.now();                          // 현재 시간 가져오기
      DateTime todayStart = DateTime(now.year, now.month, now.day); // 오늘 시작 시간 설정
      DateTime todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59); // 오늘 종료 시간 설정

      for (var doc in reservationSnapshot.docs) {             // 각 예약 문서에 대해 반복
        var timestamp = (doc['timestamp'] as Timestamp).toDate(); // 타임스탬프 필드를 DateTime으로 변환
        if (timestamp.isAfter(todayStart) && timestamp.isBefore(todayEnd)) {
          print('Document Data: ${doc.data()}');              // 디버깅용 데이터 출력
          var restaurantId = doc['restaurantId'] ?? '';       // 레스토랑 ID 가져오기
          DocumentSnapshot restaurantSnapshot = await _firestore
              .collection('restaurants')
              .doc(restaurantId)
              .get();                                         // 레스토랑 정보 조회

          var reservation = {
            'reservationId': doc.id,                          // 예약 ID 추가
            'nickname': doc['nickname'] ?? '',                // 닉네임
            'restaurantName': restaurantSnapshot.exists
                ? restaurantSnapshot['restaurantName'] ?? ''
                : 'Unknown',                                  // 레스토랑 이름
            'numberOfPeople': doc['numberOfPeople'] ?? null,  // 인원수
            'type': doc['type'] == 1 ? '매장' : '포장',          // 예약 유형
            'timestamp': timestamp,                           // 예약 시간
          };
          if (reservation['type'] == '매장') {                // 예약 유형에 따라 리스트에 추가
            storeReservations.add(reservation);
          } else if (reservation['type'] == '포장') {
            takeoutReservations.add(reservation);
          }
        }
      }

      setState(() {
        _storeReservations = storeReservations;               // 매장 예약 목록 업데이트
        _takeoutReservations = takeoutReservations;           // 포장 예약 목록 업데이트
        _isLoading = false;                                   // 로딩 상태 종료
      });

      print('Store Reservations: $_storeReservations');       // 디버깅용 데이터 출력
      print('Takeout Reservations: $_takeoutReservations');   // 디버깅용 데이터 출력
    } catch (e) {
      print('Error fetching reservations: $e');               // 오류 발생 시 메시지 출력
      setState(() {
        _isLoading = false;                                   // 로딩 상태 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 170),              // 타이틀 위치 조정
              child: Text(
                '대기순번',                                       // 화면 제목
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
        backgroundColor: Colors.white,                         // 배경색 설정
        automaticallyImplyLeading: false,                      // 뒤로가기 버튼 제거
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),                   // 기본 패딩 설정
        child: _isLoading
            ? Center(child: CircularProgressIndicator())       // 로딩 중일 때 로딩 인디케이터 표시
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('매장'),                 // 매장 섹션 제목 생성
                    ..._buildQueueCards(context, _storeReservations), // 매장 예약 카드 생성
                    SizedBox(height: 20),
                    _buildSectionTitle('포장'),                 // 포장 섹션 제목 생성
                    ..._buildQueueCards(context, _takeoutReservations), // 포장 예약 카드 생성
                  ],
                ),
              ),
      ),
      bottomNavigationBar: nonMemberBottom(),                 // 하단 네비게이션 바 설정
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,                                               // 섹션 제목
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
          ),
        ),
        Divider(color: Colors.black, thickness: 2.0),          // 구분선 추가
      ],
    );
  }

  List<Widget> _buildQueueCards(
      BuildContext context, List<Map<String, dynamic>> reservations) {
    if (reservations.isEmpty) {
      return [Text('No reservations found.')];                // 예약이 없을 경우 메시지 출력
    }
    return reservations.map((reservation) {
      return _buildQueueCard(
        context,
        reservation['nickname'],                              // 닉네임
        reservation['restaurantName'],                        // 레스토랑 이름
        reservation['numberOfPeople'],                        // 인원수
        reservation['type'],                                  // 예약 유형
        reservation['timestamp'],                             // 예약 시간
        reservation['reservationId'],                         // 예약 ID
      );
    }).toList();                                               // 예약 카드 목록 반환
  }

  Widget _buildQueueCard(
    BuildContext context,
    String nickname,
    String restaurantName,
    int? numberOfPeople,
    String type,
    DateTime timestamp,
    String reservationId,
  ) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(timestamp); // 날짜 형식 지정
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => waitingDetail(
              restaurantName: restaurantName,
              queueNumber: 2,
              reservationId: reservationId,                   // 예약 ID 전달
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),           // 카드 모서리 둥글게
        ),
        elevation: 4,                                         // 카드 그림자 설정
        margin: EdgeInsets.symmetric(vertical: 8.0),          // 카드 간격 설정
        child: Container(
          padding: EdgeInsets.all(16.0),                      // 컨테이너 패딩 설정
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],                    // 배경색 설정
                  borderRadius: BorderRadius.circular(12),    // 컨테이너 모서리 둥글게
                ),
                child: Center(
                  child: Text(
                    '13',                                     // 대기 번호 표시 (임의의 숫자)
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 50),                            // 카드 내부 간격 설정
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),                      // 카드 내부 위쪽 간격
                  Text(
                    '$restaurantName',                        // 레스토랑 이름 표시
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 14,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (numberOfPeople != null)
                    Text(
                      '인원수: $numberOfPeople',              // 인원수 표시
                      style: TextStyle(
                        color: Color(0xFF1C1C21),
                        fontSize: 14,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    '날짜: $formattedDate',                    // 예약 날짜 표시
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 14,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
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
