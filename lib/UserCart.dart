import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final nickname = userDoc.data()?['nickname'] ?? '';
          final reservationQuery = await FirebaseFirestore.instance
              .collection('reservations')
              .where('nickname', isEqualTo: nickname)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();
          if (reservationQuery.docs.isNotEmpty) {
            final reservationId = reservationQuery.docs.first.id;
            final cartQuery = await FirebaseFirestore.instance
                .collection('cart')
                .where('reservationId', isEqualTo: reservationId)
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
        } else {
          print('User document does not exist.');
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '장바구니',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  letterSpacing: -0.27,
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
                width: 500,
                child: Divider(color: Colors.black, thickness: 2.0)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
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
              ),
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
