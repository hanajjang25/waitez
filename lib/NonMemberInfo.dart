import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class nonMemberInfo extends StatefulWidget {
  const nonMemberInfo({super.key});

  @override
  _nonMemberInfoState createState() => _nonMemberInfoState();
}

class _nonMemberInfoState extends State<nonMemberInfo> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveNonMemberInfo() async {
    try {
      final nonMemberData = {
        'nickname': _nicknameController.text,
        'phoneNum': _phoneController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'isSaved': true, // 구별할 수 있는 변수 추가
        'log': [
          {
            'event': 'Next button pressed',
            'timestamp': FieldValue.serverTimestamp(),
            'nickname': _nicknameController.text,
            'phoneNum': _phoneController.text,
          }
        ]
      };

      await FirebaseFirestore.instance
          .collection('non_members')
          .add(nonMemberData);

      print('Non-member info saved successfully');
    } catch (e) {
      print('Error saving non-member info: $e');
    }
  }

  String _formatPhoneNumber(String value) {
    value =
        value.replaceAll(RegExp(r'\D'), ''); // Remove all non-digit characters
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
              decoration: InputDecoration(
                hintText: '010-0000-0000',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d+|\-')),
                LengthLimitingTextInputFormatter(13),
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
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveNonMemberInfo();
                  Navigator.pushNamed(context, '/nonMemberHome');
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
    );
  }
}
