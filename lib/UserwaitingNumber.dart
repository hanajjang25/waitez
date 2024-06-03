import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class waitingNumber extends StatefulWidget {
  @override
  _WaitingNumberState createState() => _WaitingNumberState();
}

class _WaitingNumberState extends State<waitingNumber> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _nickname = '';
  List<Map<String, dynamic>> _storeReservations = [];
  List<Map<String, dynamic>> _takeoutReservations = [];

  @override
  void initState() {
    super.initState();
    _fetchUserNickname();
  }

  Future<void> _fetchUserNickname() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        setState(() {
          _nickname = userSnapshot['nickname'] ?? '';
        });
        print('Nickname: $_nickname'); // 디버깅 메시지 추가
        _fetchConfirmedReservations();
      }
    }
  }

  Future<void> _fetchConfirmedReservations() async {
    QuerySnapshot reservationSnapshot = await _firestore
        .collection('reservations')
        .where('nickname', isEqualTo: _nickname)
        .where('status', isEqualTo: 'confirmed')
        .get();

    List<Map<String, dynamic>> storeReservations = [];
    List<Map<String, dynamic>> takeoutReservations = [];

    reservationSnapshot.docs.forEach((doc) {
      var reservation = {
        'type': doc['type'] ?? '',
        'number': doc['number'] ?? 0,
        'description': doc['description'] ?? '',
        'address': doc['address'] ?? '',
        'orderItems': List<Map<String, dynamic>>.from(doc['orderItems'] ?? []),
      };
      if (reservation['type'] == 'store') {
        storeReservations.add(reservation);
      } else if (reservation['type'] == 'takeout') {
        takeoutReservations.add(reservation);
      }
    });

    setState(() {
      _storeReservations = storeReservations;
      _takeoutReservations = takeoutReservations;
    });

    print('Store Reservations: $_storeReservations'); // 디버깅 메시지 추가
    print('Takeout Reservations: $_takeoutReservations'); // 디버깅 메시지 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.person, color: Colors.black),
            Text('대기순번', style: TextStyle(color: Colors.black)),
            Icon(Icons.menu, color: Colors.black),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _nickname.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                    ..._buildQueueCards(context, _storeReservations),
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
                    ..._buildQueueCards(context, _takeoutReservations),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> _buildQueueCards(
      BuildContext context, List<Map<String, dynamic>> reservations) {
    return reservations.map((reservation) {
      return _buildQueueCard(
        context,
        reservation['type'],
        reservation['number'],
        reservation['description'],
        reservation['address'],
        reservation['orderItems'],
      );
    }).toList();
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
            builder: (context) => WaitingDetail(
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
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
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
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: TextStyle(
                        color: Color(0xFF1C1C21),
                        fontSize: 18,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      address,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontFamily: 'Epilogue',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaitingDetail extends StatelessWidget {
  final String restaurantName;
  final String restaurantAddress;
  final int queueNumber;
  final List<Map<String, dynamic>> orderItems;

  WaitingDetail({
    required this.restaurantName,
    required this.restaurantAddress,
    required this.queueNumber,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address: $restaurantAddress',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Queue Number: $queueNumber',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Order Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...orderItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${item['name']} - ${item['quantity']}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
