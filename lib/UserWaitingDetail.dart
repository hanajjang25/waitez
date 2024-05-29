import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'UserBottom.dart';
import 'UserCart.dart'; // Import the Cart page

class waitingDetail extends StatefulWidget {
  final String restaurantName;
  final String restaurantAddress;
  final int queueNumber;
  final List<Map<String, dynamic>> orderItems;

  waitingDetail({
    required this.restaurantName,
    required this.restaurantAddress,
    required this.queueNumber,
    required this.orderItems,
  });

  @override
  _waitingDetailState createState() => _waitingDetailState();
}

class _waitingDetailState extends State<waitingDetail> {
  bool isRestaurantSelected = true;
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('예약 취소'),
          content: Text('정말 예약을 취소하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/waitingNumber');
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _editCart() async {
    final updatedOrderItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cart(),
      ),
    );

    if (updatedOrderItems != null) {
      setState(() {
        widget.orderItems.clear();
        widget.orderItems.addAll(updatedOrderItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.orderItems.fold<int>(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Center(
              child: Container(
                width: 200,
                height: 150,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.queueNumber.toString(),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.queue, color: Colors.blue, size: 15),
                  label: Text(
                    '예약정보 수정',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InfoInputScreen(numberOfPeople: 2),
                      ),
                    );
                  },
                ),
                SizedBox(width: 5),
                ElevatedButton.icon(
                  icon: Icon(Icons.list_alt, color: Colors.blue, size: 15),
                  label: Text(
                    '장바구니 수정',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cart(), // 대기순번 페이지에서 온 경우
                      ),
                    );
                  },
                ),
                SizedBox(width: 5),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.list_alt,
                    color: Colors.blue,
                    size: 15,
                  ),
                  label: Text('예약취소',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      )),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: showCancelDialog,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isRestaurantSelected = true;
                    });
                  },
                  child: Text(
                    '음식점',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: isRestaurantSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isRestaurantSelected = false;
                    });
                  },
                  child: Text(
                    '메뉴',
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: isRestaurantSelected
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.black, thickness: 2.0),
            SizedBox(height: 20),
            if (isRestaurantSelected)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/malatang.png"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.restaurantName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                          color: isFavorite
                                              ? Colors.yellow
                                              : Colors.transparent, // 채워진 색
                                        ),
                                      ],
                                    ),
                                    onPressed: toggleFavorite,
                                  ),
                                ],
                              ),
                              Container(
                                height: 30,
                                width: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text("주소",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                widget.restaurantAddress,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Container(
                          height: 30,
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text("위치",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: 358,
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/map.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isRestaurantSelected)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주문내역',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.orderItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(widget.orderItems[index]['name']),
                            subtitle:
                                Text('${widget.orderItems[index]['price']}원'),
                            trailing: Text(
                                'x${widget.orderItems[index]['quantity']}'),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '총 금액',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$totalPrice원',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
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

  @override
  void initState() {
    super.initState();
    numberOfPeople = widget.numberOfPeople;
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
              '이름',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
              ),
            ),
            TextFormField(
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
              decoration: InputDecoration(),
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
              decoration: InputDecoration(),
            ),
            SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 이전 페이지로 돌아가기
                },
                child: Text('수정'),
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
