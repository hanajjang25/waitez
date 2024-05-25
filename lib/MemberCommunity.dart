import 'package:flutter/material.dart';
import 'MemberCommunityWrite.dart';
import 'MemberPostDetail.dart';
import 'UserBottom.dart';

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final List<Map<String, String>> posts = [
    {
      'title': '음식점 추천',
      'author': '윤정환',
      'date': '2024.03.03',
      'content': '음식점 추천 받아요~!!',
      'timestamp': DateTime.now().toIso8601String()
    }
  ];

  void navigateToWritePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritePostPage(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        posts.insert(0, result); // 새 게시글을 리스트의 맨 앞에 삽입
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
              posts.remove(post);
            });
          },
          onPostUpdated: (updatedPost) {
            setState(() {
              int index = posts.indexOf(post);
              posts[index] = updatedPost;
            });
          },
        ),
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate =
        "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
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
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
              width: 500, child: Divider(color: Colors.black, thickness: 2.0)),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post['title']!),
                  subtitle: Text(
                      formatTimestamp(post['timestamp']!)), // 업데이트: 작성 시간 포맷팅
                  trailing: Text(post['author']!), // 추가: 작성자 표시
                  onTap: () => navigateToPostDetail(post),
                );
              },
            ),
          ),
        ]),
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
