import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'menu_bottom.dart';
import 'favorite_star.dart'; // 즐겨찾기 별표시 위젯이 있다고 가정
import 'restaurantDetailPage.dart';

class favorite extends StatefulWidget {
  const favorite({super.key});

  @override
  State<favorite> createState() => _FavoriteState();
}

class favoriteDetails {
  final String name;
  final String rating;
  final String description;

  favoriteDetails(this.name, this.rating, this.description);
}

class _FavoriteState extends State<favorite> {
  final List<favoriteDetails> allItems = [
    favoriteDetails("마라마라탕탕", "4.5", "Chinese · 146th St"),
    favoriteDetails("Kanpachi Nigiri", "4.9", "Japanese · Downtown"),
    favoriteDetails("The Progress", "4.8", "American · Fillmore"),
  ];
  List<favoriteDetails> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }

  void _filterItems(String enteredKeyword) {
    List<favoriteDetails> results = [];
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
        title: Text('Favorites'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _filterItems(value),
              decoration: InputDecoration(
                hintText: "Search Favorites",
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                var item = filteredItems[index];
                return ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text(item.name),
                  subtitle: Text("${item.rating}, ${item.description}"),
                  trailing: starButton(), // 별 버튼 위젯
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            restaurantDetailPage(restaurant: item),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuButtom(), // 하단 네비게이션 바
    );
  }
}
