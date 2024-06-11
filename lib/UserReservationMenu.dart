import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserCart.dart'; // UserCart 클래스를 import합니다.
import 'reservationBottom.dart';

class UserReservationMenu extends StatefulWidget {
  @override
  _UserReservationMenuState createState() => _UserReservationMenuState();
}

class _UserReservationMenuState extends State<UserReservationMenu> {
  bool isFavorite = false;
  Map<String, dynamic>? restaurantData;
  List<Map<String, dynamic>> menuItems = [];
  String? restaurantId;
  String? reservationId;
  String? nickname;
  bool hasExistingReservation = false;

  @override
  void initState() {
    super.initState();
    _checkExistingReservations();
    _fetchLatestReservation();
  }

  Future<void> _checkExistingReservations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('nickname', isEqualTo: user.displayName)
            .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
            .where('status', isEqualTo: 'confirmed')
            .get();

        if (reservationQuery.docs.isNotEmpty) {
          setState(() {
            hasExistingReservation = true;
          });
        }
      }
    } catch (e) {
      print('Error checking existing reservations: $e');
    }
  }

  Future<void> _fetchLatestReservation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.isAnonymous) {
          // 익명 사용자 처리
          final nonMemberQuery = await FirebaseFirestore.instance
              .collection('nonmembers')
              .where('uid', isEqualTo: user.uid)
              .limit(1)
              .get();

          if (nonMemberQuery.docs.isNotEmpty) {
            final nonMemberDoc = nonMemberQuery.docs.first;
            nickname = nonMemberDoc['nickname'];

            final reservationQuery = await FirebaseFirestore.instance
                .collection('reservations')
                .where('nickname', isEqualTo: nickname)
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get();

            if (reservationQuery.docs.isNotEmpty) {
              final reservationDoc = reservationQuery.docs.first;
              setState(() {
                restaurantId = reservationDoc['restaurantId'];
                reservationId = reservationDoc.id;
              });
              // Fetch restaurant details
              _fetchRestaurantDetails();
              // Fetch menu items
              _fetchMenuItems();
            } else {
              _showNoReservationFound();
            }
          } else {
            _showNoReservationFound();
          }
        } else {
          // 일반 사용자 처리
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: user.displayName)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (reservationQuery.docs.isNotEmpty) {
            final reservationDoc = reservationQuery.docs.first;
            setState(() {
              restaurantId = reservationDoc['restaurantId'];
              reservationId = reservationDoc.id;
            });
            // Fetch restaurant details
            _fetchRestaurantDetails();
            // Fetch menu items
            _fetchMenuItems();
          } else {
            _showNoReservationFound();
          }
        }
      } else {
        _showUserNotLoggedIn();
      }
    } catch (e) {
      _showErrorFetchingReservationInfo(e);
    }
  }

  Future<void> _fetchRestaurantDetails() async {
    if (restaurantId != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantId)
            .get();
        if (doc.exists) {
          setState(() {
            restaurantData = doc.data() as Map<String, dynamic>?;
          });
        } else {
          _showRestaurantNotFound();
        }
      } catch (e) {
        _showErrorFetchingRestaurantDetails(e);
      }
    }
  }

  Future<void> _fetchMenuItems() async {
    if (restaurantId != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menus')
            .get();

        setState(() {
          menuItems = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      } catch (e) {
        _showErrorFetchingMenuItems(e);
      }
    }
  }

  Future<void> _confirmReservation() async {
    if (hasExistingReservation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 오늘 예약된 내역이 있습니다. 새로운 예약을 할 수 없습니다.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartQuery = await FirebaseFirestore.instance
          .collection('cart')
          .where('nickname', isEqualTo: user.displayName)
          .get();

      if (cartQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('포장은 메뉴 주문을 필수로 해야 합니다')),
        );
        return;
      }

      if (reservationId != null) {
        try {
          await FirebaseFirestore.instance
              .collection('reservations')
              .doc(reservationId)
              .update({'status': 'confirmed'});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reservation confirmed.')),
          );
          Navigator.pushNamed(context, '/waitingNumber');
        } catch (e) {
          _showErrorConfirmingReservation(e);
        }
      } else {
        _showNoReservationFoundToConfirm();
      }
    }
  }

  void _showNoReservationFound() {
    print('No recent reservation found for this user.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No recent reservation found.')),
    );
  }

  void _showUserNotLoggedIn() {
    print('User is not logged in.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User is not logged in.')),
    );
  }

  void _showErrorFetchingReservationInfo(e) {
    print('Error fetching reservation info: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching reservation info: $e')),
    );
  }

  void _showRestaurantNotFound() {
    print('Restaurant not found');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Restaurant not found')),
    );
  }

  void _showErrorFetchingRestaurantDetails(e) {
    print('Error fetching restaurant details: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching restaurant details: $e')),
    );
  }

  void _showErrorFetchingMenuItems(e) {
    print('Error fetching menu items: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching menu items: $e')),
    );
  }

  void _showErrorConfirmingReservation(e) {
    print('Error confirming reservation: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error confirming reservation: $e')),
    );
  }

  void _showNoReservationFoundToConfirm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No reservation found to confirm.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (restaurantData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantData!['restaurantName'] ?? 'Unknown'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart()),
              );
            },
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
                    image: NetworkImage(restaurantData!['photoUrl'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              restaurantData!['restaurantName'] ?? 'Unknown',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                height: 1.5,
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
                      height: 1.5,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      restaurantData!['location'] ?? 'Unknown',
                      style: TextStyle(fontSize: 16),
                    ),
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
                      height: 1.5,
                      letterSpacing: -0.27,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      restaurantData!['businessHours'] ?? 'Unknown',
                      style: TextStyle(fontSize: 16),
                    ),
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
                    title: Text(menuItem['menuName'] ?? 'Unknown'),
                    subtitle: Text('${menuItem['price'] ?? '0'}원'),
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
                    _confirmReservation();
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
              height: 50,
            )
          ],
        ),
      ),
      bottomNavigationBar: reservationBottom(),
    );
  }

  void navigateToDetails(Map<String, dynamic>? menuItem) {
    if (menuItem != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuDetailsPage(
              menuItem: menuItem,
              restaurantId: restaurantId,
              reservationId: reservationId), // restaurantId와 reservationId 전달
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu item details are missing')),
      );
    }
  }
}

class MenuDetailsPage extends StatelessWidget {
  final Map<String, dynamic> menuItem;
  final String? restaurantId;
  final String? reservationId;

  MenuDetailsPage(
      {required this.menuItem,
      required this.restaurantId,
      required this.reservationId});

  Future<void> addToCart(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && reservationId != null) {
        await FirebaseFirestore.instance.collection('cart').add({
          'nickname': user.displayName,
          'restaurantId': restaurantId,
          'menuItem': menuItem,
          'reservationId': reservationId, // reservationId 추가
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('장바구니에 추가되었습니다.')),
        );
      } else if (user != null && user.isAnonymous) {
        // Handle anonymous user
        await FirebaseFirestore.instance.collection('cart').add({
          'uid': user.uid,
          'restaurantId': restaurantId,
          'menuItem': menuItem,
          'reservationId': reservationId, // reservationId 추가
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('장바구니에 추가되었습니다.')),
        );
      } else {
        print('User is not logged in or reservationId is null.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('User is not logged in or reservationId is null.')),
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menuItem['menuName'] ?? 'Unknown',
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            height: 1.5,
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
                height: 1.5,
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
                    image: NetworkImage(menuItem['photoUrl'] ??
                        'https://via.placeholder.com/358x201'), // Replace with actual image URL
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              menuItem['menuName'] ?? 'Unknown',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 24,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 50),
            Text(
              '가격: ${menuItem['price'] ?? '0'}원',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 20,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 50),
            Text(
              menuItem['description'] ?? '상세 설명이 없습니다.',
              style: TextStyle(
                color: Color(0xFF1C1C21),
                fontSize: 18,
                fontFamily: 'Epilogue',
                height: 1.5,
                letterSpacing: -0.27,
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () => addToCart(context),
                child: Text('장바구니에 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
