import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'MenuRegOne.dart';

class regRestaurant extends StatefulWidget {
  const regRestaurant({super.key});

  @override
  _RegRestaurantState createState() => _RegRestaurantState();
}

class _RegRestaurantState extends State<regRestaurant> {
  final _formKey = GlobalKey<FormState>();
  String _restaurantName = '';
  String _location = '';
  String _description = '';
  String _registrationNumber = '';
  String _businessHours = '';
  String _photoUrl = '';
  bool _isOpen = false;
  File? _imageFile;

  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('restaurants');

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(
        'restaurant_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await imageRef.putFile(image);
    return await imageRef.getDownloadURL();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_imageFile != null) {
        _photoUrl = await _uploadImage(_imageFile!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 업로드해주세요.')),
        );
        return;
      }

      // 중복된 음식점 이름이 있는지 확인
      final DataSnapshot snapshot = await _databaseRef
          .orderByChild('restaurantName')
          .equalTo(_restaurantName)
          .get();
      if (snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 등록된 음식점 이름입니다.')),
        );
        return;
      }

      // 영업시간을 파싱하여 영업 활성화 여부 결정
      _isOpen = _checkBusinessHours(_businessHours);

      // 데이터를 Realtime Database에 저장
      await _databaseRef.push().set({
        'restaurantName': _restaurantName,
        'location': _location,
        'description': _description,
        'registrationNumber': _registrationNumber,
        'businessHours': _businessHours,
        'photoUrl': _photoUrl,
        'isOpen': _isOpen,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('음식점 등록 완료!')),
      );

      // 3초 후에 직원 home 페이지로 이동
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushNamed(context, '/homeStaff');
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
          '음식점 등록',
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.black, thickness: 2.0),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 358,
                      height: 201.38,
                      decoration: BoxDecoration(
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: AssetImage("assets/images/malatang.png"),
                                fit: BoxFit.fill,
                              ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _imageFile == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  '상호명',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '음식점 이름을 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _restaurantName = value!;
                  },
                ),
                SizedBox(height: 50),
                Text(
                  '위치',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '위치를 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _location = value!;
                  },
                ),
                SizedBox(height: 50),
                Text(
                  '등록번호',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '등록번호를 입력해주세요';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return '등록번호는 숫자만 입력 가능합니다';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _registrationNumber = value!;
                  },
                ),
                SizedBox(height: 50),
                Text(
                  '영업시간 (HH:MM ~ HH:MM)',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),
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
                SizedBox(height: 50),
                Text(
                  '설명',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(),
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
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/MenuRegList');
                      },
                      child: Text(' + 메뉴 등록'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
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
                SizedBox(height: 40),
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
