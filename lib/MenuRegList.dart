import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu_item.dart'; // Import the MenuItem class
import 'MenuRegOne.dart';

// 'MenuRegList'는 메뉴 리스트를 보여주는 화면을 정의하는 StatefulWidget
class MenuRegList extends StatefulWidget {
  @override
  _MenuRegListState createState() => _MenuRegListState();  // 이 위젯의 상태를 관리할 State 생성
}

// '_MenuRegListState'는 실제로 메뉴 리스트를 로드하고 필터링하며 화면에 표시하는 로직을 담당.
class _MenuRegListState extends State<MenuRegList> {
  late Future<List<MenuItem>> _menuItemsFuture;      // 메뉴 아이템을 비동기로 로드하기 위한 Future.
  List<MenuItem> _allMenuItems = [];                 // 모든 메뉴 아이템을 저장하는 리스트.
  List<MenuItem> _filteredMenuItems = [];            // 검색어에 따라 필터링된 메뉴 아이템을 저장하는 리스트.
  String? _searchKeyword;                            // 사용자가 입력한 검색어를 저장.

  @override
  void initState() {
    super.initState();
    _menuItemsFuture = _loadMenuItems();             // 위젯이 처음 생성될 때 메뉴 아이템을 로드하는 Future를 초기화.
  }

  // Firestore에서 메뉴 아이템을 비동기로 로드하는 메소드.
  Future<List<MenuItem>> _loadMenuItems() async {
    final user = FirebaseAuth.instance.currentUser;  // 현재 로그인된 사용자 정보를 가져옴.
    if (user != null) {      // 사용자가 로그인된 경우.
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);  // 'users' 컬렉션에서 현재 사용자의 문서 참조를 가져옴.
      final userDocSnapshot = await userDocRef.get();                    // 사용자 문서의 스냅샷을 비동기로 가져옴.
      final resNum = userDocSnapshot.data()?['resNum'] as String?;       // 문서에서 'resNum' 필드를 가져옴.

      if (resNum != null) {  // 'resNum'이 존재하는 경우
        final restaurantQuery = await FirebaseFirestore.instance
            .collection('restaurants')                // 'restaurants' 컬렉션에서
            .where('registrationNumber', isEqualTo: resNum)              // 'registrationNumber' 필드가 'resNum'과 일치하는 문서를 조회.
            .where('isDeleted', isEqualTo: false)     // 'isDeleted' 필드가 false인 문서만 조회.
            .get();          // 쿼리를 실행하고 결과를 가져옴.

        if (restaurantQuery.docs.isNotEmpty) { // 조회된 문서가 하나 이상 있는 경우.
          final restaurantId = restaurantQuery.docs.first.id; // 첫 번째 레스토랑의 ID를 가져옴.
          final menuItemsQuery = await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantId) // 위에서 가져온 레스토랑 ID에 해당하는 문서의 참조.
              .collection('menus') // 해당 레스토랑의 'menus' 컬렉션.
              .get(); // 메뉴 아이템들을 가져옴.

          final menuItems = menuItemsQuery.docs
              .map((menuDoc) => MenuItem.fromDocument(menuDoc)) // 문서 스냅샷을 MenuItem 객체로 변환.
              .toList(); // 리스트로 변환.

          setState(() {
            _allMenuItems = menuItems; // 모든 메뉴 아이템을 상태에 저장.
            _filteredMenuItems = menuItems; // 초기에는 필터링된 메뉴도 동일하게 설정.
          });

          return menuItems; // 로드된 메뉴 아이템 리스트를 반환.
        }
      }
    }
    return []; // 사용자나 'resNum'이 없거나, 해당하는 레스토랑이 없는 경우 빈 리스트 반환.
  }

  // 검색어에 따라 메뉴 아이템을 필터링하는 메소드.
  void _filterItems() {
    List<MenuItem> results = _allMenuItems; // 필터링할 기준 리스트를 모든 메뉴로 설정.
    if (_searchKeyword != null && _searchKeyword!.isNotEmpty) { // 검색어가 비어있지 않은 경우.
      results = results.where((item) { // 모든 메뉴를 순회하면서 조건에 맞는 항목을 필터링.
        return item.name
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()) || // 메뉴 이름이 검색어를 포함하거나
            item.description
                .toLowerCase()
                .contains(_searchKeyword!.toLowerCase()); // 메뉴 설명이 검색어를 포함하는지 확인.
      }).toList(); // 필터링된 결과를 리스트로 변환.
    }

    setState(() {
      _filteredMenuItems = results; // 필터링된 메뉴 리스트를 상태에 업데이트.
    });
  }

  // 검색어가 변경될 때 호출되는 메소드.
  void _updateSearch(String search) {
    setState(() {
      _searchKeyword = search; // 검색어 상태를 업데이트.
      _filterItems(); // 변경된 검색어로 메뉴 아이템을 필터링.
    });
  }

  // 특정 메뉴 아이템을 Firestore에서 삭제하는 메소드.
  Future<void> _deleteMenuItem(MenuItem menuItem) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 사용자 정보를 가져옴.
    if (user != null) { // 사용자가 로그인된 경우.
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid); // 사용자 문서 참조를 가져옴.
      final userDocSnapshot = await userDocRef.get(); // 사용자 문서의 스냅샷을 가져옴.
      final resNum = userDocSnapshot.data()?['resNum'] as String?; // 'resNum'을 가져옴.

      if (resNum != null) { // 'resNum'이 존재하는 경우.
        final restaurantQuery = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('registrationNumber', isEqualTo: resNum) // 해당 'resNum'에 해당하는 레스토랑을 찾음.
            .where('isDeleted', isEqualTo: false) // 삭제되지 않은 레스토랑.
            .get();

        if (restaurantQuery.docs.isNotEmpty) { // 레스토랑이 존재하는 경우.
          final restaurantId = restaurantQuery.docs.first.id; // 첫 번째 레스토랑 ID를 가져옴.
          final menuItemsQuery = await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menus')
              .where('menuName', isEqualTo: menuItem.name) // 삭제할 메뉴의 이름이 일치하는지 확인.
              .get();

          if (menuItemsQuery.docs.isNotEmpty) { // 해당하는 메뉴가 존재하는 경우.
            final menuItemId = menuItemsQuery.docs.first.id; // 첫 번째 메뉴 아이템 ID를 가져옴.
            await FirebaseFirestore.instance
                .collection('restaurants')
                .doc(restaurantId)
                .collection('menus')
                .doc(menuItemId)
                .delete(); // 해당 메뉴 아이템을 Firestore에서 삭제.

            setState(() {
              _allMenuItems.remove(menuItem); // 삭제된 메뉴를 모든 메뉴 리스트에서 제거.
              _filteredMenuItems.remove(menuItem); // 필터링된 메뉴 리스트에서도 제거.
            });

            // 삭제 성공 메시지를 화면에 표시.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('메뉴가 삭제되었습니다.')),
            );
          }
        }
      }
    }
  }

  // 위젯의 UI를 빌드하는 메소드.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴 정보'), // 앱 바의 제목을 설정.
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _menuItemsFuture, // 메뉴 아이템을 로드하는 Future를 전달.
        builder: (context, snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0), // 텍스트 필드 주변에 패딩을 추가.
                child: TextField(
                  onChanged: (value) => _updateSearch(value), // 텍스트 필드가 변경될 때 호출되는 콜백.
                  decoration: InputDecoration(
                    hintText: '검색', // 텍스트 필드의 힌트 텍스트.
                    prefixIcon: Icon(Icons.search), // 검색 아이콘을 텍스트 필드 앞에 추가.
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0), // 텍스트 필드의 경계선을 둥글게 설정.
                    ),
                  ),
                ),
              ),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting // 메뉴 아이템을 로드 중인 경우.
                    ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 로딩 스피너를 표시.
                    : _filteredMenuItems.isEmpty // 필터링된 메뉴가 없는 경우.
                        ? Center(child: Text('해당하는 메뉴가 존재하지 않습니다.')) // 메뉴가 없다는 메시지를 표시.
                        : ListView.builder(
                            itemCount: _filteredMenuItems.length, // 필터링된 메뉴의 개수.
                            itemBuilder: (context, index) {
                              final menuItem = _filteredMenuItems[index]; // 현재 인덱스에 해당하는 메뉴 아이템.
                              return ListTile(
                                leading: Icon(Icons.fastfood), // 메뉴 아이콘.
                                title: Text(menuItem.name), // 메뉴 이름을 제목으로 표시.
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽으로 정렬.
                                  children: [
                                    Text('가격: ${menuItem.price}원'), // 메뉴 가격을 표시.
                                    Text('설명: ${menuItem.description}'), // 메뉴 설명을 표시.
                                    Text('원산지: ${menuItem.origin}'), // 메뉴 원산지를 표시.
                                  ],
                                ),
                              );
                            },
                          ),
              ),
              SizedBox(
                height: 100, // 버튼을 포함하는 공간의 높이 설정.
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // 메뉴 등록 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuRegOne(
                            onSave: (menuItem) { // 새 메뉴를 등록한 후 호출되는 콜백.
                              setState(() {
                                _allMenuItems.add(menuItem); // 새 메뉴를 모든 메뉴 리스트에 추가.
                                _filteredMenuItems.add(menuItem); // 새 메뉴를 필터링된 메뉴 리스트에도 추가.
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('+'), // 버튼의 텍스트 설정.
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
