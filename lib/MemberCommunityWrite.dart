import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WritePostPage extends StatefulWidget {
  @override
  _WritePostPageState createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isTitleEmpty = false;
  bool _isContentEmpty = false;

  Future<void> submitPost() async {
    final title = _titleController.text;
    final content = _contentController.text;

    setState(() {
      _isTitleEmpty = title.isEmpty;
      _isContentEmpty = content.isEmpty || content.length < 5;
    });

    if (!_isTitleEmpty && !_isContentEmpty) {
      if (currentUser != null) {
        // Firestore에서 현재 사용자 닉네임 가져오기
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final nickname = userDoc.get('nickname');

          // Firestore에 게시물 저장
          await FirebaseFirestore.instance.collection('community').add({
            'title': title,
            'content': content,
            'author': nickname,
            'email': currentUser!.email,
            'date': DateTime.now().toIso8601String().substring(0, 10),
            'timestamp': DateTime.now(),
          });

          Navigator.pop(context);
        } else {
          setState(() {
            _isTitleEmpty = true;
            _isContentEmpty = true;
          });
        }
      } else {
        setState(() {
          _isTitleEmpty = true;
          _isContentEmpty = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '글 작성',
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
                width: 500,
                child: Divider(color: Colors.black, thickness: 2.0)),
            SizedBox(height: 50),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
                errorText: _isTitleEmpty ? '제목을 입력하세요' : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '내용',
                errorText: _isContentEmpty ? '내용은 최소 5자 이상이어야 합니다' : null,
              ),
              maxLines: 5,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: submitPost,
              child: Text('등록'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: !_isTitleEmpty && !_isContentEmpty
                    ? Colors.lightBlueAccent
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
