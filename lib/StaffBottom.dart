import 'package:flutter/material.dart';
import 'RestaurantEdit.dart';

class staffButtom extends StatelessWidget {
  const staffButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 13, // 선택된 아이템과 비선택된 아이템의 텍스트 크기를 같게
      unselectedFontSize: 13,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/regRestaurant');
            break;
          case 1:
            Navigator.pushNamed(context, '/MenuRegList');
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => editregRestaurant(),
              ),
            );
            break;
          case 3:
            Navigator.pushNamed(context, '/menuEdit');
            break;
          case 4:
            Navigator.pushNamed(context, '/staffProfile');
            break;
          default:
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '음식점 등록'),
        BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: '메뉴 등록'),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: '음식점 수정'),
        BottomNavigationBarItem(icon: Icon(Icons.local_dining), label: '메뉴 수정'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '프로필'),
      ],
    );
  }
}
