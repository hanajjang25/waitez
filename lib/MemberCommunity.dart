import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MemberCommunityWrite.dart';
import 'MemberPostDetail.dart';
import 'UserBottom.dart';

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchPosts() async {
    QuerySnapshot snapshot = await _firestore.collection('community').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data.map((key, value) {
        if (value is Timestamp) {
          // Timestamp를 String으로 변환
          return MapEntry(key, (value as Timestamp).toDate().toIso8601String());
        }
        return MapEntry(key, value.toString());
      });
    }).toList();
  }

  void navigateToWritePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritePostPage(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        fetchPosts(); // Fetch posts again to include the new one
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
              fetchPosts(); // Fetch posts again to exclude the deleted one
            });
          },
          onPostUpdated: (updatedPost) {
            setState(() {
              fetchPosts(); // Fetch posts again to include the updated one
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
