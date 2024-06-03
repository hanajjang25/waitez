import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cartItems = [];
  String nickname = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            nickname = userDoc.data()?['nickname'] ?? '';
          });
          _fetchCartItems(); // Fetch cart items after getting the nickname
        } else {
          print('User document does not exist.');
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      // Fetch the most recent reservation for the user
      final reservationQuery = await FirebaseFirestore.instance
          .collection('reservations')
          .where('nickname', isEqualTo: nickname)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (reservationQuery.docs.isNotEmpty) {
        final reservationId = reservationQuery.docs.first.id;

        // Fetch the cart items for the most recent reservation
        final cartQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationId)
            .collection('cart')
            .get();
        setState(() {
          cartItems = cartQuery.docs.map((doc) {
            final data = doc.data();
            final menuItem = data['menuItem'] ?? {};
            return {
              'name': menuItem['menuName'] ?? 'Unknown',
              'price': (menuItem['price'] ?? 0) as int,
              'quantity': (data['quantity'] ?? 1) as int,
              'photoUrl': menuItem['photoUrl'] ?? '',
            };
          }).toList();
        });
      } else {
        print('No recent reservation found for this user.');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<void> _addCartItem(Map<String, dynamic> menuItem) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the most recent reservation for the user
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('nickname', isEqualTo: nickname)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
        if (reservationQuery.docs.isNotEmpty) {
          final reservationId = reservationQuery.docs.first.id;

          // Add the cart item to the subcollection
          await FirebaseFirestore.instance
              .collection('reservations')
              .doc(reservationId)
              .collection('cart')
              .add({
            'menuItem': menuItem,
            'quantity': 1,
            'nickname': nickname,
          });

          // Fetch the updated cart items
          _fetchCartItems();
        } else {
          print('No recent reservation found for this user.');
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error adding cart item: $e');
    }
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void updateQuantity(int index, int quantity) {
    setState(() {
      cartItems[index]['quantity'] = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = cartItems.fold(
        0,
        (sum, item) =>
            sum + (item['price'] as int) * (item['quantity'] as int));

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
                        return CartItem(
                          name: cartItems[index]['name'] as String,
                          price: cartItems[index]['price'] as int,
                          quantity: cartItems[index]['quantity'] as int,
                          photoUrl: cartItems[index]['photoUrl'] as String,
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
