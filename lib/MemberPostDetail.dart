import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, String> post;
  final VoidCallback onPostDeleted;
  final Function(Map<String, String>) onPostUpdated;

  PostDetailPage({
    required this.post,
    required this.onPostDeleted,
    required this.onPostUpdated,
  });

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final List<Map<String, String>> comments = [];
  final TextEditingController _commentController = TextEditingController();
  final List<bool> _isEditing = [];
  final List<TextEditingController> _editControllers = [];

  bool _isEditingPost = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post['title']);
    _contentController = TextEditingController(text: widget.post['content']);
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
    loadComments();
  }

  void loadComments() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community')
        .doc(widget.post['timestamp'])
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
        _isEditing.add(false);
        _editControllers.add(TextEditingController(text: data['content']));
      }
    });
  }

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

      final newComment = {
        'author': _currentUser!.displayName ?? _currentUser!.email ?? 'Unknown',
        'date': DateTime.now().toIso8601String().substring(0, 10),
        'content': _commentController.text,
      };

      try {
        await FirebaseFirestore.instance
            .collection('community')
            .doc(widget.post['timestamp'])
            .collection('comments')
            .add(newComment);

        setState(() {
          comments.add(newComment);
          _isEditing.add(false);
          _editControllers
              .add(TextEditingController(text: _commentController.text));
          _commentController.clear();
        });
      } catch (e) {
        print('Error adding comment: $e');
      }
    }
  }

  void confirmDeleteComment(int index) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('댓글 삭제'),
        content: Text('정말 이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deleteComment(index);
    }
  }

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
      await doc.reference.delete();
    }

    setState(() {
      comments.removeAt(index);
      _isEditing.removeAt(index);
      _editControllers.removeAt(index);
    });
  }

  void toggleEditMode(int index) {
    setState(() {
      _isEditing[index] = !_isEditing[index];
    });
  }

  void saveComment(int index) async {
    final updatedContent = _editControllers[index].text;

    if (updatedContent.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글은 최대 100자까지 작성 가능합니다')),
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
      await doc.reference.update({'content': updatedContent});
    }

    setState(() {
      comments[index]['content'] = updatedContent;
      _isEditing[index] = false;
    });
  }

  void togglePostEditMode() {
    setState(() {
      _isEditingPost = !_isEditingPost;
    });
  }

  void savePost() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('community')
          .where('author', isEqualTo: widget.post['author'])
          .where('title', isEqualTo: widget.post['title'])
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.update({
          'content': _contentController.text,
        });
      }

      widget.onPostUpdated({
        'title': widget.post['title']!,
        'content': _contentController.text,
        'author': widget.post['author']!,
        'date': widget.post['date']!,
        'timestamp': widget.post['timestamp']!,
      });

      setState(() {
        _isEditingPost = false;
      });
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  void confirmDeletePost() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('글 삭제'),
        content: Text('정말 이 글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deletePost();
    }
  }

  void deletePost() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('community')
          .where('content', isEqualTo: widget.post['content'])
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }

      widget.onPostDeleted();
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post['author'] ?? 'Unknown Author',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.post['date'] ?? 'Unknown Date',
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
            _isEditingPost
                ? TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    enabled: false, // title은 수정 불가
                  )
                : Text(
                    widget.post['title']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            SizedBox(height: 16),
            _isEditingPost
                ? TextField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                    maxLines: 5,
                  )
                : Text(
                    widget.post['content']!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
            SizedBox(height: 20),
            if (_isEditingPost)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: savePost,
                    child: Text('Save'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: togglePostEditMode,
                    child: Text('Cancel'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  ElevatedButton(
                    onPressed: togglePostEditMode,
                    child: Text('Edit'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: confirmDeletePost,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.black),
            SizedBox(height: 10),
            Text(
              '댓글',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, size: 30),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['author']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  comment['date']!,
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
                        _isEditing[index]
                            ? TextField(
                                controller: _editControllers[index],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  errorText:
                                      _editControllers[index].text.length > 100
                                          ? '댓글은 최대 100자까지 작성 가능합니다'
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
                            TextButton(
                              onPressed: () => toggleEditMode(index),
                              child: Text(
                                _isEditing[index] ? 'Cancel' : 'Edit',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            if (_isEditing[index])
                              TextButton(
                                onPressed: () => saveComment(index),
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            TextButton(
                              onPressed: () => confirmDeleteComment(index),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 1, color: Colors.grey),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 1, color: Colors.black),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _commentController.text.length > 100
                            ? '댓글은 최대 100자까지 작성 가능합니다'
                            : null,
                      ),
                      enabled: _currentUser != null, // 로그인된 사용자만 입력 가능
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addComment,
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
      ),
    );
  }
}
