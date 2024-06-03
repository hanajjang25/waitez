import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserBottom.dart'; // Assume this widget exists
import 'MemberFavorite.dart';
import 'RestaurantInfo.dart';

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

  SearchDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.businessHours,
    required this.photoUrl,
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

  @override
  void initState() {
    super.initState();
    _fetchAllItems();
  }

  Future<void> _fetchAllItems() async {
    try {
      QuerySnapshot querySnapshot =
          await _collectionRef.where('isDeleted', isEqualTo: false).get();
      List<SearchDetails> results = querySnapshot.docs
          .map((doc) => SearchDetails.fromFirestore(doc))
          .toList();

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

  void _filterItems() {
    List<SearchDetails> results = allItems;

    if (_searchKeyword != null && _searchKeyword!.isNotEmpty) {
      results = results.where((item) {
        return item.name
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()) ||
            item.description
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase());
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
        title: Text('Search'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(children: [
              Container(
                height: 20,
                child: Icon(Icons.location_on),
              ),
              SizedBox(width: 15),
              Container(
                width: 200,
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  onChanged: (value) => _updateLocation(value),
                  decoration: InputDecoration(
                    hintText: 'ex) 서울시 강남구 삼성동',
                  ),
                ),
              ),
            ]),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) => _updateSearch(value),
              decoration: InputDecoration(
                hintText: "Search by Restaurant Name or Description",
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
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  var item = filteredItems[index];
                  return FutureBuilder<bool>(
                    future: _isFavorite(item),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final isFavorite = snapshot.data ?? false;

                      return Card(
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
                              Text("Business Hours: ${item.businessHours}"),
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
    );
  }
}
