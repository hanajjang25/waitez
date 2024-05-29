import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'UserBottom.dart';
import 'UserReservationMenu.dart';

class Reservation extends StatefulWidget {
  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  int numberOfPeople = 0;
  bool isPeopleSelectorEnabled = false;
  bool isFirstClick = true;

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _saveReservation(BuildContext context, String type) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final nickname = userDoc.data()?['nickname'] ?? '';
        final reservationData = {
          'nickname': nickname,
          'type': type == '매장' ? 1 : 2,
          'timestamp': Timestamp.now(),
        };
        if (type == '매장') {
          reservationData['numberOfPeople'] = numberOfPeople;
        }
        await FirebaseFirestore.instance
            .collection('reservations')
            .add(reservationData);
        Navigator.pushNamed(context, '/reservationMenu',
            arguments: {'type': type});
      } else {
        print('User document does not exist.');
      }
    } else {
      print('User is not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InfoInputScreen(numberOfPeople: numberOfPeople),
                      ),
                    );
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

class InfoInputScreen extends StatefulWidget {
  final int numberOfPeople;

  InfoInputScreen({required this.numberOfPeople});

  @override
  _InfoInputScreenState createState() => _InfoInputScreenState();
}

class _InfoInputScreenState extends State<InfoInputScreen> {
  late int numberOfPeople;
  final TextEditingController _nicknameController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');
  final TextEditingController _altPhoneController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    numberOfPeople = widget.numberOfPeople;
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
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

  Future<void> _saveReservationInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Firestore 트랜잭션 사용하여 업데이트
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: _nicknameController.text)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          // 디버깅: 쿼리 결과 로그 출력
          print('Query Result Count: ${reservationQuery.docs.length}');
          reservationQuery.docs.forEach((doc) {
            print('Document ID: ${doc.id}, Data: ${doc.data()}');
          });

          if (reservationQuery.docs.isNotEmpty) {
            final reservationDoc = reservationQuery.docs.first.reference;
            transaction.update(reservationDoc, {
              'numberOfPeople': numberOfPeople,
              'altPhoneNum': _altPhoneController.text,
            });

            // Retrieve reservationId
            final reservationId = reservationDoc.id;

            // Update the reservation info
            await FirebaseFirestore.instance.collection('cart').add({
              'reservationId': reservationId,
              'nickname': _nicknameController.text,
              'timestamp': Timestamp.now(),
              // Add any other fields required in the cart document
            });

            print('Reservation updated and cart info saved successfully');
          } else {
            print('No recent reservation found for this user.');
          }
        });
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error saving reservation info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보입력'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              readOnly: true, // Make the TextFormField read-only
            ),
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
              readOnly: true, // Make the TextFormField read-only
            ),
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
              readOnly: false, // The alternative phone number can be editable
            ),
            SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveReservationInfo();
                  Navigator.pushNamed(
                    context,
                    '/reservationMenu',
                    arguments: {
                      'restaurantId': 'YourRestaurantIdHere',
                    },
                  );
                },
                child: Text('다음'),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }
}