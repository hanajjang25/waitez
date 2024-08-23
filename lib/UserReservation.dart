import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'reservationBottom.dart';

class Reservation extends StatefulWidget {                                       // 예약 페이지의 Stateful 위젯
  @override
  _ReservationState createState() => _ReservationState();                       // 상태 관리 객체 생성
}

class _ReservationState extends State<Reservation> {                             // 예약 페이지 상태 관리 클래스
  int numberOfPeople = 0;                                                        // 인원수 변수 초기화
  bool isPeopleSelectorEnabled = false;                                          // 인원수 선택 가능 여부 변수 초기화
  bool isFirstClick = true;                                                      // 첫 번째 클릭 여부 변수 초기화

  void showSnackBar(BuildContext context, String message) {                      // 스낵바를 표시하는 함수
    final snackBar = SnackBar(
      content: Text(message),                                                    // 메시지를 스낵바에 표시
      duration: Duration(seconds: 2),                                            // 스낵바 표시 시간 설정
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);                        // 스낵바 표시
  }

  Future<void> _saveReservation(BuildContext context, String type) async {       // 예약을 저장하는 함수
    final user = FirebaseAuth.instance.currentUser;                              // 현재 로그인된 유저 가져오기
    if (user != null) {                                                          // 유저가 로그인된 경우
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();                                                                // Firestore에서 유저 문서 가져오기

      String nickname = '';                                                      // 닉네임 초기화
      if (userDoc.exists) {                                                      // 유저 문서가 존재하는 경우
        nickname = userDoc.data()?['nickname'] ?? '';                            // 닉네임 가져오기
      } else {                                                                   // 유저 문서가 존재하지 않는 경우
        final nonMemberQuery = await FirebaseFirestore.instance
            .collection('non_members')
            .where('uid', isEqualTo: user.uid)
            .get();                                                              // 비회원 정보 가져오기
        if (nonMemberQuery.docs.isNotEmpty) {                                    // 비회원 문서가 존재하는 경우
          final nonMemberData = nonMemberQuery.docs.first.data();
          nickname = nonMemberData['nickname'] ?? '';                            // 비회원 닉네임 가져오기
        } else {
          print('User document does not exist.');                                 // 에러 로그 출력
          return;
        }
      }

      if (type == '매장') {                                                      // 매장 예약일 경우
        final now = DateTime.now();                                              // 현재 시간 가져오기
        final startOfDay = DateTime(now.year, now.month, now.day);               // 오늘 시작 시간
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);     // 오늘 끝나는 시간
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('nickname', isEqualTo: nickname)
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
            .where('type', isEqualTo: 1) // Dine-in type                      // 매장 예약 타입 확인
            .where('status', isEqualTo: 'confirmed')
            .get();                                                             // 오늘의 매장 예약 확인

        if (reservationQuery.docs.isNotEmpty) {                                 // 이미 예약된 경우
          showSnackBar(context, '매장은 최대 1개까지 예약이 가능합니다.');         // 예약 제한 안내 메시지
          return;
        }
      }

      final reservationData = {                                                 // 예약 데이터 생성
        'nickname': nickname,
        'type': type == '매장' ? 1 : 2,                                          // 매장 타입이면 1, 아니면 2
        'timestamp': Timestamp.now(),                                           // 현재 시간 타임스탬프
        'numberOfPeople': type == '매장' ? numberOfPeople : null,               // 매장일 경우 인원수 설정
        'status': 'confirmed',                                                  // 예약 상태 설정
      };

      final recentReservationQuery = await FirebaseFirestore.instance
          .collection('reservations')
          .where('nickname', isEqualTo: nickname)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();                                                               // 가장 최근의 예약 가져오기

      if (recentReservationQuery.docs.isNotEmpty) {                             // 최근 예약이 존재하는 경우
        final recentReservationDoc =
            recentReservationQuery.docs.first.reference;                       // 예약 문서 참조 가져오기
        await recentReservationDoc.update(reservationData);                    // 기존 예약 업데이트
      } else {
        await FirebaseFirestore.instance
            .collection('reservations')
            .add(reservationData);                                              // 새로운 예약 추가
      }

      Navigator.push(                                                           // 다음 화면으로 이동
        context,
        MaterialPageRoute(
          builder: (context) => InfoInputScreen(numberOfPeople: numberOfPeople),
        ),
      );
    } else {
      print('User is not logged in.');                                           // 에러 로그 출력
    }
  }
  
  @override
  Widget build(BuildContext context) {                                          // UI 빌드 메서드
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '매장/포장 선택',
          style: TextStyle(
            color: Color(0xFF1C1C21),                                           // 텍스트 색상 설정
            fontSize: 18,                                                       // 텍스트 크기 설정
            fontFamily: 'Epilogue',                                             // 폰트 설정
            fontWeight: FontWeight.w700,                                        // 텍스트 굵기 설정
            height: 0.07,                                                       // 줄 간격 설정
            letterSpacing: -0.27,                                               // 자간 설정
          ),
        ),
      ),
      body: Padding(                                                            // 본문 패딩 설정
        padding: const EdgeInsets.all(16.0),                                    // 모든 방향에 16px 패딩 추가
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,                          // 자식 위젯들을 중앙에 정렬
          children: [
            ElevatedButton(                                                     // 매장 버튼
              onPressed: () {
                if (isFirstClick) {                                             // 첫 클릭인지 확인
                  setState(() {
                    isPeopleSelectorEnabled = true;                             // 인원수 선택 가능 상태로 변경
                    isFirstClick = false;                                       // 첫 클릭 상태 해제
                  });
                  showSnackBar(context, '인원수를 선택하세요');                    // 인원수 선택 안내 메시지 표시
                } else {
                  if (numberOfPeople > 0) {                                     // 인원수가 0보다 큰 경우
                    _saveReservation(context, '매장');                          // 예약 저장 함수 호출
                  }
                  if (numberOfPeople > 10) {                                    // 인원수가 10을 초과할 경우
                    showSnackBar(context, '인원수는 10명을 초과할 수 없습니다.');   // 초과 안내 메시지 표시
                  } else {
                    showSnackBar(context, '인원수를 선택하세요');                  // 인원수 선택 안내 메시지 표시
                  }
                }
              },
              child: Text('매장'),                                               // 매장 버튼 텍스트
              style: ButtonStyle(                                               // 버튼 스타일 설정
                backgroundColor: MaterialStateProperty.all(Colors.blue[500]),   // 배경색 설정
                foregroundColor: MaterialStateProperty.all(Colors.black),       // 글자색 설정
                minimumSize: MaterialStateProperty.all(Size(200, 50)),          // 버튼 크기 설정
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 10)),                      // 버튼 패딩 설정
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),                    // 모서리 둥글게 설정
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),                                               // 16px 높이의 간격 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.center,                      // 자식 위젯들을 중앙에 정렬
              children: [
                Text('인원수'),                                                  // 인원수 텍스트
                SizedBox(width: 50),                                            // 50px 너비의 간격 추가
                Row(
                  children: [
                    IconButton(                                                 // 인원수 감소 버튼
                      icon: Icon(Icons.remove),                                 // 마이너스 아이콘 설정
                      onPressed: isPeopleSelectorEnabled
                          ? () {
                              setState(() {
                                if (numberOfPeople > 0) {                       // 인원수가 0보다 클 경우
                                  numberOfPeople--;                             // 인원수 감소
                                }
                              });
                            }
                          : null,
                    ),
                    Text('$numberOfPeople'),                                    // 현재 인원수 표시
                    IconButton(                                                 // 인원수 증가 버튼
                      icon: Icon(Icons.add),                                    // 플러스 아이콘 설정
                      onPressed: isPeopleSelectorEnabled && numberOfPeople < 10
                          ? () {
                              setState(() {
                                if (numberOfPeople < 10) {                      // 인원수가 10보다 작을 경우
                                  numberOfPeople++;                             // 인원수 증가
                                }
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),                                               // 16px 높이의 간격 추가
            ElevatedButton(                                                     // 포장 버튼
              onPressed: () {
                _saveReservation(context, '포장');                              // 포장 예약 저장 함수 호출
              },
              child: Text('포장'),                                               // 포장 버튼 텍스트
              style: ButtonStyle(                                               // 버튼 스타일 설정
                backgroundColor: MaterialStateProperty.all(Colors.blue[500]),   // 배경색 설정
                foregroundColor: MaterialStateProperty.all(Colors.black),       // 글자색 설정
                minimumSize: MaterialStateProperty.all(Size(200, 50)),          // 버튼 크기 설정
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 10)),                      // 버튼 패딩 설정
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),                    // 모서리 둥글게 설정
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: reservationBottom(),                                 // 예약 페이지 하단 네비게이션 바
    );
  }
}

class InfoInputScreen extends StatefulWidget {                                   // 정보 입력 화면 Stateful 위젯
  final int numberOfPeople;                                                     // 인원수 변수

  InfoInputScreen({required this.numberOfPeople});                              // 생성자에서 인원수 전달받음

  @override
  _InfoInputScreenState createState() => _InfoInputScreenState();               // 상태 관리 객체 생성
}

class _InfoInputScreenState extends State<InfoInputScreen> {                     // 정보 입력 화면 상태 관리 클래스
  late int numberOfPeople;                                                      // 인원수 변수 선언
  final TextEditingController _nicknameController =
      TextEditingController(text: '');                                          // 닉네임 컨트롤러 생성
  final TextEditingController _phoneController =
      TextEditingController(text: '');                                          // 전화번호 컨트롤러 생성
  final TextEditingController _altPhoneController =
      TextEditingController(text: '');                                          // 보조 전화번호 컨트롤러 생성

  @override
  void initState() {                                                            // 초기화 메서드
    super.initState();                                                          // 부모 클래스의 initState 호출
    numberOfPeople = widget.numberOfPeople;                                     // 전달받은 인원수 설정
    _fetchUserInfo();                                                           // 유저 정보 가져오기
  }

  Future<void> _fetchUserInfo() async {                                         // 유저 정보를 가져오는 메서드
    try {
      final user = FirebaseAuth.instance.currentUser;                           // 현재 로그인된 유저 가져오기
      if (user != null) {                                                       // 유저가 로그인된 경우
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();                                                             // Firestore에서 유저 문서 가져오기
        if (userDoc.exists) {                                                   // 유저 문서가 존재하는 경우
          final data = userDoc.data()!;
          setState(() {
            _nicknameController.text = data['nickname'] ?? '';                 // 닉네임 설정
            _phoneController.text = data['phoneNum'] ?? '';                    // 전화번호 설정
          });
        } else {                                                                // 유저 문서가 존재하지 않는 경우
          final nonMemberQuery = await FirebaseFirestore.instance
              .collection('non_members')
              .where('uid', isEqualTo: user.uid)
              .get();                                                           // 비회원 정보 가져오기
          if (nonMemberQuery.docs.isNotEmpty) {                                 // 비회원 문서가 존재하는 경우
            final nonMemberData = nonMemberQuery.docs.first.data();
            setState(() {
              _nicknameController.text = nonMemberData['nickname'] ?? '';       // 비회원 닉네임 설정
              _phoneController.text = nonMemberData['phoneNum'] ?? '';          // 비회원 전화번호 설정
            });
          } else {
            print('Non-member document does not exist.');                       // 에러 로그 출력
          }
        }
      } else {
        print('User is not logged in.');                                         // 에러 로그 출력
      }
    } catch (e) {
      print('Error fetching user info: $e');                                    // 에러 로그 출력
    }
  }

  String _formatPhoneNumber(String value) {                                     // 전화번호 형식을 설정하는 메서드
    value = value.replaceAll('-', '');                                          // 기존의 대시를 제거
    if (value.length > 3) {
      value = value.substring(0, 3) + '-' + value.substring(3);                 // 첫 번째 대시 추가
    }
    if (value.length > 8) {
      value = value.substring(0, 8) + '-' + value.substring(8);                 // 두 번째 대시 추가
    }
    return value;                                                               // 형식화된 전화번호 반환
  }

  Future<void> _saveReservationInfo() async {                                   // 예약 정보를 저장하는 메서드
    try {
      final user = FirebaseAuth.instance.currentUser;                           // 현재 로그인된 유저 가져오기
      if (user != null) {                                                       // 유저가 로그인된 경우
        await FirebaseFirestore.instance.runTransaction((transaction) async {   // Firestore 트랜잭션 사용
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: _nicknameController.text)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();                                                           // 최근 예약 가져오기

          print('Query Result Count: ${reservationQuery.docs.length}');          // 쿼리 결과 개수 로그 출력
          reservationQuery.docs.forEach((doc) {
            print('Document ID: ${doc.id}, Data: ${doc.data()}');               // 문서 ID와 데이터 로그 출력
          });

          if (reservationQuery.docs.isNotEmpty) {                               // 최근 예약이 존재하는 경우
            final reservationDoc = reservationQuery.docs.first.reference;      // 예약 문서 참조 가져오기
            transaction.update(reservationDoc, {
              'numberOfPeople': numberOfPeople,                                 // 인원수 업데이트
              'altPhoneNum': _altPhoneController.text,                          // 보조 전화번호 업데이트
            });

            print('Reservation updated successfully');                          // 예약 업데이트 성공 로그 출력
          } else {
            print('No recent reservation found for this user.');                 // 예약이 없는 경우 로그 출력
          }
        });

        Navigator.pushNamed(context, '/waitingNumber');                         // 대기 순번 페이지로 이동
      } else {
        print('User is not logged in.');                                         // 에러 로그 출력
      }
    } catch (e) {
      print('Error saving reservation info: $e');                               // 에러 로그 출력
    }
  }

  @override
  Widget build(BuildContext context) {                                          // UI 빌드 메서드
    return Scaffold(
      appBar: AppBar(
        title: Text('정보입력'),                                                  // 상단 앱 바 제목
        leading: IconButton(
          icon: Icon(Icons.arrow_back),                                         // 뒤로가기 아이콘 설정
          onPressed: () {
            Navigator.pop(context);                                             // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(                                                            // 본문 패딩 설정
        padding: const EdgeInsets.all(16.0),                                    // 모든 방향에 16px 패딩 추가
        child: SingleChildScrollView(                                           // 스크롤 가능하도록 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,                       // 자식 위젯들을 왼쪽 정렬
            children: [
              SizedBox(height: 50),                                             // 50px 높이의 간격 추가
              Text(
                '닉네임',
                style: TextStyle(
                  color: Color(0xFF1C1C21),                                     // 텍스트 색상 설정
                  fontSize: 18,                                                 // 텍스트 크기 설정
                  fontFamily: 'Epilogue',                                       // 폰트 설정
                ),
              ),
              TextFormField(
                controller: _nicknameController,                                // 닉네임 컨트롤러 연결
                decoration: InputDecoration(),                                  // 기본 입력 창 디자인
                readOnly: true,                                                 // 텍스트 필드를 읽기 전용으로 설정
              ),
              SizedBox(height: 30),                                             // 30px 높이의 간격 추가
              Text(
                '전화번호',
                style: TextStyle(
                  color: Color(0xFF1C1C21),                                     // 텍스트 색상 설정
                  fontSize: 18,                                                 // 텍스트 크기 설정
                  fontFamily: 'Epilogue',                                       // 폰트 설정
                ),
              ),
              TextFormField(
                controller: _phoneController,                                   // 전화번호 컨트롤러 연결
                decoration: InputDecoration(),                                  // 기본 입력 창 디자인
                readOnly: true,                                                 // 텍스트 필드를 읽기 전용으로 설정
              ),
              SizedBox(height: 30),                                             // 30px 높이의 간격 추가
              Text(
                '보조전화번호',
                style: TextStyle(
                  color: Color(0xFF1C1C21),                                     // 텍스트 색상 설정
                  fontSize: 18,                                                 // 텍스트 크기 설정
                  fontFamily: 'Epilogue',                                       // 폰트 설정
                ),
              ),
              TextFormField(
                controller: _altPhoneController,                                // 보조 전화번호 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '010-0000-0000',                                    // 힌트 텍스트 설정
                ),
                inputFormatters: [                                              // 입력 형식 설정
                  FilteringTextInputFormatter.digitsOnly,                       // 숫자만 입력 가능하도록 설정
                  LengthLimitingTextInputFormatter(11),                         // 최대 11자리 입력 제한
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      String newText = _formatPhoneNumber(newValue.text);       // 전화번호 형식 설정
                      return TextEditingValue(
                        text: newText,                                          // 형식화된 텍스트 반환
                        selection:
                            TextSelection.collapsed(offset: newText.length),    // 커서 위치 설정
                      );
                    },
                  ),
                ],
                keyboardType: TextInputType.number,                             // 숫자 키보드 사용
                readOnly: false,                                                // 보조 전화번호는 편집 가능하도록 설정
              ),
              SizedBox(height: 100),                                            // 100px 높이의 간격 추가
              Center(
                child: ElevatedButton(                                          // 다음 버튼
                  onPressed: () async {
                    await _saveReservationInfo();                               // 예약 정보 저장
                    Navigator.pushNamed(
                      context,
                      '/reservationMenu',                                       // 메뉴 예약 페이지로 이동
                    );
                  },
                  child: Text('다음'),                                           // 다음 버튼 텍스트
                  style: ButtonStyle(                                           // 버튼 스타일 설정
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[500]),            // 배경색 설정
                    foregroundColor: MaterialStateProperty.all(Colors.black),   // 글자색 설정
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),      // 버튼 크기 설정
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10)),                  // 버튼 패딩 설정
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),                // 모서리 둥글게 설정
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: reservationBottom(),                                 // 예약 페이지 하단 네비게이션 바
    );
  }
}
