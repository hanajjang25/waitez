import 'package:flutter/material.dart';

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
  final List<Map<String, String>> comments = [
    {
      'author': '최성철',
      'date': '2024.03.03',
      'content': '원주 추천해드릴까요?',
    },
    {
      'author': '윤정환',
      'date': '2024.03.03',
      'content': '네 좋아요!',
    },
  ];

  final TextEditingController _commentController = TextEditingController();
  final List<bool> _isEditing = [];
  final List<TextEditingController> _editControllers = [];

  bool _isEditingPost = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post['title']);
    _contentController = TextEditingController(text: widget.post['content']);
    for (var comment in comments) {
      _isEditing.add(false);
      _editControllers.add(TextEditingController(text: comment['content']));
    }
  }

  void addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.add({
          'author': '사용자', // 실제 사용자 이름을 사용하도록 수정 필요
          'date': DateTime.now().toIso8601String().substring(0, 10),
          'content': _commentController.text,
        });
        _isEditing.add(false); // 새 댓글에 대한 수정 모드 추가
        _editControllers.add(TextEditingController(
            text: _commentController.text)); // 새 댓글에 대한 컨트롤러 추가
        _commentController.clear();
      });
    }
  }

  void deleteComment(int index) {
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

  void saveComment(int index) {
    setState(() {
      comments[index]['content'] = _editControllers[index].text;
      _isEditing[index] = false;
    });
  }

  void togglePostEditMode() {
    setState(() {
      _isEditingPost = !_isEditingPost;
    });
  }

  void savePost() {
    setState(() {
      widget.onPostUpdated({
        'title': _titleController.text,
        'content': _contentController.text,
        'author': widget.post['author']!,
        'date': widget.post['date']!,
        'timestamp': widget.post['timestamp']!,
      });
      _isEditingPost = false;
    });
  }

  void deletePost() {
    widget.onPostDeleted();
    Navigator.pop(context);
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
                      widget.post['author'] ?? 'Unknown Author', // 기본값 설정
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.post['date'] ?? 'Unknown Date', // 기본값 설정
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
                    onPressed: deletePost,
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
                              onPressed: () => deleteComment(index),
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
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addComment,
                    child: Text('댓글 달기'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlueAccent),
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
