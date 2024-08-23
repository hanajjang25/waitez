import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'StaffBottom.dart';
import 'notification.dart';

class WaitlistEntry {                                                 // 대기 명단 항목을 정의하는 클래스.
  final String id;                                                    // 대기 항목의 고유 ID.
  final String name;                                                  // 고객 이름.
  final int people;                                                   // 대기 인원 수.
  final String phoneNum;                                              // 고객의 전화번호.
  final String? altPhoneNum;                                          // 보조 전화번호 (선택적).
  final DateTime timeStamp;                                           // 대기 등록 시간.
  final String type;                                                  // 대기 유형 ('매장' 또는 '포장').

  WaitlistEntry({                                                     // 생성자.
    required this.id,                                                 // 필수 파라미터 id.
    required this.name,                                               // 필수 파라미터 name.
    required this.people,                                             // 필수 파라미터 people.
    required this.phoneNum,                                           // 필수 파라미터 phoneNum.
    this.altPhoneNum,                                                 // 선택적 파라미터 altPhoneNum.
    required this.timeStamp,                                          // 필수 파라미터 timeStamp.
    required this.type,                                               // 필수 파라미터 type.
  });
}

class homeStaff extends StatefulWidget {                              // 직원 홈 화면을 나타내는 StatefulWidget 클래스.
  @override
  _homeStaffState createState() => _homeStaffState();                 // 상태를 관리할 State 생성.
}

class _homeStaffState extends State<homeStaff> {
  List<WaitlistEntry> storeWaitlist = [];                             // 매장 대기 명단 리스트.
  List<WaitlistEntry> takeoutWaitlist = [];                           // 포장 대기 명단 리스트.
  String? restaurantId;                                               // 음식점 ID를 저장할 변수.

  @override
  void initState() {                                                  // 초기화 메소드.
    super.initState();                                                // 부모 클래스의 초기화 메소드 호출.
    _fetchRestaurantId();                                             // 음식점 ID를 가져오는 메소드 호출.
  }
  
 Future<void> _fetchRestaurantId() async {                           // Firestore에서 음식점 ID를 가져오는 메소드.
    try {
      final user = FirebaseAuth.instance.currentUser;                 // 현재 로그인된 사용자 정보 가져오기.
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();                                                   // Firestore에서 사용자 문서를 가져옴.

        if (userDoc.exists) {                                         // 사용자 문서가 존재하는지 확인.
          final nickname = userDoc.data()?['nickname'];               // 사용자 닉네임을 가져옴.

          if (nickname != null) {
            final restaurantQuery = await FirebaseFirestore.instance
                .collection('restaurants')
                .where('nickname', isEqualTo: nickname)
                .get();                                               // Firestore에서 해당 닉네임의 음식점을 가져옴.

            if (restaurantQuery.docs.isNotEmpty) {                    // 음식점이 존재하는지 확인.
              setState(() {
                restaurantId = restaurantQuery.docs.first.id;         // 음식점 ID를 상태에 저장.
              });
              _fetchConfirmedReservations();                          // 확인된 예약을 가져오는 메소드 호출.
            } else {
              print('Restaurant not found for this user.');           // 음식점을 찾을 수 없을 때의 로그 출력.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Restaurant not found for this user.')), // 오류 메시지 표시.
              );
            }
          }
        } else {
          print('User document does not exist.');                     // 사용자 문서가 존재하지 않을 때의 로그 출력.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User document does not exist.')), // 오류 메시지 표시.
          );
        }
      } else {
        print('User is not logged in.');                              // 사용자가 로그인되지 않았을 때의 로그 출력.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),          // 오류 메시지 표시.
        );
      }
    } catch (e) {
      print('Error fetching restaurant ID: $e');                      // 음식점 ID를 가져오는 중 오류가 발생한 경우 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching restaurant ID: $e')),  // 오류 메시지 표시.
      );
    }
  }
  
 Future<void> _fetchConfirmedReservations() async {                  // Firestore에서 확인된 예약을 가져오는 메소드.
    if (restaurantId != null) {
      try {
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('restaurantId', isEqualTo: restaurantId)
            .where('status', isEqualTo: 'confirmed')
            .get();                                                   // Firestore에서 확인된 예약들을 가져옴.

        final today = DateTime.now().toLocal();                       // 현재 날짜를 가져옴.
        final formattedToday = DateFormat('yyyy-MM-dd').format(today); // 오늘 날짜를 'yyyy-MM-dd' 형식으로 포맷.

        List<WaitlistEntry> storeList = [];                           // 매장 대기 명단 리스트 초기화.
        List<WaitlistEntry> takeoutList = [];                         // 포장 대기 명단 리스트 초기화.
        List<Map<String, dynamic>> reservations = [];                 // 예약 데이터를 저장할 리스트 초기화.

        reservationQuery.docs.forEach((doc) {                         // 각 예약 문서에 대해 반복.
          final data = doc.data() as Map<String, dynamic>;            // 예약 데이터를 Map 형태로 가져옴.
          final timestamp =
              (data['timestamp'] as Timestamp?)?.toDate().toLocal();  // 타임스탬프를 로컬 시간으로 변환.
          if (timestamp != null) {
            final formattedTimestamp =
                DateFormat('yyyy-MM-dd').format(timestamp);           // 타임스탬프를 'yyyy-MM-dd' 형식으로 포맷.

            if (formattedTimestamp == formattedToday) {               // 예약 날짜가 오늘과 일치하는지 확인.
              final type = data['type'] == 1 ? '매장' : '포장';        // 예약 유형을 매장 또는 포장으로 설정.
              final entry = WaitlistEntry(                            // 대기 명단 항목을 생성.
                id: doc.id,                                           // 예약 ID 설정.
                name: data['nickname']?.toString() ?? 'Unknown',      // 예약자 닉네임 설정.
                people: data['numberOfPeople'] ?? 0,                  // 예약 인원수 설정.
                phoneNum: data['phone']?.toString() ?? 'Unknown',     // 예약자 전화번호 설정.
                altPhoneNum: data['altPhoneNum']?.toString(),         // 보조 전화번호 설정.
                timeStamp: timestamp,                                 // 예약 시간 설정.
                type: type,                                           // 예약 유형 설정.
              );
              data['docId'] = doc.id;                                 // 예약 문서 ID를 데이터에 추가.
              reservations.add(data);                                 // 예약 데이터를 리스트에 추가.
              if (type == '매장') {                                   // 매장 예약인 경우.
                storeList.add(entry);                                 // 매장 대기 명단에 추가.
              } else {                                                // 포장 예약인 경우.
                takeoutList.add(entry);                               // 포장 대기 명단에 추가.
              }
            }
          }
        });

        storeList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp)); // 매장 대기 명단을 시간순으로 정렬.
        takeoutList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp)); // 포장 대기 명단을 시간순으로 정렬.

        setState(() {
          storeWaitlist = storeList;                                  // 매장 대기 명단을 상태에 저장.
          takeoutWaitlist = takeoutList;                              // 포장 대기 명단을 상태에 저장.
        });

        reservations.sort((a, b) => (b['timestamp'] as Timestamp)
            .compareTo(a['timestamp'] as Timestamp));                 // 예약 데이터를 시간순으로 정렬.

        int queueNumber = 1;                                          // 대기 번호 초기화.
        for (var data in reservations) {                              // 예약 데이터에 대해 반복.
          data['waitingNumber'] = queueNumber++;                      // 대기 번호를 할당.
          FirebaseFirestore.instance
              .collection('reservations')
              .doc(data['docId'])
              .update({'waitingNumber': data['waitingNumber']});       // Firestore에 대기 번호 업데이트.
        }
      } catch (e) {
        print('Error fetching confirmed reservations: $e');           // 확인된 예약을 가져오는 중 오류 발생 시 로그 출력.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching confirmed reservations: $e')), // 오류 메시지 표시.
        );
      }
    }
  }

 Future<void> _cancelReservation(String id, List<String> phoneNumbers) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(id)
          .update({'status': 'cancelled'});                           // 예약 상태를 취소로 업데이트.
      _fetchConfirmedReservations();                                  // 예약 목록 갱신.
      NotificationService.sendSmsNotification(
          '매장 사정으로 인해 예약취소되었습니다.', phoneNumbers);    // 예약 취소 알림 SMS 전송.
    } catch (e) {
      print('Error cancelling reservation: $e');                      // 예약 취소 중 오류 발생 시 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling reservation: $e')),  // 오류 메시지 표시.
      );
    }
  }

  Future<void> _confirmArrival(String id, List<String> phoneNumbers) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(id)
          .update({'status': 'arrived'});                             // 예약 상태를 도착으로 업데이트.

      final waitlistSnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('status', isEqualTo: 'confirmed')
          .get();                                                     // 대기 명단을 가져옴.

      List<Map<String, dynamic>> waitlist = [];                       // 대기 명단 리스트 초기화.
      for (var doc in waitlistSnapshot.docs) {                        // 각 문서에 대해 반복.
        final data = doc.data();                                      // 문서 데이터를 가져옴.
        data['docId'] = doc.id;                                       // 문서 ID를 데이터에 추가.
        waitlist.add(data);                                           // 대기 명단에 추가.
      }

      waitlist.sort((a, b) =>
          (a['waitingNumber'] ?? 0).compareTo(b['waitingNumber'] ?? 0)); // 대기 번호를 기준으로 정렬.

      for (var i = 0; i < waitlist.length; i++) {                     // 대기 명단을 반복.
        if (waitlist[i]['waitingNumber'] != null &&
            waitlist[i]['waitingNumber'] > 1) {                       // 대기 번호가 1 이상인 경우.
          await FirebaseFirestore.instance
              .collection('reservations')
              .doc(waitlist[i]['docId'])
              .update({'waitingNumber': waitlist[i]['waitingNumber'] - 1}); // 대기 번호를 1 감소시킴.
        } else if (waitlist[i]['waitingNumber'] == 1) {               // 대기 번호가 1인 경우.
          await FirebaseFirestore.instance
              .collection('reservations')
              .doc(waitlist[i]['docId'])
              .update({'waitingNumber': 0});                          // 대기 번호를 0으로 설정.

          List<String> customerPhoneNumbers = [];                     // 고객의 전화번호 리스트 초기화.
          if (waitlist[i]['phone'] != null) {
            customerPhoneNumbers.add(waitlist[i]['phone']);           // 고객 전화번호 추가.
          }
          if (waitlist[i]['altPhoneNum'] != null) {
            customerPhoneNumbers.add(waitlist[i]['altPhoneNum']);     // 보조 전화번호 추가.
          }
          NotificationService.sendSmsNotification(
              '입장할 준비해주세요.', customerPhoneNumbers);          // 입장 준비 알림 SMS 전송.
        }
      }

      _fetchConfirmedReservations();                                  // 예약 목록 갱신.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arrival confirmed successfully.')),   // 성공 메시지 표시.
      );
      NotificationService.sendSmsNotification(
          '도착확인되었습니다. 조리를 시작합니다.', phoneNumbers);   // 도착 확인 알림 SMS 전송.
    } catch (e) {
      print('Error confirming arrival: $e');                          // 도착 확인 중 오류 발생 시 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming arrival: $e')),      // 오류 메시지 표시.
      );
    }
  }

  Future<void> _markAsNoShow(String nickname, List<String> phoneNumbers) async {
    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();                                                     // 닉네임으로 사용자를 검색.

      if (userQuery.docs.isNotEmpty) {                                // 사용자가 존재하는지 확인.
        final userDoc = userQuery.docs.first;                         // 첫 번째 사용자 문서를 가져옴.
        final noShowCount = userDoc.data()['noShowCount'] ?? 0;       // 불참 횟수를 가져옴.

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .update({'noShowCount': noShowCount + 1});                // 불참 횟수를 증가시켜 Firestore에 업데이트.

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No-show count updated successfully.')), // 성공 메시지 표시.
        );
      }

      NotificationService.sendSmsNotification('불참처리 되었습니다.', phoneNumbers); // 불참 처리 알림 SMS 전송.
    } catch (e) {
      print('Error updating no-show count: $e');                      // 불참 처리 중 오류 발생 시 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating no-show count: $e')),  // 오류 메시지 표시.
      );
    }
  }

  Future<void> _callCustomer(String id, List<String> phoneNumbers) async {
    try {
      NotificationService.sendSmsNotification(
          '매장이 비었습니다. 들어와주세요.', phoneNumbers);          // 고객 호출 알림 SMS 전송.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('매장 호출 문자가 발송되었습니다.')),     // 성공 메시지 표시.
      );
    } catch (e) {
      print('Error calling customer: $e');                            // 고객 호출 중 오류 발생 시 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calling customer: $e')),        // 오류 메시지 표시.
      );
    }
  }

  Widget buildWaitlist(List<WaitlistEntry> waitlist) {                // 대기 명단을 빌드하는 메소드.
    if (waitlist.isEmpty) {
      return Center(
        child: Text('현재 예약되어 있는 것이 존재하지 않습니다.'),       // 예약이 없을 때 표시할 메시지.
      );
    }
    return Column(
      children: waitlist.map((waitP) {                                // 각 대기 항목에 대해 반복.
        List<String> phoneNumbers = [];                               // 전화번호 리스트 초기화.
        if (waitP.phoneNum.isNotEmpty) {
          phoneNumbers.add(waitP.phoneNum);                           // 전화번호 추가.
        }
        if (waitP.altPhoneNum != null && waitP.altPhoneNum!.isNotEmpty) {
          phoneNumbers.add(waitP.altPhoneNum!);                       // 보조 전화번호 추가.
        }
        final formattedTimeStamp =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(waitP.timeStamp); // 타임스탬프를 'yyyy-MM-dd HH:mm:ss' 형식으로 포맷.
        return Padding(
          padding: const EdgeInsets.all(8.0),                         // 모든 방향에 8px 패딩 추가.
          child: Card(
            color: Colors.blue[50],                                   // 카드 배경색 설정.
            child: Padding(
              padding: const EdgeInsets.all(16.0),                    // 모든 방향에 16px 패딩 추가.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,         // 자식 위젯들을 왼쪽 정렬.
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 자식 위젯들을 양 끝에 배치.
                    children: [
                      Text(
                        waitP.name,                                   // 고객 이름 표시.
                        style: TextStyle(
                          fontSize: 18,                               // 텍스트 크기 설정.
                          fontWeight: FontWeight.bold,                // 텍스트 굵기 설정.
                        ),
                      ),
                      Text('날짜: $formattedTimeStamp'),               // 예약 날짜 표시.
                    ],
                  ),
                  SizedBox(height: 10),                               // 10px 간격 추가.
                  Row(
                    children: [
                      Text('타입: ${waitP.type}'),                    // 예약 유형 표시.
                      SizedBox(width: 50),                            // 50px 간격 추가.
                      Text('인원수: ${waitP.people}'),                // 예약 인원수 표시.
                    ],
                  ),
                  Text('전화번호: ${waitP.phoneNum}'),                // 고객 전화번호 표시.
                  if (waitP.altPhoneNum != null &&
                      waitP.altPhoneNum!.isNotEmpty)
                    Text('보조 전화번호: ${waitP.altPhoneNum}'),       // 보조 전화번호가 있으면 표시.
                  SizedBox(height: 10),                               // 10px 간격 추가.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // 자식 위젯들을 공간에 맞게 배치.
                    children: [
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,                   // 패딩을 0으로 설정.
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),                      // 버튼 모서리를 둥글게 설정.
                          )),
                        ),
                        onPressed: () =>
                            _cancelReservation(waitP.id, phoneNumbers), // 예약 취소 버튼.
                        child: Text(
                          '예약취소',                                  // 버튼 텍스트 설정.
                          style: TextStyle(
                            color: Color(0xFF1C1C21),                 // 텍스트 색상 설정.
                            fontSize: 15,                             // 텍스트 크기 설정.
                            fontFamily: 'Epilogue',                   // 폰트 설정.
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,                   // 패딩을 0으로 설정.
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),                      // 버튼 모서리를 둥글게 설정.
                          )),
                        ),
                        onPressed: () {
                          _confirmArrival(waitP.id, phoneNumbers);    // 도착 확인 버튼.
                        },
                        child: Text(
                          '도착확인',                                  // 버튼 텍스트 설정.
                          style: TextStyle(
                            color: Color(0xFF1C1C21),                 // 텍스트 색상 설정.
                            fontSize: 15,                             // 텍스트 크기 설정.
                            fontFamily: 'Epilogue',                   // 폰트 설정.
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,                   // 패딩을 0으로 설정.
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),                      // 버튼 모서리를 둥글게 설정.
                          )),
                        ),
                        onPressed: () async {
                          await _markAsNoShow(waitP.name, phoneNumbers); // 불참 처리 버튼.
                        },
                        child: Text(
                          '불참',                                      // 버튼 텍스트 설정.
                          style: TextStyle(
                            color: Color(0xFF1C1C21),                 // 텍스트 색상 설정.
                            fontSize: 15,                             // 텍스트 크기 설정.
                            fontFamily: 'Epilogue',                   // 폰트 설정.
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,                   // 패딩을 0으로 설정.
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),                      // 버튼 모서리를 둥글게 설정.
                          )),
                        ),
                        onPressed: () {
                          _callCustomer(waitP.id, phoneNumbers);      // 고객 호출 버튼.
                        },
                        child: Text(
                          '매장 호출',                                 // 버튼 텍스트 설정.
                          style: TextStyle(
                            color: Color(0xFF1C1C21),                 // 텍스트 색상 설정.
                            fontSize: 15,                             // 텍스트 크기 설정.
                            fontFamily: 'Epilogue',                   // 폰트 설정.
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
 @override
  Widget build(BuildContext context) {                                // 위젯의 UI를 빌드하는 메소드.
    final screenWidth = MediaQuery.of(context).size.width;            // 화면의 너비를 가져옴.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,                                // 앱바 배경색 설정.
        automaticallyImplyLeading: false,                             // 자동으로 뒤로 가기 버튼을 표시하지 않음.
        title: Text(
          'waitez',                                                   // 앱바의 제목 설정.
          style: TextStyle(
            color: Color(0xFF1C1C21),                                 // 텍스트 색상 설정.
            fontSize: 18,                                             // 텍스트 크기 설정.
            fontFamily: 'Epilogue',                                   // 폰트 설정.
            fontWeight: FontWeight.w700,                              // 텍스트 굵기 설정.
            height: 0.07,                                             // 텍스트 높이 설정.
            letterSpacing: -0.27,                                     // 자간 설정.
          ),
        ),
        centerTitle: true,                                            // 제목을 가운데 정렬.
        actions: [
          IconButton(
            onPressed: _fetchConfirmedReservations,                   // 새로고침 버튼을 누르면 예약 목록 갱신.
            icon: Icon(Icons.refresh),                                // 새로고침 아이콘 설정.
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),                          // 모든 방향에 16px 패딩 추가.
        child: SingleChildScrollView(                                 // 스크롤 가능한 영역을 만듦.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,             // 자식 위젯들을 왼쪽 정렬.
            children: [
              Text(
                '매장',                                                // 섹션 제목 설정.
                style: TextStyle(
                  color: Color(0xFF1C1C21),                           // 텍스트 색상 설정.
                  fontSize: 18,                                       // 텍스트 크기 설정.
                  fontFamily: 'Epilogue',                             // 폰트 설정.
                  fontWeight: FontWeight.w700,                        // 텍스트 굵기 설정.
                ),
              ),
              Divider(color: Colors.black, thickness: 2.0),           // 구분선 추가.
              Container(
                width: screenWidth,                                   // 컨테이너 너비를 화면 너비로 설정.
                child: storeWaitlist.isEmpty
                    ? Center(child: Text('현재 예약되어 있는 것이 존재하지 않습니다.')) // 매장 예약이 없을 때 메시지 표시.
                    : buildWaitlist(storeWaitlist),                   // 매장 예약 목록 표시.
              ),
              Text(
                '포장',                                                // 섹션 제목 설정.
                style: TextStyle(
                  color: Color(0xFF1C1C21),                           // 텍스트 색상 설정.
                  fontSize: 18,                                       // 텍스트 크기 설정.
                  fontFamily: 'Epilogue',                             // 폰트 설정.
                  fontWeight: FontWeight.w700,                        // 텍스트 굵기 설정.
                ),
              ),
              Divider(color: Colors.black, thickness: 2.0),           // 구분선 추가.
              Container(
                width: screenWidth,                                   // 컨테이너 너비를 화면 너비로 설정.
                child: takeoutWaitlist.isEmpty
                    ? Center(child: Text('현재 예약되어 있는 것이 존재하지 않습니다.')) // 포장 예약이 없을 때 메시지 표시.
                    : buildWaitlist(takeoutWaitlist),                 // 포장 예약 목록 표시.
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: staffBottom(),                             // 하단 네비게이션 바 설정.
    );
  }
}
