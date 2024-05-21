import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'UserBottom.dart';
import '_noRestaurantDetail.dart';

import 'package:flutter/material.dart';

// 별 표시
class starButton extends StatefulWidget {
  const starButton({super.key});

  @override
  State<starButton> createState() => _starButtonState();
}

// 노랑일 때 별 클릭 시 흰색, 흰색일 때 별 클릭 시 노랑
class _starButtonState extends State<starButton> {
  bool _isStarred = false;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isStarred = !_isStarred; // Toggle the state
        });
      },
      child: Container(
        width: 15,
        height: 15,
        decoration: ShapeDecoration(
          color:
              _isStarred ? Colors.yellow : Colors.white, // Conditional coloring
          shape: StarBorder(
            side: BorderSide(
                width: 1, color: Colors.black), // Ensure the border is visible
            points: 5,
            innerRadiusRatio: 0.38,
            pointRounding: 0,
            valleyRounding: 0,
            rotation: 0,
            squash: 0,
          ),
        ),
      ),
    );
  }
}

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
    favoriteDetails("마라마라탕탕", "강원특별자치도 단계동 100-001 1층", "마라탕, 마라샹궈, 탕후루"),
    favoriteDetails(
        "김밥마리", "강원특별자치도 원주시 북원로 2234-56 1층 106호", "참치김밥, 야채김밥, 돈까스 김밥"),
    favoriteDetails(
        "샐러리드", "강원특별자치도 원줏, 단구동 1001-104 3층", "삼겹웜볼, 삼겹소바 포케, 그린 샐러드"),
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
                    //Navigator.push(
                    //context,
                    //MaterialPageRoute(
                    // builder: (context) =>
                    //      restaurantDetailPage(restaurant: item),
                    //),
                    //);
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
