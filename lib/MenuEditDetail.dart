import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// 메뉴 아이템 클래스 정의
class MenuItem {
  final String id; // 메뉴 아이템 ID
  final String name; // 메뉴 이름
  final int price; // 메뉴 가격
  final String description; // 메뉴 설명
  final String origin; // 원산지
  final String photoUrl; // 메뉴 사진 URL

  // 생성자
  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.origin,
    required this.photoUrl,
  });

  // Firestore 문서로부터 MenuItem 객체를 생성하는 팩토리 메서드
  factory MenuItem.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return MenuItem(
      id: document.id,
      name: data['menuName'] ?? '',
      price: data['price'] ?? 0,
      description: data['description'] ?? '',
      origin: data['origin'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}

// 메뉴 수정 페이지 위젯
class MenuEditDetail extends StatefulWidget {
  final String menuItemId; // 수정할 메뉴 아이템의 ID

  MenuEditDetail({required this.menuItemId});

  @override
  _MenuEditDetailState createState() => _MenuEditDetailState();
}

class _MenuEditDetailState extends State<MenuEditDetail> {
  final _formKey = GlobalKey<FormState>(); // 폼 검증을 위한 GlobalKey
  final TextEditingController _nameController = TextEditingController(); // 메뉴 이름 입력 컨트롤러
  final TextEditingController _priceController = TextEditingController(); // 메뉴 가격 입력 컨트롤러
  final TextEditingController _descriptionController = TextEditingController(); // 메뉴 설명 입력 컨트롤러
  final TextEditingController _originController = TextEditingController(); // 원산지 입력 컨트롤러
  File? _imageFile; // 선택한 이미지 파일
  String _photoUrl = ''; // 메뉴 사진 URL
  bool _isLoading = true; // 로딩 상태 표시

  @override
  void initState() {
    super.initState();
    _loadMenuItem(); // 메뉴 아이템 로드
  }

  // Firestore에서 메뉴 아이템 데이터를 로드하는 함수
  Future<void> _loadMenuItem() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDocSnapshot = await userDocRef.get();
      final resNum = userDocSnapshot.data()?['resNum'] as String?;

      if (resNum != null) {
        final restaurantQuery = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('registrationNumber', isEqualTo: resNum)
            .where('isDeleted', isEqualTo: false)
            .get();

        if (restaurantQuery.docs.isNotEmpty) {
          final restaurantId = restaurantQuery.docs.first.id;
          final menuDoc = await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menus')
              .doc(widget.menuItemId)
              .get();

          if (menuDoc.exists) {
            final menuItem = MenuItem.fromDocument(menuDoc);
            setState(() {
              _nameController.text = menuItem.name;
              _priceController.text = menuItem.price.toString();
              _descriptionController.text = menuItem.description;
              _originController.text = menuItem.origin;
              _photoUrl = menuItem.photoUrl;
              _isLoading = false; // 로딩 완료
            });
          }
        }
      }
    }
  }

  // 갤러리에서 이미지 선택 함수
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // 선택한 파일을 설정
      });
    }
  }

  // 선택한 이미지를 Firebase Storage에 업로드하고 URL을 반환하는 함수
  Future<String> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef
          .child('menu_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return '';
    }
  }

  // 한국어 유효성 검사 함수
  bool _isValidKorean(String value) {
    final koreanRegex = RegExp(r'^[가-힣\s]+$');
    return koreanRegex.hasMatch(value);
  }

  // 원산지 유효성 검사 함수 (한국어와 특수문자 허용)
  bool _isValidOrigin(String value) {
    final originRegex = RegExp(r'^[가-힣\s:,]+$');
    return originRegex.hasMatch(value);
  }

  // 메뉴 수정 저장 함수
  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          final resNum = userDoc.data()?['resNum'] as String?;

          if (resNum != null) {
            final restaurantQuery = await FirebaseFirestore.instance
                .collection('restaurants')
                .where('registrationNumber', isEqualTo: resNum)
                .where('isDeleted', isEqualTo: false)
                .get();

            if (restaurantQuery.docs.isNotEmpty) {
              final restaurantDoc = restaurantQuery.docs.first.reference;

              // 이미지 파일이 선택된 경우 업로드
              if (_imageFile != null) {
                _photoUrl = await _uploadImage(_imageFile!);
                if (_photoUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('사진 업로드 중 오류가 발생했습니다. 다시 시도해주세요.')),
                  );
                  return;
                }
              }

              // Firestore에 메뉴 정보 업데이트
              await restaurantDoc
                  .collection('menus')
                  .doc(widget.menuItemId)
                  .update({
                'price': int.parse(_priceController.text),
                'description': _descriptionController.text,
                'origin': _originController.text,
                'photoUrl': _photoUrl,
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('메뉴가 수정되었습니다.')),
              );

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('음식점을 먼저 등록해주세요.')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('사용자의 resNum을 찾을 수 없습니다.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('메뉴 수정 중 오류가 발생했습니다. 다시 시도해주세요.')),
          );
          print('Error: $e');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')),
        );
      }
    }
  }

  // 메뉴 삭제 함수
  Future<void> _delete() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final resNum = userDoc.data()?['resNum'] as String?;

        if (resNum != null) {
          final restaurantQuery = await FirebaseFirestore.instance
              .collection('restaurants')
              .where('registrationNumber', isEqualTo: resNum)
              .where('isDeleted', isEqualTo: false)
              .get();

          if (restaurantQuery.docs.isNotEmpty) {
            final restaurantDoc = restaurantQuery.docs.first.reference;

            await restaurantDoc
                .collection('menus')
                .doc(widget.menuItemId)
                .delete();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('메뉴가 삭제되었습니다.')),
            );

            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('음식점을 찾을 수 없습니다.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사용자의 resNum을 찾을 수 없습니다.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메뉴 삭제 중 오류가 발생했습니다. 다시 시도해주세요.')),
        );
        print('Error: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')),
      );
    }
  }

  // 메뉴 삭제 확인 다이얼로그 표시 함수
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('메뉴 삭제'),
          content: Text('이 메뉴를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _delete(); // 삭제 함수 호출
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('메뉴 수정'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // 로딩 인디케이터
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메뉴 수정',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // 폼 검증을 위한 키 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text(
                  '메뉴 정보',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    width: 500,
                    child: Divider(color: Colors.black, thickness: 2.0)), // 구분선
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage, // 이미지 선택 함수 호출
                    child: Container(
                      width: 358,
                      height: 201,
                      decoration: BoxDecoration(
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: NetworkImage(_photoUrl),
                                fit: BoxFit.fill,
                              ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _imageFile == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.transparent,
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  '메뉴명',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _nameController, // 메뉴 이름 입력 컨트롤러
                  decoration: InputDecoration(),
                  enabled: false, // 메뉴명은 수정 불가
                ),
                SizedBox(height: 50),
                Text(
                  '가격',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _priceController, // 가격 입력 컨트롤러
                  decoration: InputDecoration(
                    suffixText: '원',
                  ),
                  keyboardType: TextInputType.number, // 숫자 입력 타입
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '가격을 입력해주세요';
                    }
                    final intPrice = int.tryParse(value);
                    if (intPrice == null) {
                      return '유효한 숫자를 입력해주세요';
                    }
                    if (intPrice > 1000000) {
                      return '가격은 백만원 이하이어야 합니다';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                Text(
                  '설명',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _descriptionController, // 설명 입력 컨트롤러
                  decoration: InputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '설명을 입력해주세요';
                    }
                    if (!_isValidKorean(value)) {
                      return '설명은 한국어로만 입력해주세요';
                    }
                    if (value.length < 5) {
                      return '설명은 최소 5글자 이상 입력해야 합니다';
                    }
                    if (value.length > 100) {
                      return '최대 100글자까지 입력 가능합니다';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                Text(
                  '원산지',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    height: 0.07,
                    letterSpacing: -0.27,
                  ),
                ),
                TextFormField(
                  controller: _originController, // 원산지 입력 컨트롤러
                  decoration: InputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '원산지를 입력해주세요';
                    }
                    if (!_isValidOrigin(value)) {
                      return '원산지는 한국어 및 특수문자(: ,)만 입력해주세요';
                    }
                    if (value.length > 100) {
                      return '100글자 이하로 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _showDeleteConfirmationDialog, // 메뉴 삭제 확인 다이얼로그 표시
                    child: Text(
                      '메뉴 삭제',
                      style: TextStyle(
                        color: Color(0xFF1C1C21),
                        fontSize: 18,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w700,
                        height: 0.07,
                        letterSpacing: -0.27,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _save, // 메뉴 저장 함수 호출
                  child: Text('수정'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
