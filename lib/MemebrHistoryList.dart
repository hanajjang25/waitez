import 'package:flutter/material.dart';
import 'package:waitez/UserBottom.dart';

class historyList extends StatefulWidget {
  @override
  _historyListState createState() => _historyListState();
}

class _historyListState extends State<historyList> {
  final List<Map<String, dynamic>> reservations = [
    {
      'restaurantPhoto': 'assets/images/malatang.png',
      'restaurantName': 'Restaurant 1',
      'timestamp': DateTime.now(),
      'menuItems': ['Item 1', 'Item 2']
    },
    {
      'restaurantPhoto': 'assets/images/malatang.png',
      'restaurantName': 'Restaurant 2',
      'timestamp': DateTime.now(),
      'menuItems': ['Item 3', 'Item 4']
    },
    // Add more reservations as needed
  ];

  String _searchQuery = '';

  String formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    final filteredReservations = reservations.where((reservation) {
      final restaurantName =
          reservation['restaurantName']?.toString().toLowerCase() ?? '';
      final searchQuery = _searchQuery.toLowerCase();
      return restaurantName.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '이력조회',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: '검색',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: filteredReservations.map((reservation) {
                  return ReservationCard(
                    imageAsset: reservation['restaurantPhoto'] ??
                        'assets/images/malatang.png',
                    restaurantName: reservation['restaurantName'] ?? 'Unknown',
                    date: formatDate(reservation['timestamp']),
                    buttonText: '자세히 보기',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailPage(
                            restaurantName:
                                reservation['restaurantName'] ?? 'Unknown',
                            date: formatDate(reservation['timestamp']),
                            imageAsset: reservation['restaurantPhoto'] ??
                                'assets/images/malatang.png',
                            menuItems: reservation['menuItems'] ?? [],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String imageAsset;
  final String restaurantName;
  final String date;
  final String buttonText;
  final VoidCallback onPressed;

  ReservationCard({
    required this.imageAsset,
    required this.restaurantName,
    required this.date,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(imageAsset),
        title: Text(restaurantName),
        subtitle: Text(date),
        trailing: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ),
    );
  }
}

class HistoryDetailPage extends StatelessWidget {
  final String restaurantName;
  final String date;
  final String imageAsset;
  final List<String> menuItems;

  HistoryDetailPage({
    required this.restaurantName,
    required this.date,
    required this.imageAsset,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurantName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(date),
            SizedBox(height: 10),
            Image.asset(imageAsset),
            SizedBox(height: 10),
            Text(
              'Menu Items:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...menuItems.map((item) => Text(item)).toList(),
          ],
        ),
      ),
    );
  }
}
