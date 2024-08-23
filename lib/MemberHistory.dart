import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class History extends StatelessWidget {
  final String restaurantName; // 식당 이름
  final String date; // 방문 날짜
  final String imageAsset; // 이미지 경로
  final List<Map<String, dynamic>> menuItems; // 주문한 메뉴 리스트
  final String type; // 방문 형태 (매장/포장)
  final String address; // 식당 주소
  final String operatingHours; // 영업시간

  History({
    required this.restaurantName,
    required this.date,
    required this.imageAsset,
    required this.menuItems,
    required this.type,
    required this.address,
    required this.operatingHours,
  });

  @override
  Widget build(BuildContext context) {
    // 총 금액 계산
    int totalPrice = menuItems.fold(0, (sum, item) {
      int price = item['price'] is int
          ? item['price']
          : int.parse(item['price'].toString()); // 가격 가져오기
      int quantity = item['quantity'] is int
          ? item['quantity']
          : int.parse(item['quantity'].toString()); // 수량 가져오기
      return sum + (price * quantity); // 가격 * 수량을 총 금액에 더하기
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('이력조회'), // 앱 바 제목
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 식당 이미지
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // 이미지 모서리 둥글게 처리
                child: Image.network(
                  imageAsset,
                  fit: BoxFit.cover, // 이미지가 컨테이너에 맞게 조정
                ),
              ),
            ),
            SizedBox(height: 30),
            // 식당 이름
            Text(
              restaurantName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // 방문 형태 (매장/포장)
            Text(
              '매장/포장 : $type',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 1.2,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 20),
            // 식당 주소
            Text(
              '주소 : $address',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 1.2,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 20),
            // 영업시간
            Text(
              '영업시간 : $operatingHours',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 1.2,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 20),
            // 방문 날짜
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // 주문 내역 제목
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '주문내역:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            // 주문한 메뉴 리스트
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(menuItems[index]['name']), // 메뉴 이름
                    subtitle: Text('₩${menuItems[index]['price']}'), // 메뉴 가격
                    trailing: Text('수량: ${menuItems[index]['quantity']}'), // 메뉴 수량
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // 총 금액 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('총 금액', style: TextStyle(fontSize: 18)),
                Text('₩ $totalPrice', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
