import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'menu_item.dart'; // Import the MenuItem class

class MenuRegOne extends StatefulWidget {
  final Function(MenuItem) onSave; // 메뉴 저장 후 호출될 콜백 함수를 받아옴.

  MenuRegOne({required this.onSave}); // 생성자에서 'onSave' 콜백을 초기화.

  @override
  _MenuRegOneState createState() => _MenuRegOneState(); // 상태를 관리할 State를 생성.
}

class _MenuRegOneState extends State<MenuRegOne> {
  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리하기 위한 키를 생성.
  final TextEditingController _nameController = TextEditingController(); // 메뉴 이름 입력 필드를 제어하는 컨트롤러.
  final TextEditingController _priceController = TextEditingController(); // 메뉴 가격 입력 필드를 제어하는 컨트롤러.
  final TextEditingController _descriptionController = TextEditingController(); // 메뉴 설명 입력 필드를 제어하는 컨트롤러.
  final TextEditingController _originController = TextEditingController(); // 메뉴 원산지 입력 필드를 제어하는 컨트롤러.
  File? _imageFile; // 선택된 이미지 파일을 저장할 변수.
  String _photoUrl = ''; // 업로드된 이미지의 URL을 저장할 변수.

  @override
  void dispose() {
    // 위젯이 소멸될 때 컨트롤러를 해제하여 메모리 누수를 방지.
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _originController.dispose();
    super.dispose();
  }

  // 이미지를 갤러리에서 선택하는 메소드.
  Future<void> _pickImage() async {
    final picker = ImagePicker(); // ImagePicker 인스턴스를 생성.
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지를 선택.

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // 선택된 이미지 파일의 경로를 File 객체로 변환하여 저장.
      });
    }
  }

   // 선택된 이미지를 Firebase Storage에 업로드하고 URL을 반환하는 메소드.
  Future<String> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref(); // Firebase Storage 참조를 가져옴.
      final imageRef = storageRef.child('menu_images/${DateTime.now().millisecondsSinceEpoch}.jpg'); // 업로드할 이미지의 경로를 설정.
      await imageRef.putFile(image); // 이미지 파일을 Firebase Storage에 업로드.
      return await imageRef.getDownloadURL(); // 업로드된 이미지의 다운로드 URL을 반환.
    } catch (e) {
      print('Image upload error: $e'); // 업로드 중 오류가 발생하면 콘솔에 출력.
      return ''; // 오류 발생 시 빈 문자열 반환.
    }
  }

  // 입력된 문자열이 유효한 한글인지 검사하는 메소드.
  bool _isValidKorean(String value) {
    final koreanRegex = RegExp(r'^[가-힣\s]+$'); // 한글과 공백만 허용하는 정규 표현식.
    return koreanRegex.hasMatch(value); // 문자열이 정규 표현식과 일치하는지 확인.
  }

  // 입력된 원산지 문자열이 유효한 형식인지 검사하는 메소드.
  bool _isValidOrigin(String value) {
    final originRegex = RegExp(r'^[가-힣\s:,()]+$'); // 한글, 공백, 특수문자(:, ())만 허용하는 정규 표현식.
    return originRegex.hasMatch(value); // 문자열이 정규 표현식과 일치하는지 확인.
  }

  // 폼을 저장하고 Firestore에 메뉴 데이터를 추가하는 메소드.
  Future<void> _save() async {
    if (_formKey.currentState!.validate()) { // 폼의 모든 필드가 유효한지 검사.
      if (_imageFile == null) { // 이미지가 선택되지 않은 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 업로드해주세요.')), // 오류 메시지를 화면에 표시.
        );
        return; // 메소드를 종료하여 저장을 중단.
      }

      final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 정보를 가져옴.

      if (user != null) { // 사용자가 로그인되어 있는지 확인.
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(); // Firestore에서 사용자의 문서를 가져옴.
          final nickname = userDoc.data()?['nickname'] as String?; // 사용자 문서에서 닉네임을 가져옴.

          if (nickname != null) { // 닉네임이 존재하는 경우.
            final restaurantQuery = await FirebaseFirestore.instance
                .collection('restaurants')
                .where('nickname', isEqualTo: nickname)
                .where('isDeleted', isEqualTo: false)
                .get(); // 닉네임과 일치하고 삭제되지 않은 레스토랑을 Firestore에서 조회.

            if (restaurantQuery.docs.isNotEmpty) { // 레스토랑이 존재하는 경우.
              final restaurantDoc = restaurantQuery.docs.first.reference; // 첫 번째 레스토랑 문서 참조를 가져옴.

              _photoUrl = await _uploadImage(_imageFile!); // 이미지를 Firebase Storage에 업로드하고 URL을 가져옴.
              if (_photoUrl.isEmpty) { // 업로드에 실패한 경우.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('사진 업로드 중 오류가 발생했습니다. 다시 시도해주세요.')), // 오류 메시지를 화면에 표시.
                );
                return; // 메소드를 종료하여 저장을 중단.
              }

              final MenuItem item = MenuItem(
                id: '', // ID는 빈 값으로 초기화, Firestore에서 자동 생성.
                name: _nameController.text, // 입력된 메뉴명을 저장.
                price: int.parse(_priceController.text), // 입력된 가격을 정수로 변환하여 저장.
                description: _descriptionController.text, // 입력된 설명을 저장.
                origin: _originController.text, // 입력된 원산지를 저장.
                photoUrl: _photoUrl, // 업로드된 이미지의 URL을 저장.
              );

              await restaurantDoc.collection('menus').add(item.toMap()); // Firestore에 메뉴 데이터를 추가.

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('메뉴가 등록되었습니다.')), // 성공 메시지를 화면에 표시.
              );

              widget.onSave(item); // 부모 위젯에 메뉴 데이터를 전달하여 저장.
              Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아감.
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('닉네임과 일치하는 음식점을 찾을 수 없습니다.')), // 레스토랑을 찾을 수 없는 경우 오류 메시지를 표시.
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('사용자의 닉네임을 찾을 수 없습니다.')), // 닉네임을 찾을 수 없는 경우 오류 메시지를 표시.
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('메뉴 등록 중 오류가 발생했습니다. 다시 시도해주세요.')), // 메뉴 등록 중 오류 발생 시 메시지를 표시.
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')), // 사용자가 로그인되어 있지 않은 경우 오류 메시지를 표시.
        );
      }
    }
  }

// 위젯의 UI를 빌드하는 메소드.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메뉴 등록', // 앱 바의 제목을 설정.
          style: TextStyle(
            color: Color(0xFF1C1C21), // 텍스트 색상을 설정.
            fontSize: 18, // 텍스트 크기를 설정.
            fontFamily: 'Epilogue', // 텍스트 폰트를 설정.
            fontWeight: FontWeight.w700, // 텍스트 두께를 설정.
            height: 0.07, // 줄 높이를 설정.
            letterSpacing: -0.27, // 글자 간격을 설정.
          ),
        ),
      ),
      body: SingleChildScrollView( // 스크롤 가능한 화면을 제공.
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 화면의 모든 가장자리에 패딩을 추가.
          child: Form(
            key: _formKey, // 폼의 키를 설정하여 폼 상태를 관리.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 수평으로 늘림.
              children: [
                SizedBox(height: 20), // 위젯 사이에 20px 간격을 추가.
                Text(
                  '메뉴 정보', // 섹션 제목을 표시.
                  style: TextStyle(
                    color: Color(0xFF1C1C21), // 텍스트 색상을 설정.
                    fontSize: 18, // 텍스트 크기를 설정.
                    fontFamily: 'Epilogue', // 텍스트 폰트를 설정.
                    height: 0.07, // 줄 높이를 설정.
                    letterSpacing: -0.27, // 글자 간격을 설정.
                    fontWeight: FontWeight.w700, // 텍스트 두께를 설정.
                  ),
                ),
                SizedBox(height: 20), // 위젯 사이에 20px 간격을 추가.
                Container(
                    width: 500, // 가로 크기를 설정.
                    child: Divider(color: Colors.black, thickness: 2.0)), // 섹션 구분선을 추가.
                SizedBox(height: 20), // 위젯 사이에 20px 간격을 추가.
                Center(
                  child: GestureDetector(
                    onTap: _pickImage, // 이미지 선택을 위해 탭 제스처를 감지.
                    child: Container(
                      width: 358, // 컨테이너의 가로 크기를 설정.
                      height: 201, // 컨테이너의 세로 크기를 설정.
                      decoration: BoxDecoration(
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!), fit: BoxFit.fill) // 선택된 이미지로 컨테이너를 채움.
                            : DecorationImage(
                                image: AssetImage("assets/images/malatang.png"),
                                fit: BoxFit.fill), // 기본 이미지를 표시.
                        borderRadius: BorderRadius.circular(12), // 컨테이너의 모서리를 둥글게 설정.
                      ),
                      child: _imageFile == null
                          ? Icon(
                              Icons.camera_alt, // 이미지가 없을 때 카메라 아이콘을 표시.
                              color: Colors.white, // 아이콘 색상을 설정.
                              size: 50, // 아이콘 크기를 설정.
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 50), // 위젯 사이에 50px 간격을 추가.
                Text(
                  '메뉴명', // 입력 필드 레이블을 표시.
                  style: TextStyle(
                    color: Color(0xFF1C1C21), // 텍스트 색상을 설정.
                    fontSize: 18, // 텍스트 크기를 설정.
                    fontFamily: 'Epilogue', // 텍스트 폰트를 설정.
                    height: 0.07, // 줄 높이를 설정.
                    letterSpacing: -0.27, // 글자 간격을 설정.
                  ),
                ),
                TextFormField(
                  controller: _nameController, // 메뉴명 입력 필드에 텍스트 컨트롤러를 연결.
                  decoration: InputDecoration(), // 기본 입력 필드 스타일을 사용.
                  validator: (value) {
                    if (value == null || value.isEmpty) { // 값이 비어있을 경우.
                      return '메뉴명을 입력해주세요'; // 오류 메시지 반환.
                    }
                    if (value.length >= 10) { // 메뉴명이 10글자 이상일 경우.
                      return '10글자 미만으로 입력하세요'; // 오류 메시지 반환.
                    }
                    if (!_isValidKorean(value)) { // 메뉴명이 유효한 한글인지 확인.
                      return '메뉴명은 한글로만 입력이 가능합니다'; // 오류 메시지 반환.
                    }
                    return null; // 모든 조건을 통과하면 오류 없음.
                  },
                ),
                SizedBox(height: 50), // 위젯 사이에 50px 간격을 추가.
                Text(
                  '가격', // 입력 필드 레이블을 표시.
                  style: TextStyle(
                    color: Color(0xFF1C1C21), // 텍스트 색상을 설정.
                    fontSize: 18, // 텍스트 크기를 설정.
                    fontFamily: 'Epilogue', // 텍스트 폰트를 설정.
                    height: 0.07, // 줄 높이를 설정.
                    letterSpacing: -0.27, // 글자 간격을 설정.
                  ),
                ),
                TextFormField(
                  controller: _priceController, // 가격 입력 필드에 텍스트 컨트롤러를 연결.
                  decoration: InputDecoration(
                    suffixText: '원', // 필드 끝에 '원'을 표시.
                  ),
                  keyboardType: TextInputType.number, // 숫자 입력 타입으로 설정.
                  validator: (value) {
                    if (value == null || value.isEmpty) { // 값이 비어있을 경우.
                      return '가격을 입력해주세요'; // 오류 메시지 반환.
                    }
                    final price = int.tryParse(value); // 입력 값을 정수로 변환 시도.
                    if (price == null) { // 정수 변환에 실패한 경우.
                      return '유효한 숫자를 입력해주세요'; // 오류 메시지 반환.
                    }
                    if (price > 1000000) { // 가격이 100만원 초과일 경우.
                      return '가격은 백만원 이하여야 합니다'; // 오류 메시지 반환.
                    }
                    return null; // 모든 조건을 통과하면 오류 없음.
                  },
                ),
                SizedBox(height: 50), // 위젯 사이에 50px 간격을 추가.
                Text(
                  '설명', // 입력 필드 레이블을 표시.
                  style: TextStyle(
                    color: Color(0xFF1C1C21), // 텍스트 색상을 설정.
                    fontSize: 18, // 텍스트 크기를 설정.
                    fontFamily: 'Epilogue', // 텍스트 폰트를 설정.
                    height: 0.07, // 줄 높이를 설정.
                    letterSpacing: -0.27, // 글자 간격을 설정.
                  ),
                ),
                TextFormField(
                  controller: _descriptionController, // 설명 입력 필드에 텍스트 컨트롤러를 연결.
                  decoration: InputDecoration(), // 기본 입력 필드 스타일을 사용.
                  validator: (value) {
                    if (value == null || value.isEmpty) { // 값이 비어있을 경우.
                      return '설명을 입력해주세요'; // 오류 메시지 반환.
                    }
                    if (value.length < 5) { // 설명이 5글자 미만일 경우.
                      return '설명은 최소 5글자 이상 입력해야 합니다'; // 오류 메시지 반환.
                    }
                    if (value.length > 100) { // 설명이 100글자 초과일 경우.
                      return '최대 100글자까지 입력 가능합니다'; // 오류 메시지 반환.
                    }
                    if (!_isValidKorean(value)) { // 설명이 유효한 한글인지 확인.
                      return '설명은 한국어로만 입력해주세요'; // 오류 메시지 반환.
                    }
                    return null; // 모든 조건을 통과하면 오류 없음.
                  },
                ),
                SizedBox(height: 50), // 위젯 사이에 50px 간격을 추가.
                Text(
                  '원산지', // 입력 필드 레이블을 표시.
                  style: TextStyle(
                    color: Color(0xFF1C1C21), // 텍스트 색상을 설정.
                    fontSize: 18, // 텍스트 크기를 설정.
                    fontFamily: 'Epilogue', // 텍스트 폰트를 설정.
                    height: 0.07, // 줄 높이를 설정.
                    letterSpacing: -0.27, // 글자 간격을 설정.
                  ),
                ),
                TextFormField(
                  controller: _originController, // 원산지 입력 필드에 텍스트 컨트롤러를 연결.
                  decoration: InputDecoration(), // 기본 입력 필드 스타일을 사용.
                  validator: (value) {
                    if (value == null || value.isEmpty) { // 값이 비어있을 경우.
                      return '원산지를 입력해주세요'; // 오류 메시지 반환.
                    }
                    if (value.length > 100) { // 원산지가 100글자 초과일 경우.
                      return '100글자 이하로 입력해주세요'; // 오류 메시지 반환.
                    }
                    if (!_isValidOrigin(value)) { // 원산지가 유효한 형식인지 확인.
                      return '원산지는 한국어랑 특수문자(: ,)으로만 입력해주세요'; // 오류 메시지 반환.
                    }
                    return null; // 모든 조건을 통과하면 오류 없음.
                  },
                ),
                SizedBox(height: 40), // 위젯 사이에 40px 간격을 추가.
                ElevatedButton(
                  onPressed: _save, // 저장 버튼이 눌렸을 때 _save 메소드를 호출.
                  child: Text('등록'), // 버튼에 표시될 텍스트.
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
