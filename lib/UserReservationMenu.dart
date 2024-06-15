import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserCart.dart';
import 'reservationBottom.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification.dart';

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
        final userNickname = user.isAnonymous
            ? await _fetchAnonymousNickname(user.uid)
            : user.displayName;
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('nickname', isEqualTo: userNickname)
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
          final nickname = await _fetchAnonymousNickname(user.uid);
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: nickname)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (reservationQuery.docs.isNotEmpty) {
            final reservationDoc = reservationQuery.docs.first;
            setState(() {
              if (reservationDoc.data().containsKey('restaurantId')) {
                restaurantId = reservationDoc['restaurantId'];
              } else {
                restaurantId = null; // 필드가 존재하지 않으면 null로 설정
              }
              reservationId = reservationDoc.id;
            });
            if (restaurantId != null) {
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
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: user.displayName)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (reservationQuery.docs.isNotEmpty) {
            final reservationDoc = reservationQuery.docs.first;
            setState(() {
              if (reservationDoc.data().containsKey('restaurantId')) {
                restaurantId = reservationDoc['restaurantId'];
              } else {
                restaurantId = null; // 필드가 존재하지 않으면 null로 설정
              }
              reservationId = reservationDoc.id;
            });
            if (restaurantId != null) {
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
        }
      } else {
        _showUserNotLoggedIn();
      }
    } catch (e) {
      _showErrorFetchingReservationInfo(e);
    }
  }

  Future<String> _fetchAnonymousNickname(String uid) async {
    try {
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_members')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (nonMemberQuery.docs.isNotEmpty) {
        print('Anonymous user found with UID: $uid');
        return nonMemberQuery.docs.first['nickname'];
      } else {
        print('No matching documents found for anonymous user UID: $uid');
        throw Exception('Anonymous user nickname not found.');
      }
    } catch (e) {
      print('Error fetching anonymous user nickname: $e');
      throw e;
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
      final userNickname = user.isAnonymous
          ? await _fetchAnonymousNickname(user.uid)
          : user.displayName;
      final cartQuery = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .collection('cart')
          .where('nickname', isEqualTo: userNickname)
          .get();

      if (cartQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메뉴 주문을 필수로 해야 합니다')),
        );
        return;
      }

      if (reservationId != null) {
        try {
          // Fetch today's reservations for the same restaurant and type
          final today = DateTime.now();
          final startOfDay = DateTime(today.year, today.month, today.day);
          final endOfDay =
              DateTime(today.year, today.month, today.day, 23, 59, 59);

          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('restaurantId', isEqualTo: restaurantId)
              .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
              .where('timestamp', isLessThanOrEqualTo: endOfDay)
              .where('type', isEqualTo: restaurantData?['type'])
              .get();

          // Calculate waiting number
          final waitingNumber = reservationQuery.docs.length + 1;

          // Update reservation with confirmed status and waiting number
          await FirebaseFirestore.instance
              .collection('reservations')
              .doc(reservationId)
              .update({
            'status': 'confirmed',
            'waitingNumber': waitingNumber,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reservation confirmed.')),
          );

          if (user.isAnonymous) {
            Navigator.pushNamed(context, '/nonMemberWaitingNumber');
          } else {
            Navigator.pushNamed(context, '/waitingNumber');
          }
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
                  onPressed: () async {
                    await _confirmReservation();
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
            reservationId: reservationId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu item details are missing')),
      );
    }
  }
}

class MenuDetailsPage extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final String? restaurantId;
  final String? reservationId;

  MenuDetailsPage({
    required this.menuItem,
    required this.restaurantId,
    required this.reservationId,
  });

  @override
  _MenuDetailsPageState createState() => _MenuDetailsPageState();
}

class _MenuDetailsPageState extends State<MenuDetailsPage> {
  Future<void> addToCart(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userNickname = user?.isAnonymous ?? false
          ? await _fetchAnonymousNickname(user!.uid)
          : user?.displayName;

      if (user != null && widget.reservationId != null) {
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(widget.reservationId)
            .collection('cart')
            .add({
          'nickname': userNickname,
          'restaurantId': widget.restaurantId,
          'menuItem': widget.menuItem,
          'quantity': 1, // 기본 수량을 1로 설정
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('장바구니에 추가되었습니다.')),
          );
        }
      } else {
        print('User is not logged in or reservationId is null.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('User is not logged in or reservationId is null.')),
          );
        }
      }
    } catch (e) {
      print('Error adding to cart: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    }
  }

  Future<String> _fetchAnonymousNickname(String uid) async {
    try {
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_members')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (nonMemberQuery.docs.isNotEmpty) {
        print('Anonymous user found with UID: $uid');
        return nonMemberQuery.docs.first['nickname'];
      } else {
        print('No matching documents found for anonymous user UID: $uid');
        throw Exception('Anonymous user nickname not found.');
      }
    } catch (e) {
      print('Error fetching anonymous user nickname: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menuItem['menuName'] ?? 'Unknown',
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
                    image: NetworkImage(widget.menuItem['photoUrl'] ??
                        'https://via.placeholder.com/358x201'), // Replace with actual image URL
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              widget.menuItem['menuName'] ?? 'Unknown',
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
              '가격: ${widget.menuItem['price'] ?? '0'}원',
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
              widget.menuItem['description'] ?? '상세 설명이 없습니다.',
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

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cartItems = [];
  String reservationId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserAndReservationId();
  }

  Future<void> _fetchUserAndReservationId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? nickname = await _fetchNickname(user.email!);
        if (nickname != null) {
          await _fetchLatestReservationId(nickname);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found with this email.')),
          );
        }
      }
    } catch (e) {
      print('Error fetching user or reservation ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user or reservation ID: $e')),
      );
    }
  }

  Future<String?> _fetchNickname(String email) async {
    // users 컬렉션에서 사용자 정보를 찾음
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userQuery.docs.isNotEmpty) {
      return userQuery.docs.first['nickname'];
    } else {
      // non_member 컬렉션에서 사용자 정보를 찾음
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_member')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (nonMemberQuery.docs.isNotEmpty) {
        return nonMemberQuery.docs.first['nickname'];
      }
    }
    return null;
  }

  Future<void> _fetchLatestReservationId(String nickname) async {
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('nickname', isEqualTo: nickname)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (reservationQuery.docs.isNotEmpty) {
      final reservationDoc = reservationQuery.docs.first;
      setState(() {
        reservationId = reservationDoc.id;
      });
      _fetchCartItems();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No recent reservation found.')),
      );
    }
  }

  Future<void> _fetchCartItems() async {
    if (reservationId.isNotEmpty) {
      try {
        final cartQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationId)
            .collection('cart')
            .get();

        setState(() {
          cartItems = cartQuery.docs
              .map((doc) =>
                  {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
        });
      } catch (e) {
        print('Error fetching cart items: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching cart items: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No reservation found to fetch cart items.')),
      );
    }
  }

  Future<void> removeItem(int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .collection('cart')
          .doc(cartItems[index]['id'])
          .delete();

      setState(() {
        cartItems.removeAt(index);
      });
    } catch (e) {
      print('Error removing cart item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing cart item: $e')),
      );
    }
  }

  Future<void> updateQuantity(int index, int quantity) async {
    if (quantity > 0) {
      try {
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationId)
            .collection('cart')
            .doc(cartItems[index]['id'])
            .update({'quantity': quantity});

        setState(() {
          cartItems[index]['quantity'] = quantity;
        });
      } catch (e) {
        print('Error updating cart item quantity: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating cart item quantity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = cartItems.fold(
        0,
        (sum, item) =>
            sum +
            ((item['menuItem']?['price'] ?? 0) as int) *
                ((item['quantity'] ?? 1) as int));

    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final menuItem = cartItems[index]['menuItem'];
                        return CartItem(
                          name: menuItem != null
                              ? menuItem['menuName'] as String? ?? ''
                              : '',
                          price: menuItem != null
                              ? menuItem['price'] as int? ?? 0
                              : 0,
                          quantity: cartItems[index]['quantity'] as int? ?? 1,
                          photoUrl: menuItem != null
                              ? menuItem['photoUrl'] as String? ?? ''
                              : '',
                          onRemove: () => removeItem(index),
                          onQuantityChanged: (newQuantity) =>
                              updateQuantity(index, newQuantity),
                        );
                      },
                    )
                  : Center(child: Text('장바구니에 아이템이 없습니다.')),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('총 금액', style: TextStyle(fontSize: 18)),
                Text('₩ $totalPrice', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;
  final int price;
  final int quantity;
  final String photoUrl;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.photoUrl,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: photoUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('₩ $price',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      onQuantityChanged(quantity - 1);
                    }
                  },
                ),
                Text('$quantity', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    onQuantityChanged(quantity + 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
