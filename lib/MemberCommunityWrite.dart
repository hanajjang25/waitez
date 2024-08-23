import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WritePostPage extends StatefulWidget {
  @override
  _WritePostPageState createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _titleController = TextEditingController(); // 제목 입력 필드 컨트롤러
  final TextEditingController _contentController = TextEditingController(); // 내용 입력 필드 컨트롤러
  final User? currentUser = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 정보
  bool _isTitleEmpty = false; // 제목이 비어있는지 확인하는 플래그
  bool _isContentEmpty = false; // 내용이 비어있는지 확인하는 플래그
  String? _titleError; // 제목 입력 오류 메시지
  String? _contentError; // 내용 입력 오류 메시지

  // 입력된 텍스트가 유효한 한글인지 확인하는 함수
  bool _isValidKorean(String value) {
    final koreanRegex = RegExp(r'^[가-힣\s]+$');
    return koreanRegex.hasMatch(value);
  }

  // 게시물을 제출하는 함수
  Future<void> submitPost() async {
    final title = _titleController.text;
    final content = _contentController.text;

    setState(() {
      _isTitleEmpty = title.isEmpty;
      _isContentEmpty = content.isEmpty || content.length < 5;
      _titleError = null;
      _contentError = null;

      // 제목 입력 유효성 검사
      if (title.isEmpty) {
        _titleError = '제목을 입력하세요';
      } else if (!_isValidKorean(title)) {
        _titleError = '한글로 작성해주세요';
      } else if (title.length > 10) {
        _titleError = '10자 이하로 입력해주세요';
      }

      // 내용 입력 유효성 검사
      if (content.isEmpty) {
        _contentError = '내용을 입력하세요';
      } else if (content.length < 5) {
        _contentError = '내용은 최소 5자 이상이어야 합니다';
      } else if (content.length > 500) {
        _contentError = '내용은 500자까지 작성 가능합니다';
      } else if (!_isValidKorean(content)) {
        _contentError = '한글로 작성해주세요';
      }
    });

    // 제목과 내용이 유효한 경우 Firestore에 게시물 저장
    if (_titleError == null && _contentError == null) {
      if (currentUser != null) {
        try {
          // Firestore에서 현재 사용자 닉네임 가져오기
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .get();

          // 닉네임을 가져왔을 경우 Firestore에 게시물 저장
          if (userDoc.exists && userDoc.data() != null) {
            final nickname = userDoc.get('nickname');

            await FirebaseFirestore.instance.collection('community').add({
              'title': title,
              'content': content,
              'author': nickname,
              'email': currentUser!.email,
              'date': DateTime.now().toIso8601String().substring(0, 10),
              'timestamp': DateTime.now(),
            });

            // 게시물 저장 후 이전 페이지로 돌아감
            Navigator.pop(context);
          } else {
            _showErrorDialog('글쓰기 실패하였습니다');
          }
        } catch (e) {
          _showErrorDialog('글쓰기 실패하였습니다');
        }
      } else {
        _showErrorDialog('글쓰기 실패하였습니다');
      }
    }
  }

  // 오류 다이얼로그를 표시하는 함수
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose(); // 제목 입력 필드 컨트롤러 해제
    _contentController.dispose(); // 내용 입력 필드 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // 추가 작업 없이 뒤로 가기를 허용
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('글 작성'),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                  controller: _titleController, // 제목 입력 필드
                  decoration: InputDecoration(
                    labelText: '제목',
                    errorText: _titleError, // 제목 오류 메시지 표시
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _contentController, // 내용 입력 필드
                  decoration: InputDecoration(
                    labelText: '내용',
                    errorText: _contentError, // 내용 오류 메시지 표시
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: submitPost, // 게시물 제출 버튼 클릭 시
                  child: Text('등록'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: !_isTitleEmpty && !_isContentEmpty
                        ? Colors.lightBlueAccent // 제목과 내용이 모두 입력된 경우
                        : Colors.red, // 제목이나 내용이 비어있는 경우
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
