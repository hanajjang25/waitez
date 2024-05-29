import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MenuRegOne.dart';

class MenuRegList extends StatefulWidget {
  @override
  _MenuRegListState createState() => _MenuRegListState();
}

class _MenuRegListState extends State<MenuRegList> {
  late Future<List<MenuItem>> _menuItemsFuture;

  @override
  void initState() {
    super.initState();
    _menuItemsFuture = _loadMenuItems();
  }

  Future<List<MenuItem>> _loadMenuItems() async {
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
              .map((menuDoc) => MenuItem.fromDocument(menuDoc))
              .toList();

          return menuItems;
        }
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴 정보'),
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _menuItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('등록된 메뉴가 없습니다.'));
          } else {
            final menuItems = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '검색',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final menuItem = menuItems[index];
                      return ListTile(
                        leading: Icon(Icons.fastfood),
                        title: Text(menuItem.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('가격: ${menuItem.price}원'),
                            Text('설명: ${menuItem.description}'),
                            Text('원산지: ${menuItem.origin}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            // 메뉴 아이템 제거 로직
                            // 여기에 해당하는 구현을 추가하세요
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // 메뉴 등록 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuRegOne(
                              onSave: (menuItem) {
                                // 새로운 메뉴 아이템 추가 로직
                                // 여기에 해당하는 구현을 추가하세요
                              },
                            ),
                          ),
                        );
                      },
                      child: Text('+'),
                    ),
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

class MenuItem {
  final String name;
  final int price;
  final String description;
  final String origin;

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.origin,
  });

  factory MenuItem.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return MenuItem(
      name: data['menuName'] ?? '',
      price: data['price'] ?? 0,
      description: data['description'] ?? '',
      origin: data['origin'] ?? '',
    );
  }
}
