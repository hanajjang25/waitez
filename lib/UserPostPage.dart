import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MemberPostDetail.dart';

class UserPostsPage extends StatefulWidget {                                    // 유저가 작성한 게시글을 보여주는 페이지
  @override
  _UserPostsPageState createState() => _UserPostsPageState();                  // 상태 관리 객체 생성
}

class _UserPostsPageState extends State<UserPostsPage> {                        // 상태 관리 클래스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;             // Firestore 인스턴스 생성
  final FirebaseAuth _auth = FirebaseAuth.instance;                            // FirebaseAuth 인스턴스 생성
  String? nickname;                                                            // 유저의 닉네임을 저장할 변수

  Future<void> fetchNickname() async {                                         // 유저의 닉네임을 가져오는 메서드
    String? userEmail = _auth.currentUser?.email;                              // 현재 로그인된 유저의 이메일 가져오기

    if (userEmail != null) {                                                   // 이메일이 존재하면
      var userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();                                                              // Firestore에서 해당 이메일을 가진 유저를 조회

      if (userSnapshot.docs.isNotEmpty) {                                      // 조회된 유저가 존재하면
        setState(() {
          nickname = userSnapshot.docs.first['nickname'];                      // 닉네임을 상태 변수에 저장
        });
      }
    }
  }

  Future<List<Map<String, String>>> fetchUserPosts() async {                   // 유저가 작성한 게시글을 가져오는 메서드
    if (nickname != null) {                                                    // 닉네임이 존재하면
      QuerySnapshot snapshot = await _firestore
          .collection('community')
          .where('author', isEqualTo: nickname)
          .get();                                                              // 해당 닉네임을 작성자로 가진 게시글 조회

      return snapshot.docs.map((doc) {                                         // 조회된 게시글을 리스트로 변환
        final data = doc.data() as Map<String, dynamic>;                       // 각 게시글 데이터를 Map으로 변환
        return data.map((key, value) {                                         // 데이터의 값을 문자열로 변환하여 반환
          if (value is Timestamp) {
            return MapEntry(
                key, (value as Timestamp).toDate().toIso8601String());         // 타임스탬프를 ISO 8601 문자열로 변환
          }
          return MapEntry(key, value.toString());                              // 그 외 값은 문자열로 변환
        });
      }).toList();
    } else {
      return [];                                                               // 닉네임이 없으면 빈 리스트 반환
    }
  }

  void navigateToPostDetail(Map<String, String> post) {                        // 게시글 상세 페이지로 이동하는 메서드
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          post: post,
          onPostDeleted: () {
            setState(() {
              fetchUserPosts();                                                // 글 삭제 후 게시글 목록을 다시 불러옴
            });
          },
          onPostUpdated: (updatedPost) {
            setState(() {
              fetchUserPosts();                                                // 글 수정 후 게시글 목록을 다시 불러옴
            });
          },
        ),
      ),
    );
  }

  String formatTimestamp(String timestamp) {                                   // 타임스탬프를 형식화하는 메서드
    DateTime dateTime = DateTime.parse(timestamp);                             // 문자열을 DateTime 객체로 변환
    return "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}"; // 형식화된 문자열 반환
  }

  @override
  void initState() {                                                           // 초기화 메서드
    super.initState();                                                         // 부모 클래스의 initState 호출
    fetchNickname();                                                           // 닉네임 가져오기
  }

 @override
  Widget build(BuildContext context) {                                         // UI 빌드 메서드
    return Scaffold(
      appBar: AppBar(                                                          // 상단 앱 바 설정
        elevation: 0,                                                          // 앱 바 그림자 제거
        backgroundColor: Colors.white,                                         // 앱 바 배경색 흰색으로 설정
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),                   // 뒤로가기 아이콘 설정
          onPressed: () {
            Navigator.of(context).pop();                                       // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(                                                           // 본문 패딩 설정
        padding: EdgeInsets.all(16),                                           // 모든 방향에 16px 패딩 추가
        child: Column(
          children: [
            SizedBox(height: 30),                                              // 30px 높이의 간격 추가
            Container(
              alignment: Alignment.centerLeft,                                 // 왼쪽 정렬
              child: Text(
                '내가 작성한 글',                                               // '내가 작성한 글' 제목 텍스트
                style: TextStyle(
                  color: Color(0xFF1C1C21),                                     // 텍스트 색상 설정
                  fontSize: 18,                                                 // 텍스트 크기 설정
                  fontFamily: 'Epilogue',                                       // 폰트 설정
                  fontWeight: FontWeight.w700,                                  // 텍스트 굵기 설정
                  height: 1.5,                                                  // 줄 간격 설정
                  letterSpacing: -0.27,                                         // 자간 설정
                ),
              ),
            ),
            SizedBox(height: 10),                                               // 10px 높이의 간격 추가
            Container(
                width: 500,                                                     // 컨테이너 너비 500 설정
                child: Divider(color: Colors.black, thickness: 1.0)),           // 검은색 구분선 추가
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(                  // 비동기 데이터를 처리하는 FutureBuilder
                future: fetchUserPosts(),                                       // 게시글 데이터를 가져오는 Future 설정
                builder: (context, snapshot) {                                  // UI 빌드
                  if (snapshot.connectionState == ConnectionState.waiting) {    // 데이터 로드 중일 때
                    return Center(child: CircularProgressIndicator());         // 로딩 인디케이터 표시
                  } else if (snapshot.hasError) {                               // 오류 발생 시
                    return Center(child: Text('Error: ${snapshot.error}'));     // 오류 메시지 표시
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {     // 데이터가 없거나 비어있을 때
                    return Center(child: Text('No posts found'));               // 'No posts found' 메시지 표시
                  } else {
                    final posts = snapshot.data!;                               // 데이터가 존재할 때 게시글 목록 가져오기
                    return ListView.builder(                                   // 게시글 목록을 리스트로 빌드
                      itemCount: posts.length,                                 // 게시글 수만큼 아이템 설정
                      itemBuilder: (context, index) {                          // 각 아이템 빌드
                        final post = posts[index];                             // 현재 아이템의 게시글 데이터
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0), // 리스트 아이템의 패딩 설정
                          title: Text(post['title']!,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)), // 게시글 제목 표시
                          subtitle: Text(formatTimestamp(post['timestamp']!),
                              style: TextStyle(color: Colors.grey)),           // 게시글 작성 시간 표시
                          trailing: Text(post['author']!,
                              style: TextStyle(color: Colors.grey)),           // 게시글 작성자 표시
                          onTap: () => navigateToPostDetail(post),             // 게시글 클릭 시 상세 페이지로 이동
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
