import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MenuEditDetail.dart' as detail; // MenuEditDetail 페이지를 detail로 가져옴
import 'menu_item.dart' as item; // MenuItem 클래스를 item으로 가져옴

class MenuEdit extends StatefulWidget {
  @override
  _MenuEditState createState() => _MenuEditState();
}

class _MenuEditState extends State<MenuEdit> {
  late Future<List<item.MenuItem>> _menuItemsFuture; // 메뉴 아이템 목록을 비동기로 로드하기 위한 Future
  List<item.MenuItem> _allMenuItems = []; // 모든 메뉴 아이템을 저장하는 리스트
  List<item.MenuItem> _filteredMenuItems = []; // 검색된 메뉴 아이템을 저장하는 리스트
  String? _searchKeyword; // 검색어를 저장하는 변수

  @override
  void initState() {
    super.initState();
    _menuItemsFuture = _loadMenuItems(); // 메뉴 아이템을 로드하는 Future 초기화
  }

  // Firestore에서 메뉴 아이템을 로드하는 함수
  Future<List<item.MenuItem>> _loadMenuItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDocSnapshot = await userDocRef.get();
      final resNum = userDocSnapshot.data()?['resNum'] as String?;

      if (resNum != null) {
        final restaurantQuery = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('registrationNumber', isEqualTo: resNum)
            .where('isDeleted', isEqualTo: false)
            .get();

        if (restaurantQuery.docs.isNotEmpty) {
          final restaurantId = restaurantQuery.docs.first.id;
          final menuItemsQuery = await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menus')
              .get();

          final menuItems = menuItemsQuery.docs
              .map((menuDoc) => item.MenuItem.fromDocument(menuDoc))
              .toList();

          setState(() {
            _allMenuItems = menuItems; // 모든 메뉴 아이템 저장
            _filteredMenuItems = menuItems; // 초기 필터링된 메뉴 아이템 리스트도 모든 메뉴로 설정
          });

          return menuItems;
        }
      }
    }
    return [];
  }

  // 검색어에 따라 메뉴 아이템을 필터링하는 함수
  void _filterItems() {
    List<item.MenuItem> results = _allMenuItems;
    if (_searchKeyword != null && _searchKeyword!.isNotEmpty) {
      results = results.where((item) {
        return item.name
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()) || // 메뉴 이름으로 검색
            item.description
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()); // 메뉴 설명으로 검색
      }).toList();
    }

    setState(() {
      _filteredMenuItems = results; // 필터링된 결과를 리스트에 저장
    });
  }

  // 검색어 업데이트 시 호출되는 함수
  void _updateSearch(String search) {
    setState(() {
      _searchKeyword = search; // 검색어 설정
      _filterItems(); // 검색어에 따라 필터링
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴 수정'), // 상단바 제목
      ),
      body: FutureBuilder<List<item.MenuItem>>(
        future: _menuItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 중 표시
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) => _updateSearch(value), // 검색어 변경 시 호출
                    decoration: InputDecoration(
                      hintText: '검색', // 검색어 입력 힌트
                      prefixIcon: Icon(Icons.search), // 검색 아이콘
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // 입력창 테두리
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('등록된 메뉴가 없습니다.'), // 메뉴가 없을 때 표시
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) => _updateSearch(value), // 검색어 변경 시 호출
                    decoration: InputDecoration(
                      hintText: '검색', // 검색어 입력 힌트
                      prefixIcon: Icon(Icons.search), // 검색 아이콘
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // 입력창 테두리
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredMenuItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: _filteredMenuItems.length, // 메뉴 아이템 수
                          itemBuilder: (context, index) {
                            final menuItem = _filteredMenuItems[index];
                            return ListTile(
                              leading: Icon(Icons.fastfood), // 메뉴 아이콘
                              title: Text(menuItem.name), // 메뉴 이름
                              subtitle: Text('가격: ${menuItem.price}원'), // 메뉴 가격
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => detail.MenuEditDetail(
                                        menuItemId: menuItem.id), // 메뉴 수정 상세 페이지로 이동
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text('해당하는 메뉴가 존재하지 않습니다.'), // 검색 결과가 없을 때 표시
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
