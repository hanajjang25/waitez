import 'package:flutter/material.dart';
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
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final nickname = userDoc.data()?['nickname'];

          if (nickname != null) {
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

        final today = DateTime.now().toLocal();
        final formattedToday = "${today.year}-${today.month}-${today.day}";

        setState(() {
          storeWaitlist = [];
          takeoutWaitlist = [];
          reservationQuery.docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final timestamp =
                (data['timestamp'] as Timestamp?)?.toDate().toLocal();
            final formattedTimestamp = timestamp != null
                ? "${timestamp.year}-${timestamp.month}-${timestamp.day}"
                : 'Unknown';

            if (formattedTimestamp == formattedToday) {
              final type = doc['type'] == 1 ? '매장' : '포장';
              final entry = WaitlistEntry(
                id: doc.id,
                name: data['nickname']?.toString() ?? 'Unknown',
                people: data['numberOfPeople'] ?? 0,
                phoneNum: data['phone']?.toString() ?? 'Unknown',
                timeStamp: formattedTimestamp,
                type: type,
              );
              if (type == '매장') {
                storeWaitlist.add(entry);
              } else {
                takeoutWaitlist.add(entry);
              }
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

  Future<void> _markAsNoShow(String nickname) async {
    try {
      String phoneNumber = await _getPhoneNumber(nickname);

      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final noShowCount = userDoc.data()['noShowCount'] ?? 0;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .update({'noShowCount': noShowCount + 1});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No-show count updated successfully.')),
        );
      }

      // Send SMS notification
      if (phoneNumber.isNotEmpty) {
        NotificationService.sendSmsNotification('불참처리 되었습니다.', [phoneNumber]);
      }
    } catch (e) {
      print('Error updating no-show count: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating no-show count: $e')),
      );
    }
  }

  Future<String> _getPhoneNumber(String nickname) async {
    try {
      // Check in users collection first
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        return userDoc.data()['phoneNum'] ?? '';
      }

      // If not found, check in non_members collection
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_members')
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      if (nonMemberQuery.docs.isNotEmpty) {
        final nonMemberDoc = nonMemberQuery.docs.first;
        return nonMemberDoc.data()['phoneNum'] ?? '';
      }
    } catch (e) {
      print('Error fetching phone number: $e');
    }

    return ''; // Return an empty string if not found
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
                        onPressed: () {
                          _confirmArrival(waitP.id);
                          NotificationService.sendSmsNotification(
                              '도착확인되었습니다.', [waitP.phoneNum]);
                        },
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
                        onPressed: () async {
                          await _markAsNoShow(waitP.name);
                          NotificationService.sendSmsNotification(
                              '불참처리 되었습니다.', [waitP.phoneNum]);
                        },
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
                        onPressed: () {
                          NotificationService.sendSmsNotification(
                              '조리를 시작합니다.', [waitP.phoneNum]);
                        },
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
