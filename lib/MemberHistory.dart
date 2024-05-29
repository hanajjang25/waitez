import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final String restaurantName;
  final String date;
  final String imageAsset;
  final List<String> menuItems;

  History({
    required this.restaurantName,
    required this.date,
    required this.imageAsset,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이력조회'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(imageAsset),
            SizedBox(height: 10),
            Text(
              restaurantName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '주문내역:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(menuItems[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
