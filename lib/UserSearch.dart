import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reservationBottom.dart';
import 'MemberFavorite.dart';
import 'RestaurantInfo.dart';
import 'googleMap.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _SearchState();
}

class SearchDetails {
  final String id;
  final String name;
  final String address;
  final String description;
  final String businessHours;
  final String photoUrl;
  late List<Map<String, dynamic>> menuItems;

  SearchDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.businessHours,
    required this.photoUrl,
    required this.menuItems,
  });

  factory SearchDetails.fromFirestore(DocumentSnapshot doc) {
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

class _SearchState extends State<search> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('restaurants');
  List<SearchDetails> allItems = [];
  List<SearchDetails> filteredItems = [];
  String? _locationKeyword;
  String? _searchKeyword;
  String? _currentLocation;

  @override
  void initState() {
    super.initState();
    _fetchAllItems();
    _fetchUserLocation();
  }

  Future<void> _fetchAllItems() async {
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

      setState(() {
        allItems = results;
        filteredItems = results;
      });
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _fetchUserLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        final nonMemberDoc = await FirebaseFirestore.instance
            .collection('nonmembers')
            .doc(user.uid)
            .get();

        if (nonMemberDoc.exists) {
          final nonMemberData = nonMemberDoc.data();
          setState(() {
            _currentLocation = nonMemberData?['location'] ?? 'Location not set';
          });
        } else {
          setState(() {
            _currentLocation = 'Location not found';
          });
        }
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          setState(() {
            _currentLocation = userData?['location'] ?? 'Location not set';
          });
        } else {
          setState(() {
            _currentLocation = 'Location not found';
          });
        }
      }
    } else {
      setState(() {
        _currentLocation = 'User not logged in';
      });
    }
  }

  void _filterItems() {
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

      results.sort((a, b) => a.address.compareTo(b.address));
    }

    setState(() {
      filteredItems = results;
    });
  }

  void _updateLocation(String location) {
    _locationKeyword = location;
    _filterItems();
  }

  void _updateSearch(String search) {
    _searchKeyword = search;
    _filterItems();
  }

  Future<void> _toggleFavorite(SearchDetails item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userFavoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final favoriteDoc = userFavoritesRef.doc(item.id);

      final favoriteSnapshot = await favoriteDoc.get();

      if (favoriteSnapshot.exists) {
        await favoriteDoc.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('즐겨찾기가 해제되었습니다.')),
        );
      } else {
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

      setState(() {});
    }
  }

  Future<bool> _isFavorite(SearchDetails item) async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
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
        padding: const EdgeInsets.all(16),
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
            SizedBox(height: 20),
            TextField(
              onChanged: (value) => _updateSearch(value),
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
              child: filteredItems.isEmpty
                  ? Center(child: Text('해당하는 음식점 또는 메뉴가 존재하지 않습니다'))
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        var item = filteredItems[index];
                        return FutureBuilder<bool>(
                          future: _isFavorite(item),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            final isFavorite = snapshot.data ?? false;

                            return Card(
                              color: Colors.blue[50],
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.network(
                                  item.photoUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(item.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Address: ${item.address}"),
                                    Text("Description: ${item.description}"),
                                    Text(
                                        "Business Hours: ${item.businessHours}"),
                                    Text(
                                        "Menu: ${item.menuItems.map((menuItem) => menuItem['menuName']).join(', ')}"),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.star : Icons.star_border,
                                    color: isFavorite ? Colors.yellow : null,
                                  ),
                                  onPressed: () => _toggleFavorite(item),
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
      bottomNavigationBar: reservationBottom(),
    );
  }
}
