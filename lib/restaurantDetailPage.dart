import 'package:flutter/material.dart';
import 'package:waitez/favorite.dart';

class restaurantDetailPage extends StatelessWidget {
  final favoriteDetails restaurant;

  const restaurantDetailPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${restaurant.name}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Rating: ${restaurant.rating}",
                style: TextStyle(fontSize: 18)),
            Text("Description: ${restaurant.description}",
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
