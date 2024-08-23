import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MemberCommunityWrite.dart';
import 'MemberPostDetail.dart';
import 'UserPostPage.dart'; 
import 'UserBottom.dart';

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore 인스턴스 생성
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 인스턴스 생성
  bool _showUserPosts = false; // 사용자 게시물 보기 여부를 저장하는 변수
  String _searchQuery = ''; // 검색어를 저장하는 변수

  // Firestore에서 게시물 데이터를 가져오는 함수
  Future<List<Map<String, String>>> fetchPosts() async {
    QuerySnapshot snapshot;

    if (_searchQuery.isNotEmpty) {
      // 검색어가 있을 경우 해당 제목을 가진 게시물을 가져옴
      snapshot = await _firestore
          .collection('community')
          .where('title', isGreaterThanOrEqualTo: _searchQuery)
          .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
          .orderBy('timestamp', descending: true) // 최신 글이 위로 오도록 설정
          .get();
    } else {
      // 검색어가 없을 경우 모든 게시물을 최신순으로 가져옴
      snapshot = await _firestore
          .collection('community')
          .orderBy('timestamp', descending: true) // 최신 글이 위로 오도록 설정
          .get();
    }

    // 가져온 데이터를 맵 형태로 변환하여 반환
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, (value as Timestamp).toDate().toIso8601String());
        }
        return MapEntry(key, value.toString());
      });
    }).toList();
  }

  // 글 작성 페이지로 이동하는 함수
  void navigateToWritePost() async {
    final result = await Navigator.pushNamed(context, '/communityWrite');

    if (result != null && result is Map<String, String>) {
      setState(() {
        _searchQuery = ''; // 작성 후 검색어 초기화
        fetchPosts(); // 새 글 작성 후 데이터 다시 가져오기
      });
    }
  }

  // 글 상세 페이지로 이동하는 함수
  void navigateToPostDetail(Map<String, String> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          post: post,
          onPostDeleted: () {
            setState(() {
              fetchPosts(); // 글 삭제 후 데이터 다시 가져오기
            });
          },
          onPostUpdated: (updatedPost) {
            setState(() {
              fetchPosts(); // 글 수정 후 데이터 다시 가져오기
            });
          },
        ),
      ),
    );
  }

  // 사용자 게시물 페이지로 이동하는 함수
  void navigateToUserPosts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPostsPage(), // UserPostsPage로 이동
      ),
    );
  }

  // 타임스탬프를 형식화하는 함수
  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로가기 버튼
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_showUserPosts ? Icons.list : Icons.person,
                color: Colors.black),
            onPressed: () {
              navigateToUserPosts(); // UserPostsPage로 이동
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '커뮤니티',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  letterSpacing: -0.27,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: '검색',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  fetchPosts(); // 검색어 변경 시 데이터 다시 가져오기
                });
              },
            ),
            SizedBox(height: 30),
            Container(
                width: 500,
                child: Divider(color: Colors.black, thickness: 1.0)),
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
                future: fetchPosts(), // 게시물 데이터를 비동기적으로 가져옴
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // 로딩 중일 때
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // 에러 발생 시
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No posts found')); // 데이터가 없을 때
                  } else {
                    final posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          title: Text(post['title']!,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text(formatTimestamp(post['timestamp']!),
                              style: TextStyle(color: Colors.grey)),
                          trailing: Text(post['author']!,
                              style: TextStyle(color: Colors.grey)),
                          onTap: () => navigateToPostDetail(post), // 글 클릭 시 상세 페이지로 이동
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
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          onPressed: navigateToWritePost, // 글쓰기 버튼 클릭 시 글 작성 페이지로 이동
          icon: Icon(Icons.add), // 아이콘 추가
          label: Text("글쓰기"),
        ),
      ),
      bottomNavigationBar: menuButtom(), // 하단 메뉴 바
    );
  }
}
