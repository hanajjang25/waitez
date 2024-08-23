import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, String> post; // 게시물 데이터
  final VoidCallback onPostDeleted; // 게시물 삭제 시 호출되는 콜백 함수
  final Function(Map<String, String>) onPostUpdated; // 게시물 업데이트 시 호출되는 콜백 함수

  PostDetailPage({
    required this.post,
    required this.onPostDeleted,
    required this.onPostUpdated,
  });

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final List<Map<String, String>> comments = []; // 댓글 리스트
  final TextEditingController _commentController = TextEditingController(); // 댓글 입력 컨트롤러
  final List<bool> _isEditing = []; // 댓글 수정 상태를 나타내는 리스트
  final List<TextEditingController> _editControllers = []; // 댓글 수정 컨트롤러 리스트
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase 인증 인스턴스
  User? _currentUser; // 현재 로그인된 사용자
  String? _currentNickname; // 현재 사용자의 닉네임

  bool _isEditingPost = false; // 게시물 수정 상태를 나타내는 변수
  late TextEditingController _titleController; // 게시물 제목 컨트롤러
  late TextEditingController _contentController; // 게시물 내용 컨트롤러

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post['title']); // 게시물 제목 초기화
    _contentController = TextEditingController(text: widget.post['content']); // 게시물 내용 초기화
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user; // 현재 사용자 설정
      });
      if (user != null) {
        _fetchNickname(user.email); // 사용자의 닉네임 가져오기
      }
    });
    loadComments(); // 댓글 불러오기
  }

  // Firestore에서 사용자의 닉네임을 가져오는 함수
  Future<void> _fetchNickname(String? email) async {
    if (email == null) return;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (userDoc.docs.isNotEmpty) {
      setState(() {
        _currentNickname = userDoc.docs.first.data()['nickname']; // 닉네임 설정
      });
    }
  }

  // Firestore에서 댓글을 불러오는 함수
  void loadComments() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community')
        .doc(widget.post['timestamp']) // 게시물의 타임스탬프를 기준으로 댓글을 가져옴
        .collection('comments')
        .get();

    setState(() {
      comments.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        comments.add({
          'author': data['author'],
          'date': data['date'],
          'content': data['content'],
        });
        _isEditing.add(false); // 초기 상태는 수정 중이 아님
        _editControllers.add(TextEditingController(text: data['content'])); // 댓글 내용을 수정할 수 있는 컨트롤러 생성
      }
    });
  }

  // 입력된 텍스트가 유효한 한글인지 확인하는 함수
  bool _isValidKorean(String value) {
    final koreanRegex = RegExp(r'^[가-힣\s]+$');
    return koreanRegex.hasMatch(value);
  }

  // 댓글을 추가하는 함수
  void addComment() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인해야 댓글을 작성할 수 있습니다.')),
      );
      return;
    }

    if (_commentController.text.isNotEmpty) {
      if (_commentController.text.length > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글은 최대 100자까지 작성 가능합니다')),
        );
        return;
      }

      if (!_isValidKorean(_commentController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글은 한글로만 작성 가능합니다')),
        );
        return;
      }

      final newComment = {
        'author': _currentNickname ?? _currentUser!.email ?? 'Unknown', // 작성자 정보
        'date': DateTime.now().toIso8601String().substring(0, 10), // 작성 날짜
        'content': _commentController.text, // 댓글 내용
      };

      try {
        await FirebaseFirestore.instance
            .collection('community')
            .doc(widget.post['timestamp']) // 게시물 타임스탬프에 해당하는 댓글 컬렉션에 추가
            .collection('comments')
            .add(newComment);

        setState(() {
          comments.add(newComment); // 댓글 리스트에 추가
          _isEditing.add(false); // 댓글 추가 시 수정 모드 아님
          _editControllers.add(TextEditingController(text: _commentController.text)); // 댓글 수정 컨트롤러 추가
          _commentController.clear(); // 입력 필드 초기화
        });
      } catch (e) {
        print('Error adding comment: $e'); // 오류 발생 시 출력
      }
    }
  }

  // 댓글 삭제 확인을 요청하는 함수
  void confirmDeleteComment(int index) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('댓글 삭제'),
        content: Text('정말 이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // 취소 버튼
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // 삭제 버튼
            child: Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deleteComment(index); // 삭제 확인 시 댓글 삭제 함수 호출
    }
  }

  // 댓글을 삭제하는 함수
  void deleteComment(int index) async {
    final comment = comments[index];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community')
        .doc(widget.post['timestamp'])
        .collection('comments')
        .where('content', isEqualTo: comment['content'])
        .where('author', isEqualTo: comment['author'])
        .where('date', isEqualTo: comment['date'])
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete(); // 해당 댓글 삭제
    }

    setState(() {
      comments.removeAt(index); // 리스트에서 댓글 제거
      _isEditing.removeAt(index); // 수정 상태 제거
      _editControllers.removeAt(index); // 수정 컨트롤러 제거
    });
  }

  // 댓글 수정 모드를 토글하는 함수
  void toggleEditMode(int index) {
    setState(() {
      _isEditing[index] = !_isEditing[index]; // 수정 모드 토글
    });
  }

  // 댓글을 저장하는 함수
  void saveComment(int index) async {
    final updatedContent = _editControllers[index].text; // 수정된 내용

    if (updatedContent.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글은 최대 100자까지 작성 가능합니다')),
      );
      return;
    }

    if (!_isValidKorean(updatedContent)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글은 한글로만 작성 가능합니다')),
      );
      return;
    }

    final comment = comments[index];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community')
        .doc(widget.post['timestamp'])
        .collection('comments')
        .where('content', isEqualTo: comment['content'])
        .where('author', isEqualTo: comment['author'])
        .where('date', isEqualTo: comment['date'])
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'content': updatedContent}); // 수정된 내용 업데이트
    }

    setState(() {
      comments[index]['content'] = updatedContent; // 리스트에서 댓글 업데이트
      _isEditing[index] = false; // 수정 모드 종료
    });
  }

  // 게시물 수정 모드를 토글하는 함수
  void togglePostEditMode() {
    setState(() {
      _isEditingPost = !_isEditingPost; // 게시물 수정 모드 토글
    });
  }

  // 게시물을 저장하는 함수
  void savePost() async {
    if (_contentController.text.length > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('내용은 500자까지 작성 가능합니다')),
      );
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('community')
          .where('author', isEqualTo: widget.post['author']) // 작성자와 제목으로 게시물 찾기
          .where('title', isEqualTo: widget.post['title'])
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.update({
          'content': _contentController.text, // 게시물 내용 업데이트
        });
      }

      widget.onPostUpdated({
        'title': widget.post['title']!,
        'content': _contentController.text, // 업데이트된 내용을 전달
        'author': widget.post['author']!,
        'date': widget.post['date']!,
        'timestamp': widget.post['timestamp']!,
      });

      setState(() {
        _isEditingPost = false; // 수정 모드 종료
      });
    } catch (e) {
      print('Error updating post: $e'); // 오류 발생 시 출력
    }
  }

  // 게시물 삭제 확인을 요청하는 함수
  void confirmDeletePost() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('글 삭제'),
        content: Text('정말 이 글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // 취소 버튼
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // 삭제 버튼
            child: Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deletePost(); // 삭제 확인 시 게시물 삭제 함수 호출
    }
  }

  // 게시물을 삭제하는 함수
  void deletePost() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('community')
          .where('content', isEqualTo: widget.post['content'])
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete(); // 게시물 삭제
      }

      widget.onPostDeleted(); // 삭제 후 콜백 호출
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting post: $e'); // 오류 발생 시 출력
    }
  }

  // 댓글 작성 버튼이 눌렸을 때 처리하는 함수
  void handleCommentButtonPressed() {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인해야 댓글을 작성할 수 있습니다.')),
      );
      return;
    }

    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 입력하세요')),
      );
      return;
    }

    if (_commentController.text.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글은 최대 100자까지 작성 가능합니다')),
      );
      return;
    }

    if (!_isValidKorean(_commentController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글은 한글로만 작성 가능합니다')),
      );
      return;
    }

    addComment(); // 유효성 검사 통과 시 댓글 추가 함수 호출
  }

  @override
  Widget build(BuildContext context) {
    bool isAuthor = _currentNickname == widget.post['author']; // 현재 사용자가 작성자인지 확인

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 작성자 정보
                    Row(
                      children: [
                        Icon(Icons.person, size: 40),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post['author'] ?? 'Unknown Author', // 작성자 이름
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.post['date'] ?? 'Unknown Date', // 작성일자
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // 게시물 제목
                    _isEditingPost
                        ? TextField(
                            controller: _titleController,
                            decoration: InputDecoration(labelText: 'Title'),
                            enabled: false, // 제목은 수정 불가
                          )
                        : Text(
                            widget.post['title']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    SizedBox(height: 16),
                    // 게시물 내용
                    _isEditingPost
                        ? TextField(
                            controller: _contentController,
                            decoration: InputDecoration(
                              labelText: 'Content',
                              errorText: _contentController.text.length > 500
                                  ? '내용은 500자까지 작성 가능합니다'
                                  : null,
                            ),
                            maxLines: 5,
                          )
                        : Text(
                            widget.post['content']!,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                    if (isAuthor)
                      Column(
                        children: [
                          // 게시물 수정/저장 및 삭제 버튼
                          _isEditingPost
                              ? Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: savePost,
                                      child: Text('Save'), // 저장 버튼
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: togglePostEditMode,
                                      child: Text('Cancel'), // 취소 버튼
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.grey),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: togglePostEditMode,
                                      child: Text('Edit'), // 수정 버튼
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: confirmDeletePost,
                                      child: Text('Delete'), // 삭제 버튼
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Divider(thickness: 1, color: Colors.black), // 구분선
                    SizedBox(height: 10),
                    Text(
                      '댓글',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // 댓글 리스트
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        bool isCommentAuthor =
                            comment['author'] == (_currentNickname ?? ''); // 댓글 작성자인지 확인

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 댓글 작성자 정보
                              Row(
                                children: [
                                  Icon(Icons.person, size: 30),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment['author']!, // 댓글 작성자
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        comment['date']!, // 댓글 작성 날짜
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              // 댓글 내용 또는 수정 입력 필드
                              _isEditing[index]
                                  ? TextField(
                                      controller: _editControllers[index],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        errorText: _editControllers[index]
                                                    .text
                                                    .length >
                                                100
                                            ? '댓글은 최대 100자까지 작성 가능합니다'
                                            : !_isValidKorean(
                                                    _editControllers[index]
                                                        .text)
                                                ? '댓글은 한글로만 작성 가능합니다'
                                                : null,
                                      ),
                                    )
                                  : Text(
                                      comment['content']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                              Row(
                                children: [
                                  // 댓글 수정/취소 및 삭제 버튼
                                  if (isCommentAuthor)
                                    TextButton(
                                      onPressed: () => toggleEditMode(index),
                                      child: Text(
                                        _isEditing[index] ? 'Cancel' : 'Edit',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  if (_isEditing[index] && isCommentAuthor)
                                    TextButton(
                                      onPressed: () => saveComment(index),
                                      child: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  if (isCommentAuthor)
                                    TextButton(
                                      onPressed: () =>
                                          confirmDeleteComment(index),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                              Divider(thickness: 1, color: Colors.grey), // 구분선
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(thickness: 1, color: Colors.black), // 구분선
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              children: [
                // 댓글 입력 필드
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    enabled: _currentUser != null, // 로그인된 사용자만 입력 가능
                  ),
                ),
                SizedBox(width: 10),
                // 댓글 달기 버튼
                ElevatedButton(
                  onPressed: handleCommentButtonPressed,
                  child: Text('댓글 달기'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _currentUser != null
                            ? Colors.lightBlueAccent
                            : Colors.grey),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(Size(50, 50)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
