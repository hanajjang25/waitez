import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reservationBottom.dart';
import 'MemberFavorite.dart';
import 'RestaurantInfo.dart';
import 'googleMap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class search extends StatefulWidget {                                           // 검색 페이지 Stateful 위젯 정의
  const search({super.key});

  @override
  State<search> createState() => _SearchState();                               // 검색 페이지의 상태 관리 클래스 생성
}

class SearchDetails {                                                          // 음식점 검색 결과를 나타내는 클래스
  final String id;
  final String name;
  final String address;
  final String description;
  final String businessHours;
  final String photoUrl;
  late List<Map<String, dynamic>> menuItems;                                   // 메뉴 아이템 리스트 초기화
  double? distance;                                                            // 음식점과 사용자 간의 거리

  SearchDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.businessHours,
    required this.photoUrl,
    required this.menuItems,
    this.distance,
  });

  factory SearchDetails.fromFirestore(DocumentSnapshot doc) {                  // Firestore에서 데이터 가져오기
    final data = doc.data() as Map<String, dynamic>;
    return SearchDetails(
      id: doc.id,
      name: data['restaurantName'],
      address: data['location'],
      description: data['description'],
      businessHours: data['businessHours'],
      photoUrl: data['photoUrl'],
      menuItems: [], // Initialize as an empty list
    );
  }
}

class _SearchState extends State<search> {                                     // 검색 페이지의 상태 관리 클래스
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('restaurants');
  List<SearchDetails> allItems = [];                                           // 모든 음식점 리스트
  List<SearchDetails> filteredItems = [];                                      // 필터된 음식점 리스트
  String? _locationKeyword;                                                    // 위치 키워드
  String? _searchKeyword;                                                      // 검색 키워드
  String? _currentAddress;                                                     // 현재 위치 주소
  Position? _currentPosition;                                                  // 현재 위치

  @override
  void initState() {
    super.initState();
    _fetchAllItems();                                                          // 모든 음식점 데이터를 가져오기
    _fetchUserLocationFromDatabase();                                          // 사용자 위치 데이터베이스에서 가져오기
  }

  Future<void> _fetchAllItems() async {                                        // 모든 음식점 데이터를 가져오는 메서드
    try {
      QuerySnapshot querySnapshot =
          await _collectionRef.where('isDeleted', isEqualTo: false).get();
      List<SearchDetails> results = querySnapshot.docs
          .map((doc) => SearchDetails.fromFirestore(doc))
          .toList();

      // Fetch menu items for each restaurant
      for (var item in results) {
        QuerySnapshot menuSnapshot =
            await _collectionRef.doc(item.id).collection('menus').get();
        item.menuItems = menuSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }

      if (mounted) {
        setState(() {
          allItems = results;
          filteredItems = results;
          _calculateDistances();                                               // 거리 계산 메서드 호출
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  Future<void> _fetchUserLocationFromDatabase() async {                        // 사용자 위치 데이터베이스에서 가져오기
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _currentAddress = userData['location'];                            // 현재 위치 주소 설정
          });
        }
        _calculateDistances();                                                 // 거리 계산 메서드 호출
      }
    }
  }

  Future<void> _calculateDistances() async {                                   // 음식점과 사용자 간 거리 계산 메서드
    if (_currentAddress == null) return;

    for (var item in allItems) {
      List<Location> locations = await locationFromAddress(item.address);
      if (locations.isNotEmpty) {
        List<Location> userLocations =
            await locationFromAddress(_currentAddress!);
        if (userLocations.isNotEmpty) {
          double distanceInMeters = Geolocator.distanceBetween(
            userLocations[0].latitude,
            userLocations[0].longitude,
            locations[0].latitude,
            locations[0].longitude,
          );
          item.distance = distanceInMeters / 1000;                             // 거리(km)로 변환
        }
      }
    }

    _filterItems();                                                            // 필터 메서드 호출
  }

  void _filterItems() async {                                                  // 검색 및 위치 필터 메서드
    List<SearchDetails> results = allItems;

    if (_searchKeyword != null && _searchKeyword!.isNotEmpty) {
      results = results.where((item) {
        final containsInMenu = item.menuItems.any((menuItem) =>
            menuItem['menuName']
                .toString()
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()));
        return item.name
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()) ||
            item.description
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()) ||
            containsInMenu;
      }).toList();
    }

    if (_locationKeyword != null && _locationKeyword!.isNotEmpty) {
      results = results.where((item) {
        return item.address
            .toLowerCase()
            .contains(_locationKeyword!.toLowerCase());
      }).toList();
    } else if (_currentAddress != null) {
      results = results.where((item) => item.distance != null).toList()
        ..sort((a, b) => (a.distance ?? double.infinity)
            .compareTo(b.distance ?? double.infinity));
    }

    if (mounted) {
      setState(() {
        filteredItems = results;
      });
    }
  }

 void _updateLocation(String location) {                                       // 위치 키워드 업데이트 메서드
    _locationKeyword = location;
    _filterItems();                                                             // 필터 메서드 호출
  }

  void _updateSearch(String search) {                                           // 검색 키워드 업데이트 메서드
    _searchKeyword = search;
    _filterItems();                                                             // 필터 메서드 호출
  }

  Future<void> _toggleFavorite(SearchDetails item) async {                      // 즐겨찾기 토글 메서드
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userFavoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final favoriteDoc = userFavoritesRef.doc(item.id);

      final favoriteSnapshot = await favoriteDoc.get();

      if (favoriteSnapshot.exists) {                                            // 즐겨찾기 해제
        await favoriteDoc.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('즐겨찾기가 해제되었습니다.')),
        );
      } else {                                                                  // 즐겨찾기 추가
        await favoriteDoc.set({
          'restaurantId': item.id,
          'name': item.name,
          'address': item.address,
          'description': item.description,
          'businessHours': item.businessHours,
          'photoUrl': item.photoUrl,
          'userId': user.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('즐겨찾기에 추가되었습니다.')),
        );
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

 Future<bool> _isFavorite(SearchDetails item) async {                          // 즐겨찾기 상태 확인 메서드
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(item.id)
          .get();

      return favoriteSnapshot.exists;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {                                          // UI 빌드 메서드
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          '검색',
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                height: 30,
                child: Icon(Icons.location_on),
              ),
              Container(
                width: 200,
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MapPage(previousPage: 'UserSearch'),
                      ),
                    );
                  },
                  child: Text(
                    '현재위치설정',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ]),
            if (_currentAddress != null)
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$_currentAddress',                                        // 현재 위치 표시
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) => _updateSearch(value),                       // 검색 키워드 변경 시 호출
              decoration: InputDecoration(
                hintText: "음식점 검색",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFEDEFF2),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredItems.isEmpty                                      // 필터된 아이템이 없을 때 메시지 표시
                  ? Center(child: Text('해당하는 음식점 또는 메뉴가 존재하지 않습니다'))
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        var item = filteredItems[index];
                        return FutureBuilder<bool>(
                          future: _isFavorite(item),                             // 즐겨찾기 상태 확인
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            final isFavorite = snapshot.data ?? false;

                            return Card(
                              color: Colors.blue[50],
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: Image.network(
                                  item.photoUrl,
                                  width: 80,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: Color(0xFF1C1C21),
                                    fontSize: 15,
                                    fontFamily: 'Epilogue',
                                    fontWeight: FontWeight.w700,
                                    height: 2,
                                    letterSpacing: -0.27,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: "주소: \n",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(text: '${item.address}'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: "영업시간: \n",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text: '${item.businessHours}'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: "메뉴: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  '${item.menuItems.map((menuItem) => menuItem['menuName']).join(', ')}'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    if (item.distance != null)                // 거리 정보 표시
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: "나와의 거리: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text:
                                                    '${item.distance!.toStringAsFixed(2)} km'),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.star : Icons.star_border,
                                    color: isFavorite ? Colors.yellow : null,
                                  ),
                                  onPressed: () => _toggleFavorite(item),      // 즐겨찾기 토글
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/restaurantInfo',
                                    arguments: item.id, // Pass the ID
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: reservationBottom(),                                 // 예약 하단바 포함
    );
  }
}
