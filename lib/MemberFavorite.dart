import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserBottom.dart'; // Assume this widget exists

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

// 즐겨찾기 항목에 대한 세부 정보를 담은 클래스
class FavoriteDetails {
  final String id;
  final String name;
  final String address;
  final String description;

  FavoriteDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
  });

  // Firestore에서 데이터를 받아와 FavoriteDetails 인스턴스로 변환하는 팩토리 메서드
  factory FavoriteDetails.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteDetails(
      id: doc.id,
      name: data['name'],
      address: data['address'],
      description: data['description'],
    );
  }
}

class _FavoriteState extends State<Favorite> {
  List<FavoriteDetails> allItems = []; // 모든 즐겨찾기 항목을 저장하는 리스트
  List<FavoriteDetails> filteredItems = []; // 필터링된 즐겨찾기 항목을 저장하는 리스트
  User? user; // 현재 사용자 정보를 저장하는 변수

  @override
  void initState() {
    super.initState();
    _fetchFavorites(); // 즐겨찾기 데이터를 가져오는 함수 호출
  }

  // Firestore에서 즐겨찾기 항목을 가져오는 함수
  Future<void> _fetchFavorites() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .get();

      // Firestore에서 가져온 데이터를 FavoriteDetails 리스트로 변환
      List<FavoriteDetails> favorites = favoritesSnapshot.docs
          .map((doc) => FavoriteDetails.fromFirestore(doc))
          .toList();

      setState(() {
        allItems = favorites;
        filteredItems = favorites;
      });
    }
  }

  // 검색어에 따라 즐겨찾기 항목을 필터링하는 함수
  void _filterItems(String enteredKeyword) {
    List<FavoriteDetails> results = [];
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

  // 즐겨찾기에서 항목을 제거하는 함수
  Future<void> _removeFavorite(FavoriteDetails item) async {
    if (user != null) {
      final userFavoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favorites');

      final favoriteDoc = userFavoritesRef.doc(item.id);

      final favoriteSnapshot = await favoriteDoc.get();

      // 해당 즐겨찾기 항목이 존재할 경우 Firestore에서 삭제
      if (favoriteSnapshot.exists) {
        await favoriteDoc.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('즐겨찾기가 해제되었습니다.')),
        );
      }

      _fetchFavorites(); // 즐겨찾기 목록을 다시 가져옴
    }
  }

  // 항목이 즐겨찾기 목록에 있는지 확인하는 함수
  Future<bool> _isFavorite(FavoriteDetails item) async {
    if (user != null) {
      final favoriteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
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
          '즐겨찾기',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _filterItems(value), // 검색어 입력 시 필터링 함수 호출
              decoration: InputDecoration(
                hintText: "즐겨찾기 검색",
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
            // 필터링된 즐겨찾기 항목이 없을 때
            filteredItems.isEmpty
                ? Center(child: Text('즐겨찾기 한 음식점이 존재하지 않습니다'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      var item = filteredItems[index];
                      return FutureBuilder<bool>(
                        future: _isFavorite(item), // 항목이 즐겨찾기인지 확인
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // 로딩 중일 때 표시
                          }

                          final isFavorite = snapshot.data ?? false;

                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                                "${item.address}\n${item.description}"), // 주소와 설명 표시
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.yellow : null,
                              ),
                              onPressed: () => _removeFavorite(item), // 즐겨찾기 제거 버튼
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/restaurantInfo',
                                  arguments: item.id); // 항목 클릭 시 상세 페이지로 이동
                            },
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
