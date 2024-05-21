import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'StaffBottom.dart';

class WaitlistEntry {
  final String name;
  final int people;
  final String phoneNum;
  final String timeStamp;

  WaitlistEntry(
      {required this.name,
      required this.people,
      required this.phoneNum,
      required this.timeStamp});
}

class homeStaff extends StatelessWidget {
  final List<WaitlistEntry> waitlist = [
    WaitlistEntry(
        name: "홍길동", people: 4, phoneNum: "010-1234-5678", timeStamp: "15:30"),
    WaitlistEntry(
        name: "김서방", people: 2, phoneNum: "010-9876-5432", timeStamp: "15:45"),
  ];

  Widget buildWaitlist(List<WaitlistEntry> waitlist) {
    return ListView.builder(
      itemCount: waitlist.length,
      itemBuilder: (context, index) {
        final waitP = waitlist[index];
        return ListTile(
          title: Text(waitP.name),
          subtitle: Text('인원수: ${waitP.people} \n전화번호 : ${waitP.phoneNum}'),
          trailing: Text(waitP.timeStamp),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          leading:
              IconButton(onPressed: () {}, icon: Icon(Icons.menu)), // 왼쪽 메뉴버튼
          title: Text(
            'waitez',
            style: TextStyle(
              color: Color(0xFF1C1C21),
              fontSize: 18,
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w700,
              height: 0.07,
              letterSpacing: -0.27,
            ),
          ), // 타이틀
          centerTitle: true, // 타이틀 텍스트를 가운데로 정렬 시킴
          actions: [
            // 우측의 액션 버튼들
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: buildWaitlist(waitlist),
        ),
      ),
      bottomNavigationBar: staffButtom(),
    );
  }
}
