import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:intl/intl.dart'; 
import 'package:waitez/StaffBottom.dart'; 
import 'MemberHistory.dart'; 
import 'UserBottom.dart';

class staffProfile extends StatefulWidget { // StatefulWidget으로 staffProfile 클래스 생성
  @override
  _staffProfileState createState() => _staffProfileState(); // 상태 관리 클래스 반환
}

class _staffProfileState extends State<staffProfile> {
  String nickname = ''; // 닉네임을 저장할 변수
  String email = ''; // 이메일을 저장할 변수
  String phone = ''; // 전화번호를 저장할 변수
  List<Map<String, dynamic>> reservations = []; // 예약 정보를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // 초기화 시 사용자 데이터 가져오기 함수 호출
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 가져오기
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users') // Firestore에서 'users' 컬렉션 참조
          .doc(user.uid) // 현재 사용자의 문서 참조
          .get(); // 문서 가져오기
      if (userDoc.exists) {
        setState(() {
          nickname = userDoc['nickname'] ?? 'Unknown'; // 닉네임 설정
          email = user.email ?? 'Unknown'; // 이메일 설정
          phone = userDoc['phoneNum'] ?? 'Unknown'; // 전화번호 설정
        });
        await _fetchReservations(userDoc['nickname'] ?? 'Unknown'); // 예약 정보 가져오기
      }
    }
  }

  Future<void> _fetchReservations(String nickname) async {
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations') // 'reservations' 컬렉션 참조
        .where('nickname', isEqualTo: nickname) // 닉네임으로 필터링
        .orderBy('timestamp', descending: true) // 타임스탬프 기준 내림차순 정렬
        .limit(3) // 최근 예약 3개만 가져오기
        .get(); // 쿼리 실행 및 결과 가져오기

    List<Map<String, dynamic>> fetchedReservations = []; // 가져온 예약 정보를 저장할 리스트

    for (var doc in reservationQuery.docs) {
      var reservation = doc.data(); // 각 예약 문서의 데이터를 가져옴
      var restaurantId = reservation['restaurantId']; // 레스토랑 ID 가져오기

      var restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants') // 'restaurants' 컬렉션 참조
          .doc(restaurantId) // 레스토랑 ID로 문서 참조
          .get(); // 문서 가져오기

      if (restaurantDoc.exists) {
        var restaurantData = restaurantDoc.data(); // 레스토랑 데이터를 가져옴
        reservation['restaurantName'] =
            restaurantData?['restaurantName'] ?? 'Unknown'; // 레스토랑 이름 설정
        reservation['restaurantPhoto'] =
            restaurantData?['photoUrl'] ?? 'assets/images/memberImage.png'; // 레스토랑 사진 설정
      } else {
        reservation['restaurantName'] = 'Unknown'; // 레스토랑 데이터가 없을 경우 이름 'Unknown'으로 설정
        reservation['restaurantPhoto'] = 'assets/images/memberImage.png'; // 사진 기본값 설정
      }

      fetchedReservations.add(reservation); // 리스트에 추가
    }

    setState(() {
      reservations = fetchedReservations; // 가져온 예약 정보 리스트로 설정
    });
  }

  Future<void> _logout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 가져오기
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users') // Firestore에서 'users' 컬렉션 참조
          .doc(user.uid) // 현재 사용자의 문서 참조
          .update({
        'isLoggedIn': false, // 'isLoggedIn' 상태를 false로 업데이트
      });
      await FirebaseAuth.instance.signOut(); // 로그아웃 실행
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // 로그인 화면으로 이동
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog( // 로그아웃 확인 대화상자 표시
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'), // 대화상자 제목
          content: Text('로그아웃 하시겠습니까?'), // 대화상자 내용
          actions: [
            TextButton(
              child: Text('취소'), // 취소 버튼
              onPressed: () {
                Navigator.of(context).pop(); // 대화상자 닫기
              },
            ),
            TextButton(
              child: Text('확인'), // 확인 버튼
              onPressed: () {
                Navigator.pushNamed(context, '/'); // 메인 화면으로 이동
                _logout(context); // 로그아웃 실행
              },
            ),
          ],
        );
      },
    );
  }

  String formatDate(Timestamp timestamp) {
    var date = timestamp.toDate(); // 타임스탬프를 DateTime 객체로 변환
    var localDate = date.toLocal(); // 로컬 시간대로 변환
    var formatter = DateFormat('yyyy-MM-dd HH:mm'); // 날짜 형식 지정
    return formatter.format(localDate); // 포맷된 날짜 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원정보', // 상단 바 제목
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
            onPressed: () {}, // 설정 버튼, 아직 기능 없음
          ),
        ],
      ),
      body: SingleChildScrollView( // 스크롤 가능한 화면 구성
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/memberImage.png"), // 기본 사용자 이미지
              ),
              SizedBox(height: 10),
              Text(
                nickname, // 사용자 닉네임 표시
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(email), // 사용자 이메일 표시
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(phone), // 사용자 전화번호 표시
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: staffBottom(), // 하단 네비게이션 바
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String imageAsset; // 레스토랑 이미지 URL
  final String restaurantName; // 레스토랑 이름
  final String date; // 예약 날짜
  final String buttonText; // 버튼에 표시할 텍스트
  final VoidCallback onPressed; // 버튼 클릭 시 실행할 콜백 함수

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
        leading: Image.network(imageAsset), // 레스토랑 이미지 표시
        title: Text(restaurantName), // 레스토랑 이름 표시
        subtitle: Text(date), // 예약 날짜 표시
        trailing: ElevatedButton(
          onPressed: onPressed, // 버튼 클릭 시 실행될 함수
          child: Text(buttonText), // 버튼 텍스트
        ),
      ),
    );
  }
}
