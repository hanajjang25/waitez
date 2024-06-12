import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'UserBottom.dart';
import 'Memberhistory.dart'; // History 페이지를 임포트

class historyList extends StatefulWidget {
  @override
  _historyListState createState() => _historyListState();
}

class _historyListState extends State<historyList> {
  List<Map<String, dynamic>> reservations = [];
  String _searchQuery = '';
  String? nickname = null; // nullable로 변경

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          nickname = userDoc['nickname'] ?? 'Unknown';
        });
        // nickname을 설정한 후에 reservations를 가져옴
        if (nickname != null) {
          await _fetchReservations(nickname!);
        }
      }
    }
  }

  Future<void> _fetchReservations(String nickname) async {
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('nickname', isEqualTo: nickname)
        .orderBy('timestamp', descending: true)
        .get();

    List<Map<String, dynamic>> fetchedReservations = [];

    for (var doc in reservationQuery.docs) {
      var reservation = doc.data();
      reservation['id'] = doc.id; // 예약 ID를 포함
      var restaurantId = reservation['restaurantId'];

      var restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .get();

      if (restaurantDoc.exists) {
        var restaurantData = restaurantDoc.data();
        String restaurantName = restaurantData?['restaurantName'] ?? '';
        String restaurantPhoto = restaurantData?['photoUrl'] ?? '';
        if (restaurantName.isNotEmpty && restaurantPhoto.isNotEmpty) {
          reservation['restaurantName'] = restaurantName;
          reservation['restaurantPhoto'] = restaurantPhoto;
          fetchedReservations.add(reservation);
        }
      }
    }

    setState(() {
      reservations = fetchedReservations;
    });
  }

  String formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      var date = timestamp.toDate();
      var localDate = date.toLocal(); // 로컬 시간대로 변환
      var formatter = DateFormat('yyyy-MM-dd'); // 날짜만 표시하도록 형식 지정
      return formatter.format(localDate);
    } else if (timestamp is DateTime) {
      var localDate = timestamp.toLocal(); // 로컬 시간대로 변환
      var formatter = DateFormat('yyyy-MM-dd'); // 날짜만 표시하도록 형식 지정
      return formatter.format(localDate);
    } else {
      return 'Invalid date';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMenuItems(
      String reservationId) async {
    final cartQuery = await FirebaseFirestore.instance
        .collection('cart')
        .where('reservationId', isEqualTo: reservationId)
        .get();

    List<Map<String, dynamic>> menuItems = [];
    for (var doc in cartQuery.docs) {
      var item = doc.data();
      var menuItem = item['menuItem'];
      if (menuItem != null) {
        menuItems.add({
          'name': menuItem['menuName'] ?? 'Unknown',
          'price': menuItem['price'] ?? 0,
          'quantity': menuItem['quantity'] ?? 0,
        });
      }
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    final filteredReservations = reservations.where((reservation) {
      final restaurantName =
          reservation['restaurantName']?.toString().toLowerCase() ?? '';
      final searchQuery = _searchQuery.toLowerCase();
      return restaurantName.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('이력조회'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '검색',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: filteredReservations.map((reservation) {
                  return ReservationCard(
                    imageAsset: reservation['restaurantPhoto'] ?? '',
                    restaurantName: reservation['restaurantName'] ?? '',
                    date: formatDate(reservation['timestamp']),
                    buttonText: '자세히 보기',
                    onPressed: () async {
                      List<Map<String, dynamic>> menuItems =
                          await _fetchMenuItems(reservation['id']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => History(
                            restaurantName:
                                reservation['restaurantName'] ?? 'Unknown',
                            date: formatDate(reservation['timestamp']),
                            imageAsset: reservation['restaurantPhoto'] ??
                                'assets/images/malatang.png',
                            menuItems: menuItems,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String imageAsset;
  final String restaurantName;
  final String date;
  final String buttonText;
  final VoidCallback onPressed;

  ReservationCard({
    required this.imageAsset,
    required this.restaurantName,
    required this.date,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 50, // 적절한 크기로 제한
          child: imageAsset.startsWith('http')
              ? Image.network(imageAsset, fit: BoxFit.cover)
              : Image.asset(imageAsset, fit: BoxFit.cover),
        ),
        title: Text(restaurantName),
        subtitle: Text(date),
        trailing: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ),
    );
  }
}
