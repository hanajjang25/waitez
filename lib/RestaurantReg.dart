import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'googleMap.dart';

class regRestaurant extends StatefulWidget {                          // 음식점 등록을 위한 StatefulWidget 클래스.
  const regRestaurant({super.key});                                   // 생성자.

  @override
  _RegRestaurantState createState() => _RegRestaurantState();         // 상태를 관리할 State 생성.
}

class _RegRestaurantState extends State<regRestaurant> {
  final _formKey = GlobalKey<FormState>();                            // 폼 상태를 관리하기 위한 GlobalKey.
  String _restaurantName = '';                                        // 음식점 이름을 저장할 변수.
  String _location = '';                                              // 음식점 위치를 저장할 변수.
  String _description = '';                                           // 음식점 설명을 저장할 변수.
  String _registrationNumber = '';                                    // 음식점 등록번호를 저장할 변수.
  TimeOfDay? _startTime;                                              // 영업 시작 시간을 저장할 변수.
  TimeOfDay? _endTime;                                                // 영업 종료 시간을 저장할 변수.
  String _photoUrl = '';                                              // 음식점 사진 URL을 저장할 변수.
  String _nickname = '';                                              // 사용자의 닉네임을 저장할 변수.
  bool _isOpen = false;                                               // 음식점의 영업 상태를 저장할 변수.
  File? _imageFile;                                                   // 선택한 이미지 파일을 저장할 변수.
  String _averageWaitTime = '';                                       // 평균 대기시간을 저장할 변수.
  String? _userRegistrationNumber;                                    // 사용자의 등록번호를 저장할 변수.

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('restaurants');           // Firestore에서 음식점 컬렉션을 참조.

  @override
  void initState() {
    super.initState();                                                // 부모 클래스의 initState 호출.
    _loadUserData();                                                  // 사용자 데이터를 로드.
  }

 Future<void> _loadUserData() async {                                // 사용자 데이터를 Firestore에서 로드하는 메소드.
    User? user = FirebaseAuth.instance.currentUser;                   // 현재 로그인된 사용자 정보를 가져옴.
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();                                                     // Firestore에서 사용자 문서를 가져옴.
      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          var data = userDoc.data() as Map<String, dynamic>;          // 사용자 데이터를 Map으로 변환.
          _nickname = data['nickname'] ?? '';                         // 닉네임 설정.
          _location = data.containsKey('location') ? data['location'] : ''; // 위치 설정.
          _userRegistrationNumber = data['resNum'] ?? '';             // 사용자 등록번호 설정.
        });
      }
    }
  }

  Future<void> _pickImage() async {                                   // 이미지를 선택하는 메소드.
    final picker = ImagePicker();                                     // 이미지 선택기를 생성.
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지를 선택.

    if (pickedFile != null) {                                         // 이미지가 선택된 경우.
      setState(() {
        _imageFile = File(pickedFile.path);                           // 선택한 이미지 파일을 저장.
      });
    }
  }

  Future<String> _uploadImage(File image) async {                     // 이미지를 Firebase Storage에 업로드하는 메소드.
    try {
      final storageRef = FirebaseStorage.instance.ref();              // Firebase Storage 참조를 생성.
      final imageRef = storageRef.child(
          'restaurant_images/${DateTime.now().millisecondsSinceEpoch}.jpg'); // 이미지 파일 경로 설정.
      await imageRef.putFile(image);                                  // 이미지 파일을 업로드.
      return await imageRef.getDownloadURL();                         // 업로드된 이미지의 다운로드 URL을 반환.
    } catch (e) {
      print('Image upload error: $e');                                // 오류 발생 시 로그 출력.
      return '';                                                      // 오류가 발생하면 빈 문자열 반환.
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),                                   // 현재 시간을 초기값으로 설정.
    );
    if (picked != null) {                                             // 시간이 선택된 경우.
      setState(() {
        if (isStartTime) {                                            // 시작 시간 선택 시.
          _startTime = picked;                                        // 시작 시간을 설정.
        } else {                                                      // 종료 시간 선택 시.
          _endTime = picked;                                          // 종료 시간을 설정.
        }
      });
    }
  }

  void _submitForm() async {                                          // 폼 제출을 처리하는 메소드.
    if (_formKey.currentState!.validate()) {                          // 폼이 유효한지 검증.
      _formKey.currentState!.save();                                  // 폼 상태 저장.

      if (_startTime == null || _endTime == null) {                   // 영업 시간이 설정되지 않은 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('영업시간을 설정해주세요.')),          // 오류 메시지 표시.
        );
        return;
      }

      final startTime = DateTime(
        0,
        1,
        1,
        _startTime!.hour,
        _startTime!.minute,
      );
      final endTime = DateTime(
        0,
        1,
        1,
        _endTime!.hour,
        _endTime!.minute,
      );

      if (endTime.isBefore(startTime)) {                              // 종료 시간이 시작 시간보다 빠른 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('영업시간 설정이 올바르지 않습니다.')), // 오류 메시지 표시.
        );
        return;
      }

      if (_imageFile != null) {                                       // 이미지 파일이 있는 경우.
        _photoUrl = await _uploadImage(_imageFile!);                  // 이미지를 업로드하고 URL을 저장.
        if (_photoUrl.isEmpty) {                                      // 업로드에 실패한 경우.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사진 업로드 중 오류가 발생했습니다. 다시 시도해주세요.')), // 오류 메시지 표시.
          );
          return;
        }
      } else {                                                        // 이미지 파일이 없는 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 업로드해주세요.')),            // 오류 메시지 표시.
        );
        return;
      }

      if (_userRegistrationNumber != _registrationNumber) {           // 입력된 등록번호가 사용자 등록번호와 일치하지 않는 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록번호가 일치하지 않습니다.')),    // 오류 메시지 표시.
        );
        return;
      }

      try {
        final QuerySnapshot nameSnapshot = await _collectionRef
            .where('restaurantName', isEqualTo: _restaurantName)
            .get();                                                   // 동일한 음식점 이름이 있는지 확인.
        if (nameSnapshot.docs.isNotEmpty) {                           // 중복된 이름이 있는 경우.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미 등록된 음식점 이름입니다.')), // 오류 메시지 표시.
          );
          return;
        }

        final QuerySnapshot numberSnapshot = await _collectionRef
            .where('registrationNumber', isEqualTo: _registrationNumber)
            .get();                                                   // 동일한 등록번호가 있는지 확인.
        if (numberSnapshot.docs.isNotEmpty) {                         // 중복된 등록번호가 있는 경우.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미 등록되어 있는 음식점입니다.')), // 오류 메시지 표시.
          );
          return;
        }

        _isOpen = _checkBusinessHours(_startTime!, _endTime!);        // 영업 시간에 따라 영업 상태 설정.

        await _collectionRef.add({                                    // 데이터를 Firestore에 저장.
          'restaurantName': _restaurantName,                          // 음식점 이름 저장.
          'location': _location,                                      // 위치 저장.
          'description': _description,                                // 설명 저장.
          'registrationNumber': _registrationNumber,                  // 등록번호 저장.
          'businessHours':
              '${_startTime!.format(context)} ~ ${_endTime!.format(context)}', // 영업시간 저장.
          'photoUrl': _photoUrl,                                      // 사진 URL 저장.
          'isOpen': _isOpen,                                          // 영업 상태 저장.
          'nickname': _nickname,                                      // 닉네임 저장.
          'isDeleted': false,                                         // 삭제 여부 저장.
          'averageWaitTime':
              int.parse(_averageWaitTime),                            // 평균 대기시간을 int로 변환하여 저장.
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('음식점 등록 완료!')),                // 성공 메시지 표시.
        );

        Future.delayed(Duration(seconds: 3), () {                     // 3초 후에 직원 home 페이지로 이동.
          Navigator.pushNamed(context, '/homeStaff');
        });
      } catch (e) {
        print('Error adding restaurant: $e');                         // 오류 발생 시 로그 출력.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('음식점 등록 중 오류가 발생했습니다. 다시 시도해주세요.')), // 오류 메시지 표시.
        );
      }
    }
  }

  
 bool _checkBusinessHours(TimeOfDay startTime, TimeOfDay endTime) {  // 영업 시간이 현재 시간과 겹치는지 확인하는 메소드.
    final now = TimeOfDay.now();                                      // 현재 시간을 가져옴.
    final currentTime = DateTime(
      0,
      1,
      1,
      now.hour,
      now.minute,
    );

    final start = DateTime(
      0,
      1,
      1,
      startTime.hour,
      startTime.minute,
    );

    final end = DateTime(
      0,
      1,
      1,
      endTime.hour,
      endTime.minute,
    );

    if (end.isBefore(start)) {                                        // 종료 시간이 시작 시간보다 빠른 경우.
      return currentTime.isAfter(start) || currentTime.isBefore(end); // 현재 시간이 영업 시간 내에 있는지 확인.
    } else {
      return currentTime.isAfter(start) && currentTime.isBefore(end); // 현재 시간이 영업 시간 내에 있는지 확인.
    }
  }

  bool _validateRestaurantName(String value) {                        // 음식점 이름이 유효한지 확인하는 메소드.
    final nameRegExp = RegExp(r'^[가-힣]+$');                          // 한글만 허용하는 정규식.
    if (!nameRegExp.hasMatch(value)) {                                // 한글로만 구성되지 않은 경우.
      return false;                                                   // 유효하지 않음.
    }
    if (value.length > 15) {                                          // 15글자를 초과한 경우.
      return false;                                                   // 유효하지 않음.
    }
    return true;                                                      // 유효한 이름.
  }

  bool _validateDescription(String value) {                           // 설명이 유효한지 확인하는 메소드.
    final descriptionRegExp = RegExp(r'^[가-힣\s]+$');                 // 한글과 공백만 허용하는 정규식.
    if (!descriptionRegExp.hasMatch(value)) {                         // 한글과 공백으로만 구성되지 않은 경우.
      return false;                                                   // 유효하지 않음.
    }
    if (value.length > 100) {                                         // 100글자를 초과한 경우.
      return false;                                                   // 유효하지 않음.
    }
    return true;                                                      // 유효한 설명.
  }

  void _updateLocation(String location) {                             // 위치 정보를 업데이트하는 메소드.
    setState(() {
      _location = location;                                           // 새로운 위치 설정.
    });
  }

 @override
  Widget build(BuildContext context) {                                // 위젯의 UI를 빌드하는 메소드.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '음식점 등록',                                                // 앱 바의 제목 설정.
          style: TextStyle(
            color: Color(0xFF1C1C21),                                  // 텍스트 색상 설정.
            fontSize: 18,                                              // 텍스트 크기 설정.
            fontFamily: 'Epilogue',                                    // 폰트 설정.
            fontWeight: FontWeight.w700,                               // 텍스트 굵기 설정.
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),                        // 모든 가장자리에 16px의 패딩 추가.
          child: Form(
            key: _formKey,                                             // 폼의 키 설정.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,          // 자식 위젯들을 수평으로 늘림.
              children: <Widget>[
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Text(
                  '음식점 정보',                                        // 섹션 제목.
                  style: TextStyle(
                    color: Color(0xFF1C1C21),                          // 텍스트 색상 설정.
                    fontSize: 18,                                      // 텍스트 크기 설정.
                    fontFamily: 'Epilogue',                            // 폰트 설정.
                    fontWeight: FontWeight.w700,                       // 텍스트 굵기 설정.
                  ),
                ),
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Divider(color: Colors.black, thickness: 2.0),          // 구분선 추가.
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,                                 // 이미지를 선택하는 메소드 호출.
                    child: Container(
                      width: 358,                                      // 컨테이너 너비 설정.
                      height: 201.38,                                  // 컨테이너 높이 설정.
                      decoration: BoxDecoration(
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),         // 선택된 이미지를 표시.
                                fit: BoxFit.fill,                      // 이미지를 컨테이너에 맞게 채움.
                              )
                            : DecorationImage(
                                image: AssetImage("assets/images/imageUpload.png"), // 기본 이미지 표시.
                                fit: BoxFit.fill,                      // 이미지를 컨테이너에 맞게 채움.
                              ),
                        borderRadius: BorderRadius.circular(12),       // 모서리를 둥글게 설정.
                      ),
                      child: _imageFile == null
                          ? Icon(
                              Icons.camera_alt,                        // 이미지가 없을 때 카메라 아이콘 표시.
                              color: Colors.white,                     // 아이콘 색상 설정.
                              size: 50,                                // 아이콘 크기 설정.
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 30),                                  // 위젯 사이에 30px 간격 추가.
                Container(
                  width: 200,                                          // 컨테이너 너비 설정.
                  alignment: Alignment.centerLeft,                     // 컨테이너 내용 정렬.
                  child: TextButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),                         // 버튼 모서리를 둥글게 설정.
                        )),
                        side: BorderSide(color: Colors.black)),        // 버튼 테두리 설정.
                    onPressed: () async {
                      final location = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MapPage(previousPage: 'RestaurantReg'), // 위치 찾기 페이지로 이동.
                        ),
                      );
                      if (location != null) {                         // 위치가 선택된 경우.
                        _updateLocation(location);                    // 위치 업데이트.
                      }
                    },
                    child: Text(
                      '위치 찾기',                                      // 버튼 텍스트 설정.
                      style: TextStyle(
                        color: Color(0xFF1C1C21),                      // 텍스트 색상 설정.
                        fontSize: 18,                                  // 텍스트 크기 설정.
                        fontFamily: 'Epilogue',                        // 폰트 설정.
                        fontWeight: FontWeight.w700,                   // 텍스트 굵기 설정.
                      ),
                    ),
                  ),
                ),
                if (_location.isNotEmpty)                              // 위치가 설정된 경우.
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20), // 수직으로 20px의 패딩 추가.
                    child: Text(
                      '위치: $_location',                              // 위치 정보를 표시.
                      style: TextStyle(
                        color: Color(0xFF1C1C21),                      // 텍스트 색상 설정.
                        fontSize: 16,                                  // 텍스트 크기 설정.
                        fontFamily: 'Epilogue',                        // 폰트 설정.
                      ),
                    ),
                  ),
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Text(
                  '상호명',                                            // 레이블 텍스트.
                  style: TextStyle(
                    color: Color(0xFF1C1C21),                          // 텍스트 색상 설정.
                    fontSize: 18,                                      // 텍스트 크기 설정.
                    fontFamily: 'Epilogue',                            // 폰트 설정.
                    fontWeight: FontWeight.w700,                       // 텍스트 굵기 설정.
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),                       // 기본 입력 필드 스타일 사용.
                  validator: (value) {
                    if (value == null || value.isEmpty) {              // 값이 비어있는 경우.
                      return '음식점 이름을 입력해주세요';               // 오류 메시지 반환.
                    }
                    if (!_validateRestaurantName(value)) {            // 이름이 유효하지 않은 경우.
                      if (!RegExp(r'^[가-힣]+$').hasMatch(value)) {    // 한글로만 구성되지 않은 경우.
                        return '상호명은 한글로만 가능합니다';           // 오류 메시지 반환.
                      }
                      if (value.length > 15) {                        // 15글자를 초과한 경우.
                        return '15글자 이하로 입력해주세요.';           // 오류 메시지 반환.
                      }
                    }
                    return null;                                      // 유효한 경우 오류 없음.
                  },
                  onSaved: (value) {
                    _restaurantName = value!;                         // 음식점 이름 저장.
                  },
                ),
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Text(
                  '등록번호',                                          // 레이블 텍스트.
                  style: TextStyle(
                    color: Color(0xFF1C1C21),                          // 텍스트 색상 설정.
                    fontSize: 18,                                      // 텍스트 크기 설정.
                    fontFamily: 'Epilogue',                            // 폰트 설정.
                    fontWeight: FontWeight.w700,                       // 텍스트 굵기 설정.
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),                       // 기본 입력 필드 스타일 사용.
                  validator: (value) {
                    if (value == null || value.isEmpty) {              // 값이 비어있는 경우.
                      return '등록번호를 입력해주세요';                 // 오류 메시지 반환.
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {        // 숫자로만 구성되지 않은 경우.
                      return '등록번호는 숫자만 입력 가능합니다';        // 오류 메시지 반환.
                    }
                    return null;                                      // 유효한 경우 오류 없음.
                  },
                  onSaved: (value) {
                    _registrationNumber = value!;                     // 등록번호 저장.
                  },
                ),
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Text(
                  '영업시간 (HH:MM ~ HH:MM)',                          // 레이블 텍스트.
                  style: TextStyle(
                    color: Color(0xFF1C1C21),                          // 텍스트 색상 설정.
                    fontSize: 18,                                      // 텍스트 크기 설정.
                    fontFamily: 'Epilogue',                            // 폰트 설정.
                    fontWeight: FontWeight.w700,                       // 텍스트 굵기 설정.
                  ),
                ),
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,   // 자식 위젯들을 양 끝으로 정렬.
                  children: [
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue[50],              // 버튼 배경색 설정.
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),                         // 버튼 모서리를 둥글게 설정.
                        )),
                      ),
                      onPressed: () => _selectTime(context, true),     // 시작 시간 선택 버튼.
                      child: Text(_startTime != null
                          ? _startTime!.format(context)
                          : '시작 시간 선택'),                           // 시작 시간이 설정되면 표시.
                    ),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue[50],              // 버튼 배경색 설정.
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),                         // 버튼 모서리를 둥글게 설정.
                        )),
                      ),
                      onPressed: () => _selectTime(context, false),    // 종료 시간 선택 버튼.
                      child: Text(_endTime != null
                          ? _endTime!.format(context)
                          : '종료 시간 선택'),                           // 종료 시간이 설정되면 표시.
                    ),
                  ],
                ),
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Text(
                  '1팀당 평균 대기시간 (분)',                          // 레이블 텍스트.
                  style: TextStyle(
                    color: Color(0xFF1C1C21),                          // 텍스트 색상 설정.
                    fontSize: 18,                                      // 텍스트 크기 설정.
                    fontFamily: 'Epilogue',                            // 폰트 설정.
                    fontWeight: FontWeight.w700,                       // 텍스트 굵기 설정.
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),                       // 기본 입력 필드 스타일 사용.
                  validator: (value) {
                    if (value == null || value.isEmpty) {              // 값이 비어있는 경우.
                      return '평균 대기시간을 입력해주세요';            // 오류 메시지 반환.
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {        // 숫자로만 구성되지 않은 경우.
                      return '숫자로만 입력해주세요';                 // 오류 메시지 반환.
                    }
                    return null;                                      // 유효한 경우 오류 없음.
                  },
                  onSaved: (value) {
                    _averageWaitTime = value!;                        // 평균 대기시간 저장.
                  },
                ),
                SizedBox(height: 20),                                  // 위젯 사이에 20px 간격 추가.
                Text(
                  '설명',                                              // 레이블 텍스트.
                  style: TextStyle(
                    color: Color(0xFF1C1C21),                          // 텍스트 색상 설정.
                    fontSize: 18,                                      // 텍스트 크기 설정.
                    fontFamily: 'Epilogue',                            // 폰트 설정.
                    fontWeight: FontWeight.w700,                       // 텍스트 굵기 설정.
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),                       // 기본 입력 필드 스타일 사용.
                  validator: (value) {
                    if (value == null || value.isEmpty) {              // 값이 비어있는 경우.
                      return '음식점에 대한 설명을 입력해주세요';      // 오류 메시지 반환.
                    }
                    if (!_validateDescription(value)) {               // 설명이 유효하지 않은 경우.
                      if (!RegExp(r'^[가-힣\s]+$').hasMatch(value)) {  // 한글과 공백으로만 구성되지 않은 경우.
                        return '설명은 한글로만 가능합니다';           // 오류 메시지 반환.
                      }
                      if (value.length > 100) {                       // 100글자를 초과한 경우.
                        return '최대 100글자까지 입력 가능합니다';     // 오류 메시지 반환.
                      }
                    }
                    return null;                                      // 유효한 경우 오류 없음.
                  },
                  onSaved: (value) {
                    _description = value!;                            // 설명 저장.
                  },
                ),
                SizedBox(height: 40),                                  // 위젯 사이에 40px 간격 추가.
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue[50],                  // 버튼 배경색 설정.
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(10),                             // 버튼 모서리를 둥글게 설정.
                    )),
                  ),
                  onPressed: _submitForm,                              // 등록 버튼이 눌렸을 때 폼 제출.
                  child: Text('등록하기'),                              // 버튼 텍스트 설정.
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
