import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class editregRestaurant extends StatefulWidget {
  const editregRestaurant({super.key});

  @override
  _EditRegRestaurantState createState() => _EditRegRestaurantState();
}

class _EditRegRestaurantState extends State<editregRestaurant> {
  final _formKey = GlobalKey<FormState>();
  String _restaurantId = '';
  String _restaurantName = '';
  String _location = '';
  String _description = '';
  String _registrationNumber = '';
  String _businessHours = '';
  String _photoUrl = '';
  bool _isOpen = false;
  bool _isLoading = true; // 로딩 상태를 나타내는 변수

  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('restaurants');

  @override
  void initState() {
    super.initState();
    _loadRestaurantData();
  }

  Future<void> _loadRestaurantData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // 사용자 로그인 상태가 아니면 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')),
      );
      return;
    }

    try {
      // Firestore에서 resNum 가져오기
      final firestoreDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final resNum = firestoreDoc.data()?['resNum'] as String?;

      if (resNum == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자의 resNum을 찾을 수 없습니다.')),
        );
        return;
      }

      // Realtime Database에서 registrationNumber와 일치하는 항목 찾기
      final event = await _database
          .orderByChild('registrationNumber')
          .equalTo(resNum)
          .once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final restaurantKey = (snapshot.value as Map).keys.first as String;
        final data = (snapshot.value as Map)[restaurantKey] as Map;
        setState(() {
          _restaurantId = restaurantKey;
          _restaurantName = data['restaurantName'] ?? '';
          _location = data['location'] ?? '';
          _description = data['description'] ?? '';
          _registrationNumber = data['registrationNumber'] ?? '';
          _businessHours = data['businessHours'] ?? '';
          _photoUrl = data['photoUrl'] ?? '';
          _isOpen = data['isOpen'] ?? false;
          _isLoading = false; // 데이터 로드 완료
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일치하는 음식점 정보를 찾을 수 없습니다.')),
        );
        setState(() {
          _isLoading = false; // 데이터가 없는 경우에도 로드 완료로 설정
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다.')),
      );
      setState(() {
        _isLoading = false; // 오류 발생 시 로드 완료로 설정
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 영업시간을 파싱하여 영업 활성화 여부 결정
      _isOpen = _checkBusinessHours(_businessHours);

      // 데이터를 Firebase Realtime Database에 저장
      await _database.child(_restaurantId).update({
        'description': _description,
        'businessHours': _businessHours,
        'photoUrl': _photoUrl,
        'isOpen': _isOpen,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('음식점 정보 수정 완료!')),
      );

      // 3초 후에 음식점 정보 수정 페이지로 이동
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushNamed(context, '/homeStaff');
      });
    }
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')),
        );
        return;
      }

      // Firestore에서 resNum과 일치하는 문서 삭제
      final firestoreDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final resNum = firestoreDoc.data()?['resNum'] as String?;

      if (resNum != null) {
        // Firestore에서 해당 문서 삭제
        await FirebaseFirestore.instance
            .collection('restaurants')
            .where('resNum', isEqualTo: resNum)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      }

      // Realtime Database에서 등록번호로 음식점 데이터 삭제
      await _database.child(_restaurantId).remove();

      // Firebase Authentication에서 사용자 계정 삭제
      await user.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원탈퇴가 완료되었습니다.')),
      );

      // 회원가입 페이지로 이동
      Navigator.pushReplacementNamed(context, '/signUp');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원탈퇴 중 오류가 발생했습니다. 다시 시도해주세요.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _checkBusinessHours(String businessHours) {
    final format = DateFormat.Hm();
    final now = DateTime.now();

    try {
      final hours = businessHours.split(' ~ ');
      final start = format.parse(hours[0]);
      final end = format.parse(hours[1]);

      final currentTime = format.parse('${now.hour}:${now.minute}');

      if (end.isBefore(start)) {
        return currentTime.isAfter(start) || currentTime.isBefore(end);
      } else {
        return currentTime.isAfter(start) && currentTime.isBefore(end);
      }
    } catch (e) {
      // 잘못된 형식의 경우 영업 종료로 간주
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '음식점 정보 수정',
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 인디케이터 표시
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        '음식점 정보',
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
                          child: Divider(color: Colors.black, thickness: 2.0)),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: 358,
                          height: 201,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/malatang.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: _restaurantName,
                        decoration: InputDecoration(
                          labelText: '음식점 이름',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true, // 음식점 이름은 수정 불가
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _location,
                        decoration: InputDecoration(
                          labelText: '위치',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true, // 위치는 수정 불가
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _registrationNumber,
                        decoration: InputDecoration(
                          labelText: '등록번호',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true, // 등록번호는 수정 불가
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _businessHours,
                        decoration: InputDecoration(
                          labelText: '영업시간 (HH:MM ~ HH:MM)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '영업시간을 입력해주세요';
                          }
                          if (!RegExp(
                                  r'^[0-2][0-9]:[0-5][0-9] ~ [0-2][0-9]:[0-5][0-9]$')
                              .hasMatch(value)) {
                            return '영업시간은 HH:MM ~ HH:MM 형식으로 입력해주세요';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _businessHours = value!;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _description,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: '설명',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '음식점에 대한 설명을 입력해주세요';
                          }
                          if (value.length < 5) {
                            return '설명은 최소 5글자 이상 입력해야 합니다';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _description = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 버튼을 부모의 중앙에 배치
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/MenuRegList');
                            },
                            child: Text(' + 메뉴 수정'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              minimumSize:
                                  MaterialStateProperty.all(Size(50, 50)),
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
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '음식점 삭제',
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
                        onPressed: _submitForm,
                        child: Text('등록하기'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
