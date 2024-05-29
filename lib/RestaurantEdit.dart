import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      // Firestore에서 닉네임 가져오기
      final firestoreDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final nickname = firestoreDoc.data()?['nickname'] as String?;

      if (nickname == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자의 닉네임을 찾을 수 없습니다.')),
        );
        return;
      }

      print('User nickname: $nickname'); // Debugging

      // Firestore에서 닉네임과 일치하는 항목 찾기
      final querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('nickname', isEqualTo: nickname)
          .where('isDeleted', isEqualTo: false)
          .get();

      print('Query result count: ${querySnapshot.docs.length}'); // Debugging

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        print('Restaurant data: $data'); // Debugging
        setState(() {
          _restaurantId = doc.id;
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
      print('Error loading restaurant data: $e'); // 디버깅을 위한 로그 추가
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

      // 데이터를 Firestore에 저장
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(_restaurantId)
          .update({
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

  Future<void> _markAsDeleted() async {
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

      // Firestore에서 해당 음식점 문서를 삭제 상태로 업데이트
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(_restaurantId)
          .update({'isDeleted': true});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('음식점이 삭제되었습니다.')),
      );

      // homeStaff 페이지로 이동
      Navigator.pushReplacementNamed(context, '/homeStaff');
    } catch (e) {
      print('Error marking restaurant as deleted: $e'); // 디버깅을 위한 로그 추가
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('음식점 삭제 중 오류가 발생했습니다. 다시 시도해주세요.')),
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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('음식점 삭제'),
          content: Text('이 음식점을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _markAsDeleted();
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
                              Navigator.pushNamed(context, '/menuEdit');
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
                          onPressed: _showDeleteConfirmationDialog,
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
