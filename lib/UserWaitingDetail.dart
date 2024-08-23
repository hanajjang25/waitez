import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'UserBottom.dart';
import 'UserCart.dart'; // Import the Cart page
import 'notification.dart';

class waitingDetail extends StatefulWidget {
  final String restaurantName;  // 음식점 이름
  final int queueNumber;  // 대기 번호
  final String reservationId;  // 예약 ID

  waitingDetail({
    required this.restaurantName,  // 음식점 이름 초기화
    required this.queueNumber,  // 대기 번호 초기화
    required this.reservationId,  // 예약 ID 초기화
  });

  @override
  _waitingDetailState createState() => _waitingDetailState();
}

class _waitingDetailState extends State<waitingDetail> {
  bool isRestaurantSelected = true;  // '음식점' 탭이 선택되었는지 여부
  bool isFavorite = false;  // 즐겨찾기 여부
  String? restaurantAddress;  // 음식점 주소
  String? restaurantPhotoUrl;  // 음식점 사진 URL
  List<Map<String, dynamic>> orderItems = [];  // 주문한 메뉴 아이템 목록
  int totalAmount = 0;  // 주문한 총 금액
  LatLng? restaurantLocation;  // 음식점 위치 (위도, 경도)
  int isTakeout = 0;  // 포장 여부 (0: 매장, 1: 포장)
  int averageWaitTime = 0;  // 평균 대기 시간

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),  // 초기 맵 위치 (샌프란시스코)
    zoom: 14.0,  // 줌 레벨
  );

  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetails();  // 음식점 상세 정보 불러오기
    _fetchOrderDetails();  // 주문 정보 불러오기
    _fetchReservationType();  // 예약 타입 불러오기
  }
  
  Future<void> _fetchRestaurantDetails() async {
    try {
      // Firestore에서 음식점 정보 불러오기
      var restaurantSnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('restaurantName', isEqualTo: widget.restaurantName)
          .limit(1)
          .get();

      if (restaurantSnapshot.docs.isNotEmpty) {
        var restaurantData = restaurantSnapshot.docs.first.data();
        setState(() {
          restaurantAddress = restaurantData['location'];  // 음식점 주소 설정
          restaurantPhotoUrl = restaurantData['photoUrl'];  // 음식점 사진 URL 설정
          averageWaitTime = restaurantData['averageWaitTime'];  // 평균 대기 시간 설정
        });

        // 주소를 위도, 경도로 변환하여 지도에 표시
        List<Location> locations = await locationFromAddress(restaurantAddress!);
        if (locations.isNotEmpty) {
          setState(() {
            restaurantLocation = LatLng(locations.first.latitude, locations.first.longitude);
          });
        }
      } else {
        setState(() {
          restaurantAddress = '주소를 찾을 수 없습니다.';  // 주소를 찾을 수 없을 경우 메시지 설정
        });
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      setState(() {
        restaurantAddress = '주소를 찾을 수 없습니다.';  // 오류 발생 시 메시지 설정
      });
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      // Firestore에서 주문 정보 불러오기
      var orderSnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(widget.reservationId)
          .collection('cart')
          .get();

      if (orderSnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> items = [];
        int total = 0;

        for (var doc in orderSnapshot.docs) {
          var item = doc.data();
          var menuItem = item['menuItem'];
          int price = 0;
          int quantity = 0;

          if (menuItem != null) {
            if (menuItem['price'] != null) {
              price = menuItem['price'] is int ? menuItem['price'] : int.tryParse(menuItem['price'].toString()) ?? 0;
            }

            if (item['quantity'] != null) {
              quantity = item['quantity'] is int ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 0;
            }

            items.add({
              'name': menuItem['menuName'] ?? 'Unknown',  // 메뉴 이름 설정
              'price': price,  // 가격 설정
              'quantity': quantity,  // 수량 설정
            });

            total += price * quantity;  // 총 금액 계산
          }
        }

        setState(() {
          orderItems = items;  // 주문 아이템 목록 설정
          totalAmount = total;  // 총 금액 설정
        });
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  Future<void> _fetchReservationType() async {
    try {
      // Firestore에서 예약 타입 불러오기
      var reservationSnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(widget.reservationId)
          .get();

      if (reservationSnapshot.exists) {
        setState(() {
          isTakeout = reservationSnapshot.data()!['type'];  // 예약 타입 설정 (0: 매장, 1: 포장)
        });
      }
    } catch (e) {
      print('Error fetching reservation type: $e');
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;  // 즐겨찾기 상태 토글
    });
  }

  void showCancelDialog() {
    final TextEditingController reasonController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('예약 취소'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('예약취소 사유를 입력해주세요.'),
                TextFormField(
                  controller: reasonController,
                  decoration: InputDecoration(hintText: '사유 입력'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '사유를 입력해주세요.';
                    }
                    if (value.length < 3) {
                      return '사유는 최소 3글자 이상이어야 합니다.';
                    }
                    if (value.length > 100) {
                      return '사유는 최대 100글자 이하이어야 합니다.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String reason = reasonController.text;

                  try {
                    // Firestore에서 예약을 삭제
                    await FirebaseFirestore.instance
                        .collection('reservations')
                        .doc(widget.reservationId)
                        .delete();

                    FlutterLocalNotification.showNotification(
                      '예약취소',
                      '예약이 취소되었습니다.',
                    );

                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/waitingNumber');
                  } catch (e) {
                    print('Error deleting reservation: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('예약 취소 중 오류가 발생했습니다.')),
                    );
                  }
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 20),
            Center(
              child: Text(
                '(한 팀당 평균 대기 시간 : $averageWaitTime분)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 20),
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
                        builder: (context) => InfoInputScreen(
                            reservationId: widget
                                .reservationId), // InfoInputScreen에 예약 ID 전달
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
                  onPressed: isTakeout == 2
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  cart(), // 장바구니 페이지로 이동
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
                  onPressed: showCancelDialog,  // 예약 취소 다이얼로그 표시
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
                                image: restaurantPhotoUrl != null
                                    ? NetworkImage(restaurantPhotoUrl!)
                                    : AssetImage("assets/images/malatang.png")
                                        as ImageProvider,
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
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 200.0, // 원하는 최대 너비 설정
                                      ),
                                      child: Wrap(
                                        children: [
                                          Text(
                                            restaurantAddress ?? '',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          width: 400,
                          height: 300,
                          child: restaurantLocation != null
                              ? GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: restaurantLocation!,
                                    zoom: 14.0,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId('restaurant'),
                                      position: restaurantLocation!,
                                    ),
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                        itemCount: orderItems.length,
                        itemBuilder: (context, index) {
                          var item = orderItems[index];
                          return ListTile(
                            title: Text(item['name']),
                            subtitle: Text('수량: ${item['quantity']}'),
                            trailing: Text('${item['price']}원'),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '총 금액: $totalAmount원',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
  final String reservationId;  // 예약 ID

  InfoInputScreen({required this.reservationId});

  @override
  _InfoInputScreenState createState() => _InfoInputScreenState();
}

class _InfoInputScreenState extends State<InfoInputScreen> {
  String nickname = '';  // 닉네임
  int numberOfPeople = 1;  // 인원수
  bool isTakeout = false;  // 포장 여부
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReservationDetails();  // 예약 상세 정보 불러오기
  }

  Future<void> _fetchReservationDetails() async {
    try {
      // Firestore에서 예약 상세 정보 불러오기
      var reservationSnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(widget.reservationId)
          .get();

      if (reservationSnapshot.exists) {
        var data = reservationSnapshot.data()!;
        setState(() {
          nickname = data['nickname'];  // 닉네임 설정
          numberOfPeople = data['numberOfPeople'];  // 인원수 설정
          isTakeout = data['type'] == 2;  // 포장 여부 설정 (2: 포장)
          _nicknameController.text = nickname;  // 닉네임 텍스트 필드 설정
          _phoneController.text = data['phone'] ?? '';  // 전화번호 텍스트 필드 설정
          _altPhoneController.text = data['altPhone'] ?? '';  // 보조 전화번호 텍스트 필드 설정
        });
      }
    } catch (e) {
      print('Error fetching reservation details: $e');
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
            Text(
              isTakeout ? '포장' : '매장',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            Text(
              '닉네임',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
              ),
            ),
            TextField(
              controller: _nicknameController,
              enabled: false, // 편집 비활성화
              decoration: InputDecoration(),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '인원수',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),
                    fontSize: 18,
                    fontFamily: 'Epilogue',
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: isTakeout
                            ? null
                            : () {
                                setState(() {
                                  if (numberOfPeople > 0) {
                                    numberOfPeople--;
                                  }
                                });
                              }),
                    Text('$numberOfPeople'),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: isTakeout || numberOfPeople >= 10
                            ? null
                            : () {
                                setState(() {
                                  if (numberOfPeople < 10) {
                                    numberOfPeople++;
                                  }
                                });
                              }),
                  ],
                ),
              ],
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
            TextField(
              controller: _phoneController,
              enabled: false, // 편집 비활성화
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
            TextField(
              controller: _altPhoneController,
              decoration: InputDecoration(),
            ),
            SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Firestore에서 예약 상세 정보 업데이트
                  FirebaseFirestore.instance
                      .collection('reservations')
                      .doc(widget.reservationId)
                      .update({
                    'numberOfPeople': numberOfPeople,
                    'altPhone': _altPhoneController.text,
                  });

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
