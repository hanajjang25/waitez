import 'package:flutter/material.dart';
import 'MenuRegOne.dart';
import 'MenuItem.dart';

class MenuRegList extends StatefulWidget {
  @override
  _MenuRegListState createState() => _MenuRegListState();
}

class _MenuRegListState extends State<MenuRegList> {
  final List<MenuItem> _menuItems = [];

  void _addMenuItem(MenuItem item) {
    setState(() {
      _menuItems.add(item);
    });
  }

  void _removeMenuItem(int index) {
    setState(() {
      _menuItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴 정보'),
      ),
      body: Column(
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
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.fastfood),
                  title: Text(_menuItems[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('가격: ${_menuItems[index].price}원'),
                      Text('설명: ${_menuItems[index].description}'),
                      Text('원산지: ${_menuItems[index].origin}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _removeMenuItem(index),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuRegOne(
                        onSave: _addMenuItem,
                      ),
                    ),
                  );
                },
                child: Text('+'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
