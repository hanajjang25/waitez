import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'googleMap.dart';

class editregRestaurant extends StatefulWidget {                   // 음식점 정보를 수정하는 StatefulWidget.
  const editregRestaurant({super.key});                            // 생성자.

  @override
  _EditRegRestaurantState createState() => _EditRegRestaurantState();   // 상태를 관리할 State를 생성.
}

class _EditRegRestaurantState extends State<editregRestaurant> {
  final _formKey = GlobalKey<FormState>();                         // 폼의 상태를 관리하기 위한 GlobalKey.
  String _restaurantId = '';                                       // 음식점 ID를 저장할 변수.
  String _restaurantName = '';                                     // 음식점 이름을 저장할 변수.
  String _location = '';                                           // 음식점 위치를 저장할 변수.
  String _description = '';                                        // 음식점 설명을 저장할 변수.
  String _registrationNumber = '';                                 // 음식점 등록번호를 저장할 변수.
  TimeOfDay? _startTime;                                           // 영업 시작 시간을 저장할 변수.
  TimeOfDay? _endTime;                                             // 영업 종료 시간을 저장할 변수.
  String _photoUrl = '';                                           // 음식점 사진 URL을 저장할 변수.
  bool _isOpen = false;                                            // 음식점 영업 상태를 저장할 변수.
  bool _isLoading = true;                                          // 로딩 상태를 나타내는 변수.

  @override
  void initState() {
    super.initState();                                             // 부모 클래스의 initState 호출.
    _loadRestaurantData();                                         // 음식점 데이터를 로드.
  }

  Future<void> _loadRestaurantData() async {                       // 음식점 데이터를 Firestore에서 로드하는 메소드.
    final user = FirebaseAuth.instance.currentUser;                // 현재 로그인된 사용자 정보를 가져옴.
    if (user == null) {                                            // 사용자가 로그인되어 있지 않은 경우.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')), // 오류 메시지 표시.
      );
      return;
    }

    try {
      final firestoreDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();                                                  // Firestore에서 사용자 문서를 가져옴.
      final nickname = firestoreDoc.data()?['nickname'] as String?; // 닉네임을 가져옴.

      if (nickname == null) {                                      // 닉네임이 없는 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자의 닉네임을 찾을 수 없습니다.')), // 오류 메시지 표시.
        );
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('nickname', isEqualTo: nickname)
          .where('isDeleted', isEqualTo: false)
          .get();                                                  // Firestore에서 닉네임과 일치하는 음식점 데이터를 가져옴.

      if (querySnapshot.docs.isNotEmpty) {                         // 일치하는 음식점이 있는 경우.
        final doc = querySnapshot.docs.first;                      // 첫 번째 문서를 가져옴.
        final data = doc.data();                                   // 문서의 데이터를 가져옴.
        final businessHours = data['businessHours']?.split(' ~ '); // 영업시간을 '~'로 분리.

        setState(() {                                              // 상태 업데이트.
          _restaurantId = doc.id;                                  // 음식점 ID 설정.
          _restaurantName = data['restaurantName'] ?? '';          // 음식점 이름 설정.
          _location = data['location'] ?? '';                      // 음식점 위치 설정.
          _description = data['description'] ?? '';                // 음식점 설명 설정.
          _registrationNumber = data['registrationNumber'] ?? '';  // 음식점 등록번호 설정.
          _photoUrl = data['photoUrl'] ?? '';                      // 음식점 사진 URL 설정.
          _isOpen = data['isOpen'] ?? false;                       // 음식점 영업 상태 설정.
          _isLoading = false;                                      // 로딩 상태 설정 (완료).
          if (businessHours != null && businessHours.length == 2) { // 영업시간이 유효한 경우.
            _startTime = _parseTime(businessHours[0]);             // 영업 시작 시간 파싱.
            _endTime = _parseTime(businessHours[1]);               // 영업 종료 시간 파싱.
          }
        });
      } else {                                                     // 일치하는 음식점이 없는 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일치하는 음식점 정보를 찾을 수 없습니다.')), // 오류 메시지 표시.
        );
        setState(() {
          _isLoading = false;                                      // 로딩 상태 설정 (완료).
        });
      }
    } catch (e) {
      print('Error loading restaurant data: $e');                  // 오류 발생 시 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다.')), // 오류 메시지 표시.
      );
      setState(() {
        _isLoading = false;                                        // 로딩 상태 설정 (완료).
      });
    }
  }
  
 TimeOfDay _parseTime(String time) {                              // 시간을 TimeOfDay 객체로 파싱하는 메소드.
    final format = DateFormat.Hm();                                // HH:mm 형식으로 시간 포맷터 생성.
    final dateTime = format.parse(time);                           // 문자열을 DateTime 객체로 변환.
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute); // TimeOfDay 객체로 변환하여 반환.
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),                                // 현재 시간을 초기 시간으로 설정.
    );
    if (picked != null) {                                          // 시간이 선택된 경우.
      setState(() {
        if (isStartTime) {                                         // 시작 시간인 경우.
          _startTime = picked;                                     // 시작 시간을 설정.
        } else {                                                   // 종료 시간인 경우.
          _endTime = picked;                                       // 종료 시간을 설정.
        }
      });
    }
  }

 void _submitForm() async {                                       // 폼 제출을 처리하는 메소드.
    if (_formKey.currentState!.validate()) {                       // 폼이 유효한지 검증.
      _formKey.currentState!.save();                               // 폼 상태 저장.

      if (_startTime == null || _endTime == null) {                // 영업 시간이 설정되지 않은 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('영업시간을 설정해주세요.')),       // 오류 메시지 표시.
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

      if (endTime.isBefore(startTime)) {                           // 종료 시간이 시작 시간보다 빠른 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('영업시간 설정이 올바르지 않습니다.')), // 오류 메시지 표시.
        );
        return;
      }

      _isOpen = _checkBusinessHours(_startTime!, _endTime!);       // 영업 시간에 따른 영업 상태 설정.

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(_restaurantId)
          .update({
        'description': _description,                               // 음식점 설명 업데이트.
        'businessHours':
            '${_startTime!.format(context)} ~ ${_endTime!.format(context)}', // 영업시간 업데이트.
        'photoUrl': _photoUrl,                                     // 사진 URL 업데이트.
        'isOpen': _isOpen,                                         // 영업 상태 업데이트.
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('음식점 정보 수정 완료!')),          // 성공 메시지 표시.
      );

      Future.delayed(Duration(seconds: 3), () {                    // 3초 후에 페이지 이동.
        Navigator.pushNamed(context, '/homeStaff');                // '/homeStaff' 페이지로 이동.
      });
    }
  }

 Future<void> _markAsDeleted() async {                            // 음식점을 삭제 상태로 업데이트하는 메소드.
    setState(() {
      _isLoading = true;                                           // 로딩 상태 설정.
    });

    try {
      final user = FirebaseAuth.instance.currentUser;              // 현재 사용자 정보를 가져옴.
      if (user == null) {                                          // 사용자가 로그인되지 않은 경우.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')), // 오류 메시지 표시.
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(_restaurantId)
          .update({'isDeleted': true});                            // 음식점을 삭제 상태로 업데이트.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('음식점이 삭제되었습니다.')),           // 성공 메시지 표시.
      );

      Navigator.pushReplacementNamed(context, '/homeStaff');       // '/homeStaff' 페이지로 이동.
    } catch (e) {
      print('Error marking restaurant as deleted: $e');            // 오류 발생 시 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('음식점 삭제 중 오류가 발생했습니다. 다시 시도해주세요.')), // 오류 메시지 표시.
      );
    } finally {
      setState(() {
        _isLoading = false;                                        // 로딩 상태 해제.
      });
    }
  }

 bool _checkBusinessHours(TimeOfDay startTime, TimeOfDay endTime) { // 영업 시간이 현재 시간과 겹치는지 확인하는 메소드.
    final now = TimeOfDay.now();                                   // 현재 시간을 가져옴.
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

    if (end.isBefore(start)) {                                     // 종료 시간이 시작 시간보다 빠른 경우.
      return currentTime.isAfter(start) || currentTime.isBefore(end); // 현재 시간이 영업 시간 내에 있는지 확인.
    } else {
      return currentTime.isAfter(start) && currentTime.isBefore(end); // 현재 시간이 영업 시간 내에 있는지 확인.
    }
  }

  bool _isValidKorean(String value) {                              // 입력된 문자열이 유효한 한글인지 확인하는 메소드.
    final koreanRegex = RegExp(r'^[가-힣\s]+$');                    // 한글 및 공백만 허용하는 정규식.
    return koreanRegex.hasMatch(value);                            // 정규식과 일치하는지 확인.
  }

  void _showDeleteConfirmationDialog() {                           // 음식점 삭제 확인 다이얼로그를 표시하는 메소드.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('음식점 삭제'),                                // 다이얼로그 제목.
          content: Text('이 음식점을 삭제하시겠습니까?'),            // 다이얼로그 내용.
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),        // '취소' 버튼을 누르면 다이얼로그 닫기.
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();                       // '삭제' 버튼을 누르면 다이얼로그 닫기.
                _markAsDeleted();                                  // 음식점을 삭제 상태로 설정.
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }
  
 @override
  Widget build(BuildContext context) {                             // 위젯의 UI를 빌드하는 메소드.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '음식점 정보 수정',                                        // 앱 바의 제목.
          style: TextStyle(
            color: Color(0xFF1C1C21),                              // 텍스트 색상.
            fontSize: 18,                                          // 텍스트 크기.
            fontFamily: 'Epilogue',                                // 폰트 설정.
            fontWeight: FontWeight.w700,                           // 텍스트 굵기.
            height: 0.07,                                          // 줄 간격.
            letterSpacing: -0.27,                                  // 글자 간격.
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())             // 로딩 중일 때 로딩 인디케이터 표시.
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),               // 화면의 모든 가장자리에 16px의 패딩 추가.
                child: Form(
                  key: _formKey,                                   // 폼의 키 설정.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 수평으로 늘림.
                    children: <Widget>[
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Text(
                        '음식점 정보',                              // 섹션 제목.
                        style: TextStyle(
                          color: Color(0xFF1C1C21),                // 텍스트 색상.
                          fontSize: 18,                            // 텍스트 크기.
                          fontFamily: 'Epilogue',                  // 폰트 설정.
                          height: 0.07,                            // 줄 간격.
                          letterSpacing: -0.27,                    // 글자 간격.
                          fontWeight: FontWeight.w700,             // 텍스트 굵기.
                        ),
                      ),
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Container(
                          width: 500,                              // 컨테이너의 너비 설정.
                          child: Divider(color: Colors.black, thickness: 2.0)), // 구분선 추가.
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Center(
                        child: Container(
                          width: 358,                              // 컨테이너의 너비 설정.
                          height: 201,                             // 컨테이너의 높이 설정.
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(_photoUrl),    // 음식점 사진을 네트워크에서 로드.
                                fit: BoxFit.fill),                 // 이미지를 컨테이너에 맞게 조정.
                            borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정.
                          ),
                        ),
                      ),
                      SizedBox(height: 50),                        // 위젯 사이에 50px 간격 추가.
                      Text(
                        '음식점 이름',                              // 레이블 텍스트.
                        style: TextStyle(
                          color: Color(0xFF1C1C21),                // 텍스트 색상.
                          fontSize: 18,                            // 텍스트 크기.
                          fontFamily: 'Epilogue',                  // 폰트 설정.
                          fontWeight: FontWeight.w700,             // 텍스트 굵기.
                        ),
                      ),
                      TextFormField(
                        initialValue: _restaurantName,             // 초기 값으로 음식점 이름 설정.
                        decoration: InputDecoration(),             // 기본 입력 필드 스타일 사용.
                        readOnly: true,                            // 음식점 이름은 수정 불가.
                      ),
                      SizedBox(height: 15),                        // 위젯 사이에 15px 간격 추가.
                      Container(
                        width: 200,                                // 컨테이너의 너비 설정.
                        alignment: Alignment.centerLeft,           // 컨테이너의 내용 정렬.
                        child: TextButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),               // 버튼 모서리를 둥글게 설정.
                              )),
                              side: BorderSide(color: Colors.black)), // 버튼 테두리 설정.
                          onPressed: () async {
                            final location = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapPage(previousPage: 'RestaurantEdit'), // 위치 찾기 페이지로 이동.
                              ),
                            );
                            if (location != null) {                // 위치가 선택된 경우.
                              setState(() {
                                _location = location;              // 선택된 위치로 설정.
                              });
                            }
                          },
                          child: Text(
                            '위치 찾기',                            // 버튼 텍스트.
                            style: TextStyle(
                              color: Color(0xFF1C1C21),            // 텍스트 색상.
                              fontSize: 18,                        // 텍스트 크기.
                              fontFamily: 'Epilogue',              // 폰트 설정.
                              fontWeight: FontWeight.w700,         // 텍스트 굵기.
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),                        // 위젯 사이에 15px 간격 추가.
                      Text(
                        '위치',                                    // 레이블 텍스트.
                        style: TextStyle(
                          color: Color(0xFF1C1C21),                // 텍스트 색상.
                          fontSize: 18,                            // 텍스트 크기.
                          fontFamily: 'Epilogue',                  // 폰트 설정.
                          fontWeight: FontWeight.w700,             // 텍스트 굵기.
                        ),
                      ),
                      TextFormField(
                        initialValue: _location,                   // 초기 값으로 위치 설정.
                        decoration: InputDecoration(),             // 기본 입력 필드 스타일 사용.
                        readOnly: true,                            // 위치는 수정 불가.
                      ),
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Text(
                        '등록번호',                                // 레이블 텍스트.
                        style: TextStyle(
                          color: Color(0xFF1C1C21),                // 텍스트 색상.
                          fontSize: 18,                            // 텍스트 크기.
                          fontFamily: 'Epilogue',                  // 폰트 설정.
                          fontWeight: FontWeight.w700,             // 텍스트 굵기.
                        ),
                      ),
                      TextFormField(
                        initialValue: _registrationNumber,         // 초기 값으로 등록번호 설정.
                        decoration: InputDecoration(),             // 기본 입력 필드 스타일 사용.
                        readOnly: true,                            // 등록번호는 수정 불가.
                      ),
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Text(
                        '영업시간 (HH:MM ~ HH:MM)',                // 레이블 텍스트.
                        style: TextStyle(
                          color: Color(0xFF1C1C21),                // 텍스트 색상.
                          fontSize: 18,                            // 텍스트 크기.
                          fontFamily: 'Epilogue',                  // 폰트 설정.
                          fontWeight: FontWeight.w700,             // 텍스트 굵기.
                        ),
                      ),
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 자식 위젯들을 양 끝으로 정렬.
                        children: [
                          ElevatedButton(
                            onPressed: () => _selectTime(context, true), // 시작 시간 선택 버튼.
                            child: Text(_startTime != null
                                ? _startTime!.format(context)
                                : '시작 시간 선택'),
                          ),
                          ElevatedButton(
                            onPressed: () => _selectTime(context, false), // 종료 시간 선택 버튼.
                            child: Text(_endTime != null
                                ? _endTime!.format(context)
                                : '종료 시간 선택'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Text(
                        '설명',                                    // 레이블 텍스트.
                        style: TextStyle(
                          color: Color(0xFF1C1C21),                // 텍스트 색상.
                          fontSize: 18,                            // 텍스트 크기.
                          fontFamily: 'Epilogue',                  // 폰트 설정.
                          fontWeight: FontWeight.w700,             // 텍스트 굵기.
                        ),
                      ),
                      TextFormField(
                        initialValue: _description,                // 초기 값으로 음식점 설명 설정.
                        maxLines: 3,                               // 최대 3줄 입력 가능.
                        decoration: InputDecoration(),             // 기본 입력 필드 스타일 사용.
                        validator: (value) {
                          if (value == null || value.isEmpty) {    // 입력 값이 비어있는 경우.
                            return '음식점에 대한 설명을 입력해주세요'; // 오류 메시지 반환.
                          }
                          if (value.length < 5) {                  // 설명이 5글자 미만인 경우.
                            return '설명은 최소 5글자 이상 입력해야 합니다'; // 오류 메시지 반환.
                          }
                          if (value.length > 100) {                // 설명이 100글자를 초과한 경우.
                            return '최대 100글자까지 입력 가능합니다'; // 오류 메시지 반환.
                          }
                          if (!_isValidKorean(value)) {            // 설명이 유효한 한글인지 확인.
                            return '설명은 한국어로만 입력해주세요'; // 오류 메시지 반환.
                          }
                          return null;                             // 모든 조건을 통과하면 오류 없음.
                        },
                        onSaved: (value) {
                          _description = value!;                   // 설명을 상태에 저장.
                        },
                      ),
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      Align(
                        alignment: Alignment.centerLeft,           // 텍스트 버튼을 왼쪽으로 정렬.
                        child: TextButton(
                          onPressed: _showDeleteConfirmationDialog, // 음식점 삭제 버튼 눌렀을 때.
                          child: Text(
                            '음식점 삭제',                          // 텍스트 버튼 텍스트.
                            style: TextStyle(
                              color: Color(0xFF1C1C21),            // 텍스트 색상.
                              fontSize: 18,                        // 텍스트 크기.
                              fontFamily: 'Epilogue',              // 폰트 설정.
                              fontWeight: FontWeight.w700,         // 텍스트 굵기.
                              height: 0.07,                        // 줄 간격.
                              letterSpacing: -0.27,                // 글자 간격.
                              decoration: TextDecoration.underline, // 밑줄 추가.
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),                        // 위젯 사이에 20px 간격 추가.
                      ElevatedButton(
                        onPressed: _submitForm,                    // 수정 버튼 눌렀을 때 폼 제출.
                        child: Text('수정'),                       // 버튼 텍스트.
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
