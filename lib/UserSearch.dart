import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'UserBottom.dart'; // Assume this widget exists
import '_noRestaurantDetail.dart'; // Assume this widget exists
import 'MemberFavorite.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _SearchState();
}

class searchDetails {
  final String name;
  final String address;
  final String description;
  final String businessHours;
  final String photoUrl;

  searchDetails({
    required this.name,
    required this.address,
    required this.description,
    required this.businessHours,
    required this.photoUrl,
  });
}

class _SearchState extends State<search> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('restaurants');
  List<searchDetails> allItems = [];
  List<searchDetails> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _fetchAllItems();
  }

  Future<void> _fetchAllItems() async {
    try {
      DataSnapshot snapshot =
          await _database.once().then((event) => event.snapshot);
      List<searchDetails> results = [];
      for (var child in snapshot.children) {
        var data = child.value as Map;
        var restaurant = searchDetails(
          name: data['restaurantName'],
          address: data['location'],
          description: data['description'],
          businessHours: data['businessHours'],
          photoUrl: data['photoUrl'],
        );
        results.add(restaurant);
      }
      setState(() {
        allItems = results;
        filteredItems = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다.')),
      );
    }
  }

  void _filterItems(String enteredKeyword) {
    List<searchDetails> results = [];
    if (enteredKeyword.isEmpty) {
      results = allItems;
    } else {
      results = allItems
          .where((item) =>
              item.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredItems = results;
    });
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
          children: [
            TextField(
              onChanged: (value) => _filterItems(value),
              decoration: InputDecoration(
                hintText: "Search by Restaurant Name",
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
                      trailing: starButton(), // Assume this widget exists
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => restaurantDetailPage(
                                restaurant: item), // Assume this widget exists
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          menuButtom(), // Bottom navigation bar, assume this widget exists
    );
  }
}
