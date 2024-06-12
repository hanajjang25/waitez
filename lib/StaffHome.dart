import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'StaffBottom.dart';
import 'notification.dart';

class WaitlistEntry {
  final String id;
  final String name;
  final int people;
  final String phoneNum;
  final String timeStamp;
  final String type;

  WaitlistEntry({
    required this.id,
    required this.name,
    required this.people,
    required this.phoneNum,
    required this.timeStamp,
    required this.type,
  });
}

class homeStaff extends StatefulWidget {
  @override
  _homeStaffState createState() => _homeStaffState();
}

class _homeStaffState extends State<homeStaff> {
  List<WaitlistEntry> storeWaitlist = [];
  List<WaitlistEntry> takeoutWaitlist = [];
  String? restaurantId;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantId();
  }

  Future<void> _fetchRestaurantId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 현재 로그인된 이메일을 이용하여 사용자 정보 가져오기
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final nickname = userDoc.data()?['nickname'];

          if (nickname != null) {
            // 음식점 DB에서 nickname과 일치하는 음식점 찾기
            final restaurantQuery = await FirebaseFirestore.instance
                .collection('restaurants')
                .where('nickname', isEqualTo: nickname)
                .get();

            if (restaurantQuery.docs.isNotEmpty) {
              setState(() {
                restaurantId = restaurantQuery.docs.first.id;
              });
              _fetchConfirmedReservations();
            } else {
              print('Restaurant not found for this user.');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Restaurant not found for this user.')),
              );
            }
          }
        } else {
          print('User document does not exist.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User document does not exist.')),
          );
        }
      } else {
        print('User is not logged in.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),
        );
      }
    } catch (e) {
      print('Error fetching restaurant ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching restaurant ID: $e')),
      );
    }
  }

  Future<void> _fetchConfirmedReservations() async {
    if (restaurantId != null) {
      try {
        final reservationQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .where('restaurantId', isEqualTo: restaurantId)
            .where('status', isEqualTo: 'confirmed')
            .get();

        setState(() {
          storeWaitlist = [];
          takeoutWaitlist = [];
          reservationQuery.docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final type = doc['type'] == 1 ? '매장' : '포장';
            final entry = WaitlistEntry(
              id: doc.id,
              name: data['nickname']?.toString() ?? 'Unknown',
              people: data['numberOfPeople'] ?? 0,
              phoneNum: data['phone']?.toString() ?? 'Unknown',
              timeStamp: (data['timestamp'] as Timestamp?)
                      ?.toDate()
                      .toLocal()
                      .toString()
                      .split(' ')[0] ??
                  'Unknown',
              type: type,
            );
            if (type == '매장') {
              storeWaitlist.add(entry);
            } else {
              takeoutWaitlist.add(entry);
            }
          });
        });
      } catch (e) {
        print('Error fetching confirmed reservations: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching confirmed reservations: $e')),
        );
      }
    }
  }

  Future<void> _cancelReservation(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(id)
          .update({'status': 'cancelled'});
      _fetchConfirmedReservations();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation cancelled successfully.')),
      );
    } catch (e) {
      print('Error cancelling reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling reservation: $e')),
      );
    }
  }

  Future<void> _confirmArrival(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(id)
          .update({'status': 'arrived'});
      _fetchConfirmedReservations();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arrival confirmed successfully.')),
      );
    } catch (e) {
      print('Error confirming arrival: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming arrival: $e')),
      );
    }
  }

  Widget buildWaitlist(List<WaitlistEntry> waitlist) {
    if (waitlist.isEmpty) {
      return Center(
        child: Text('현재 예약되어 있는 것이 존재하지 않습니다.'),
      );
    }
    return Column(
      children: waitlist.map((waitP) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        waitP.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('날짜: ${waitP.timeStamp}'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('타입: ${waitP.type}'),
                      SizedBox(width: 50),
                      Text('인원수: ${waitP.people}'),
                    ],
                  ),
                  Text('전화번호: ${waitP.phoneNum}'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                        ),
                        onPressed: () => _cancelReservation(waitP.id),
                        child: Text(
                          '예약취소',
                          style: TextStyle(
                            color: Color(0xFF1C1C21),
                            fontSize: 15,
                            fontFamily: 'Epilogue',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                        ),
                        onPressed: () => _confirmArrival(waitP.id),
                        child: Text(
                          '도착확인',
                          style: TextStyle(
                            color: Color(0xFF1C1C21),
                            fontSize: 15,
                            fontFamily: 'Epilogue',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                        ),
                        onPressed: () =>
                            FlutterLocalNotification.showNotification(
                          '불참알림',
                          '불참하여 불참횟수 증가합니다.',
                        ),
                        child: Text(
                          '불참',
                          style: TextStyle(
                            color: Color(0xFF1C1C21),
                            fontSize: 15,
                            fontFamily: 'Epilogue',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                        ),
                        onPressed: () =>
                            FlutterLocalNotification.showNotification(
                          '조리시작알림',
                          '조리를 시작합니다. 주문내역이 null이라면 주문을 해주세요 라는 안내문 띄우기',
                        ),
                        child: Text(
                          '조리시작/주문',
                          style: TextStyle(
                            color: Color(0xFF1C1C21),
                            fontSize: 15,
                            fontFamily: 'Epilogue',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'waitez',
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.07,
            letterSpacing: -0.27,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _fetchConfirmedReservations,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              Container(
                width: screenWidth,
                child: storeWaitlist.isEmpty
                    ? Center(child: Text('현재 예약되어 있는 것이 존재하지 않습니다.'))
                    : buildWaitlist(storeWaitlist),
              ),
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
              Container(
                width: screenWidth,
                child: takeoutWaitlist.isEmpty
                    ? Center(child: Text('현재 예약되어 있는 것이 존재하지 않습니다.'))
                    : buildWaitlist(takeoutWaitlist),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: staffBottom(),
    );
  }
}
