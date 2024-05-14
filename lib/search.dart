import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'menu_bottom.dart';

class search extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<search> {
  List<String> allItems = [
    "마라마라탕탕",
    "Kanpachi Nigiri",
    "Another Item"
  ]; // 예제 아이템 리스트
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems; // 초기에 모든 아이템을 표시
  }

  void _filterItems(String enteredKeyword) {
    List<String> results = [];
    if (enteredKeyword.isEmpty) {
      results = allItems;
    } else {
      results = allItems
          .where((item) =>
              item.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          title: Text(
            'waitez',
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
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 390,
                        height: 72,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: TextField(
                          onChanged: (value) => _filterItems(value),
                          decoration: InputDecoration(
                            hintText: "검색",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color(0xFFEDEFF2),
                          ),
                        ),
                      ),
                    ),
                    ...filteredItems
                        .map((item) => ListTile(title: Text(item)))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }
}
