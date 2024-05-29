import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'UserBottom.dart';
import 'UserWaitingDetail.dart';

class waitingNumber extends StatefulWidget {
  @override
  _WaitingNumberState createState() => _WaitingNumberState();
}

class _WaitingNumberState extends State<waitingNumber> {
  int storeQueueNumber = 13;
  int takeoutQueueNumber1 = 2;
  int takeoutQueueNumber2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.person),
            Text('대기순번', style: TextStyle(color: Colors.black)),
            Icon(Icons.menu),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '매장',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(color: Colors.black, thickness: 2.0),
            _buildQueueCard(
              context,
              '매장',
              storeQueueNumber,
              '김밥헤븐 단계점',
              '강원도 원주시 단계동 100-0 1층',
              [
                {'name': '청양김밥', 'price': 3000, 'quantity': 1},
                {'name': '청양김밥', 'price': 3000, 'quantity': 1},
              ],
            ), // 대기순번 목록한개 card
            SizedBox(height: 20),
            Text(
              '포장',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(color: Colors.black, thickness: 2.0),
            _buildQueueCard(
              context,
              '포장',
              takeoutQueueNumber1,
              '까눌레네 단계점',
              '강원도 원주시 단계동 200-0 2층',
              [
                {'name': '까눌레', 'price': 2000, 'quantity': 3},
              ],
            ),
            SizedBox(height: 20),
            _buildQueueCard(
              context,
              '포장',
              takeoutQueueNumber2,
              '케이키 단계점',
              '강원도 원주시 단계동 300-0 3층',
              [
                {'name': '케이크', 'price': 5000, 'quantity': 2},
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }

  Widget _buildQueueCard(
    BuildContext context,
    String type,
    int number,
    String description,
    String address,
    List<Map<String, dynamic>> orderItems,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => waitingDetail(
              restaurantName: description,
              restaurantAddress: address,
              queueNumber: number,
              orderItems: orderItems,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: Container(
          height: 80, // 카드의 높이를 설정
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            title: Text(
              description,
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
