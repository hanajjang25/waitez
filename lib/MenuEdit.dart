import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MenuEditDetail.dart';

class MenuEdit extends StatefulWidget {
  @override
  _MenuEditState createState() => _MenuEditState();
}

class _MenuEditState extends State<MenuEdit> {
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
        title: Text('메뉴 수정'),
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
            return Column(children: [
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
                      subtitle: Text('가격: ${menuItem.price}원'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MenuEditDetail(menuItemId: menuItem.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ]);
          }
        },
      ),
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final int price;
  final String description;
  final String origin;
  final String photoUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.origin,
    required this.photoUrl,
  });

  factory MenuItem.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return MenuItem(
      id: document.id,
      name: data['menuName'] ?? '',
      price: data['price'] ?? 0,
      description: data['description'] ?? '',
      origin: data['origin'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}
