import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UserBottom.dart';

class NonMemberReservation extends StatefulWidget {
  @override
  _NonMemberReservationState createState() => _NonMemberReservationState();
}

class _NonMemberReservationState extends State<NonMemberReservation> {
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

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    readOnly:
                        false, // The alternative phone number can be editable
                  ),
                  SizedBox(height: 100),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // 여기에 버튼 클릭 시 동작할 코드를 추가하세요.
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
                          // 여기에 버튼 클릭 시 동작할 코드를 추가하세요.
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
                      // 여기에 버튼 클릭 시 동작할 코드를 추가하세요.
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

class menuButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_page),
          label: 'Contact',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {},
    );
  }
}
