import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserCart.dart'; // UserCart 클래스를 import합니다.

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

  @override
  void initState() {
    super.initState();
    _fetchLatestReservation();
  }

  Future<void> _fetchLatestReservation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the most recent reservation for the current user
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
          print('No recent reservation found for this user.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No recent reservation found.')),
          );
        }
      } else {
        print('User is not logged in.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),
        );
      }
    } catch (e) {
      print('Error fetching reservation info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching reservation info: $e')),
      );
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
          print('Restaurant not found');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Restaurant not found')),
          );
        }
      } catch (e) {
        print('Error fetching restaurant details: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching restaurant details: $e')),
        );
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
        print('Error fetching menu items: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching menu items: $e')),
        );
      }
    }
  }

  Future<void> _confirmReservation() async {
    if (reservationId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationId)
            .update({'status': 'confirmed'});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reservation confirmed.')),
        );
      } catch (e) {
        print('Error confirming reservation: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error confirming reservation: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No reservation found to confirm.')),
      );
    }
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
                    Navigator.pushNamed(context, '/waitingNumber');
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

  void navigateToDetails(Map<String, dynamic>? menuItem) {
    if (menuItem != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuDetailsPage(
              menuItem: menuItem,
              restaurantId: restaurantId), // restaurantId 전달
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

  MenuDetailsPage({required this.menuItem, required this.restaurantId});

  Future<void> addToCart(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the most recent reservation for the current user
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('nickname', isEqualTo: user.displayName)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (reservationQuery.docs.isNotEmpty) {
          final reservationDoc = reservationQuery.docs.first;
          final restaurantId = reservationDoc['restaurantId'];

          await FirebaseFirestore.instance.collection('cart').add({
            'nickname': user.displayName,
            'restaurantId': restaurantId,
            'menuItem': menuItem,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('장바구니에 추가되었습니다.')),
          );
        } else {
          print('No recent reservation found for this user.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No recent reservation found.')),
          );
        }
      } else {
        print('User is not logged in.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),
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
