import 'package:flutter/material.dart';

class RestaurantInfo extends StatefulWidget {
  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  bool isFavorite = false;

  final List<Map<String, String>> menuItems = [
    {'name': '청양김밥', 'price': '3,000원'},
    {'name': '참치김밥', 'price': '3,000원'},
  ];

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void navigateToDetails(Map<String, String> menuItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetailsPage(menuItem: menuItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('김밥헤븐 단계점'),
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.black, // 테두리 색
                ),
                Icon(
                  Icons.star,
                  color:
                      isFavorite ? Colors.yellow : Colors.transparent, // 채워진 색
                ),
              ],
            ),
            onPressed: toggleFavorite,
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 358,
                height: 201,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/malatang.png"),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              '김밥헤븐 단계점',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                children: [
                  Text(
                    '주소',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '강원특별자치도 단계동 100-00 1층',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                children: [
                  Text(
                    '영업시간',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '10:00 ~ 22:00',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'MENU',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menuItems[index];
                  return ListTile(
                    title: Text(menuItem['name']!),
                    subtitle: Text(menuItem['price']!),
                    onTap: () => navigateToDetails(menuItem),
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reservation');
                  },
                  child: Text('예약하기'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF1A94FF)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class MenuDetailsPage extends StatelessWidget {
  final Map<String, String> menuItem;

  MenuDetailsPage({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menuItem['name']!,
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            height: 0.07,
            letterSpacing: -0.27,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'MENU',
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
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              menuItem['name']!,
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 24,
                fontFamily: 'Epilogue',
                height: 0.07,
                letterSpacing: -0.27,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 50),
            Text(
              '가격: ${menuItem['price']}',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 20,
                fontFamily: 'Epilogue',
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 50),
            Text(
              '상세 설명을 여기에 추가하세요.',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 0.07,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('장바구니에 추가되었습니다.')),
                  );
                },
                child: Text('장바구니에 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
