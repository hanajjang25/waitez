import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'UserBottom.dart';

class Reservation extends StatefulWidget {
  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  int numberOfPeople = 0;
  bool isPeopleSelectorEnabled = false;
  bool isFirstClick = true;
  bool isInfoInputScreen = false;
  String reservationType = '';
  final TextEditingController _nicknameController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');
  final TextEditingController _altPhoneController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _fetchUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.isAnonymous) {
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('userId', isEqualTo: user.uid)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (reservationQuery.docs.isNotEmpty) {
            final data = reservationQuery.docs.first.data();
            setState(() {
              _nicknameController.text = data['nickname'] ?? '';
              _phoneController.text = data['phone'] ?? '';
            });
          } else {
            print('No reservation found for anonymous user.');
          }
        } else {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (userDoc.exists) {
            final data = userDoc.data()!;
            setState(() {
              _nicknameController.text = data['nickname'] ?? '';
              _phoneController.text = data['phoneNum'] ?? '';
            });
          } else {
            print('User document does not exist.');
          }
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  String _formatPhoneNumber(String value) {
    value = value.replaceAll('-', ''); // Remove existing dashes
    if (value.length > 3) {
      value = value.substring(0, 3) + '-' + value.substring(3);
    }
    if (value.length > 8) {
      value = value.substring(0, 8) + '-' + value.substring(8);
    }
    return value;
  }

  Future<bool> _isNicknameExists(String nickname) async {
    final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .get();
    final QuerySnapshot nonMemberSnapshot = await FirebaseFirestore.instance
        .collection('non_members')
        .where('nickname', isEqualTo: nickname)
        .get();
    return userSnapshot.docs.isNotEmpty || nonMemberSnapshot.docs.isNotEmpty;
  }

  Future<bool> _isPhoneExists(String phone) async {
    final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNum', isEqualTo: phone)
        .get();
    final QuerySnapshot nonMemberSnapshot = await FirebaseFirestore.instance
        .collection('non_members')
        .where('phoneNum', isEqualTo: phone)
        .get();
    return userSnapshot.docs.isNotEmpty || nonMemberSnapshot.docs.isNotEmpty;
  }

  Future<void> _saveReservation(BuildContext context, String type) async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> reservationData = {
      'type': type == '매장' ? 1 : 2,
      'timestamp': Timestamp.now(),
      'userId': user?.uid ?? '',
    };

    if (user != null) {
      if (user.isAnonymous) {
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (reservationQuery.docs.isNotEmpty) {
          final data = reservationQuery.docs.first.data();
          reservationData['nickname'] = data['nickname'] ?? '';
          reservationData['phone'] = data['phone'] ?? '';
        } else {
          reservationData['nickname'] = _nicknameController.text;
          reservationData['phone'] = _phoneController.text;
        }
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          reservationData['nickname'] = userDoc.data()?['nickname'] ?? '';
          reservationData['phone'] = userDoc.data()?['phoneNum'] ?? '';
        }
      }
    } else {
      showSnackBar(context, '로그인이 필요합니다.');
      return;
    }

    if (type == '매장') {
      reservationData['numberOfPeople'] = numberOfPeople;
    }

    await FirebaseFirestore.instance
        .collection('reservations')
        .add(reservationData);

    setState(() {
      reservationType = type;
      isInfoInputScreen = true;
    });
  }

  Future<void> _saveReservationInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: _nicknameController.text)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (reservationQuery.docs.isNotEmpty) {
            final reservationDoc = reservationQuery.docs.first.reference;
            transaction.update(reservationDoc, {
              'numberOfPeople': numberOfPeople,
              'altPhoneNum': _altPhoneController.text,
            });

            final reservationId = reservationDoc.id;

            await FirebaseFirestore.instance.collection('cart').add({
              'reservationId': reservationId,
              'nickname': _nicknameController.text,
              'timestamp': Timestamp.now(),
            });

            print('Reservation updated and cart info saved successfully');
          } else {
            print('No recent reservation found for this user.');
          }
        });

        Navigator.pushNamed(
          context,
          '/reservationMenu',
          arguments: {'restaurantId': 'YourRestaurantIdHere'},
        );
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error saving reservation info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isInfoInputScreen
        ? Scaffold(
            appBar: AppBar(
              title: Text('정보입력'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    isInfoInputScreen = false;
                  });
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_nicknameController.text.isNotEmpty) ...[
                    SizedBox(height: 50),
                    Text(
                      '닉네임',
                      style: TextStyle(
                        color: Color(0xFF1C1C21),
                        fontSize: 18,
                        fontFamily: 'Epilogue',
                      ),
                    ),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(),
                      readOnly: true,
                    ),
                  ],
                  if (_phoneController.text.isNotEmpty) ...[
                    SizedBox(height: 30),
                    Text(
                      '전화번호',
                      style: TextStyle(
                        color: Color(0xFF1C1C21),
                        fontSize: 18,
                        fontFamily: 'Epilogue',
                      ),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(),
                      readOnly: true,
                    ),
                  ],
                  if (reservationType == '매장') ...[
                    SizedBox(height: 30),
                    Text(
                      '인원수',
                      style: TextStyle(
                        color: Color(0xFF1C1C21),
                        fontSize: 18,
                        fontFamily: 'Epilogue',
                      ),
                    ),
                    Text(
                      '$numberOfPeople 명',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                  SizedBox(height: 30),
                  Text(
                    '보조전화번호',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                    ),
                  ),
                  TextFormField(
                    controller: _altPhoneController,
                    decoration: InputDecoration(
                      hintText: '010-0000-0000',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          String newText = _formatPhoneNumber(newValue.text);
                          return TextEditingValue(
                            text: newText,
                            selection:
                                TextSelection.collapsed(offset: newText.length),
                          );
                        },
                      ),
                    ],
                    keyboardType: TextInputType.number,
                    readOnly: false,
                  ),
                  SizedBox(height: 100),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _saveReservationInfo();
                      },
                      child: Text('다음'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlueAccent),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        minimumSize: MaterialStateProperty.all(Size(200, 50)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 10)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: menuButtom(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                '매장/포장 선택',
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (isFirstClick) {
                        setState(() {
                          isPeopleSelectorEnabled = true;
                          isFirstClick = false;
                        });
                        showSnackBar(context, '인원수를 선택하세요');
                      } else {
                        if (numberOfPeople > 0) {
                          _saveReservation(context, '매장');
                        } else {
                          showSnackBar(context, '인원수를 선택하세요');
                        }
                      }
                    },
                    child: Text('매장'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlueAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      minimumSize: MaterialStateProperty.all(Size(200, 50)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 10)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('인원수'),
                      SizedBox(width: 50),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: isPeopleSelectorEnabled
                                ? () {
                                    setState(() {
                                      if (numberOfPeople > 0) {
                                        numberOfPeople--;
                                      }
                                    });
                                  }
                                : null,
                          ),
                          Text('$numberOfPeople'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: isPeopleSelectorEnabled
                                ? () {
                                    setState(() {
                                      numberOfPeople++;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _saveReservation(context, '포장');
                    },
                    child: Text('포장'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlueAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      minimumSize: MaterialStateProperty.all(Size(200, 50)),
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
            bottomNavigationBar: menuButtom(),
          );
  }
}
