import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MemberCommunityWrite.dart';
import 'MemberPostDetail.dart';
import 'UserBottom.dart';

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showUserPosts = false;
  String _searchQuery = '';

  Future<List<Map<String, String>>> fetchPosts() async {
    String? userId = _auth.currentUser?.uid;
    QuerySnapshot snapshot;

    if (_showUserPosts && userId != null) {
      snapshot = await _firestore
          .collection('community')
          .where('author_uid', isEqualTo: userId)
          .get();
    } else if (_searchQuery.isNotEmpty) {
      snapshot = await _firestore
          .collection('community')
          .where('title', isGreaterThanOrEqualTo: _searchQuery)
          .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
          .get();
    } else {
      snapshot = await _firestore.collection('community').get();
    }

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

  void navigateToWritePost() async {
    final result = await Navigator.pushNamed(context, '/communityWrite');

    if (result != null && result is Map<String, String>) {
      setState(() {
        _showUserPosts = false; // 작성 후 전체 게시물로 돌아가기
        _searchQuery = ''; // 작성 후 검색어 초기화
        fetchPosts(); // 새 글 작성 후 데이터 다시 가져오기
      });
    }
  }

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
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_showUserPosts ? Icons.list : Icons.person,
                color: Colors.black),
            onPressed: () {
              setState(() {
                _showUserPosts = !_showUserPosts;
                fetchPosts();
              });
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
                  fetchPosts();
                });
              },
            ),
            SizedBox(height: 30),
            Container(
                width: 500,
                child: Divider(color: Colors.black, thickness: 1.0)),
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
                future: fetchPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No posts found'));
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
                          onTap: () => navigateToPostDetail(post),
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
          onPressed: navigateToWritePost,
          icon: Icon(Icons.add), // 아이콘 추가
          label: Text("글쓰기"),
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }
}
