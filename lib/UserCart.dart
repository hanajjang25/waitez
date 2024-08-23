import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cart extends StatefulWidget {                                   // 장바구니 화면을 위한 StatefulWidget 클래스.
  @override
  _CartState createState() => _CartState();                           // 상태를 관리하는 _CartState 클래스 생성.
}

class _CartState extends State<cart> {
  List<Map<String, dynamic>> cartItems = [];                          // 장바구니 항목들을 저장할 리스트.
  String reservationId = '';                                          // 현재 예약 ID를 저장할 변수.

  @override
  void initState() {                                                  // 위젯이 처음 생성될 때 호출되는 메소드.
    super.initState();                                                // 부모 클래스의 initState 호출.
    _fetchUserAndReservationId();                                     // 사용자와 예약 ID를 가져오는 함수 호출.
  }

  Future<void> _fetchUserAndReservationId() async {                   // 사용자 정보와 예약 ID를 가져오는 비동기 함수.
    try {
      User? user = FirebaseAuth.instance.currentUser;                 // 현재 로그인된 사용자 정보를 가져옴.
      if (user != null) {
        String? nickname = await _fetchNickname(user.email!);         // 사용자의 이메일을 통해 닉네임을 가져옴.
        if (nickname != null) {
          await _fetchLatestReservationId(nickname);                  // 닉네임을 통해 가장 최근의 예약 ID를 가져옴.
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found with this email.')), // 사용자 이메일을 찾을 수 없는 경우의 알림 메시지.
          );
        }
      }
    } catch (e) {
      print('Error fetching user or reservation ID: $e');             // 오류 발생 시 콘솔에 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user or reservation ID: $e')), // 오류 알림 메시지 표시.
      );
    }
  }

  Future<String?> _fetchNickname(String email) async {                // 이메일을 통해 닉네임을 가져오는 함수.
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();                                                       // users 컬렉션에서 이메일로 사용자 검색.

    if (userQuery.docs.isNotEmpty) {                                  // 사용자 문서가 존재하면.
      return userQuery.docs.first['nickname'];                        // 닉네임 반환.
    } else {                                                          // 그렇지 않으면 non_member 컬렉션에서 검색.
      final nonMemberQuery = await FirebaseFirestore.instance
          .collection('non_member')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (nonMemberQuery.docs.isNotEmpty) {                           // non_member 문서가 존재하면.
        return nonMemberQuery.docs.first['nickname'];                 // 닉네임 반환.
      }
    }
    return null;                                                      // 닉네임이 없으면 null 반환.
  }

  Future<void> _fetchLatestReservationId(String nickname) async {     // 닉네임을 통해 가장 최근의 예약 ID를 가져오는 함수.
    final reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('nickname', isEqualTo: nickname)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();                                                       // 가장 최근의 예약을 가져옴.

    if (reservationQuery.docs.isNotEmpty) {                           // 예약 문서가 존재하면.
      final reservationDoc = reservationQuery.docs.first;             // 첫 번째 예약 문서를 가져옴.
      setState(() {
        reservationId = reservationDoc.id;                            // 예약 ID를 상태에 저장.
      });
      _fetchCartItems();                                              // 장바구니 항목을 가져오는 함수 호출.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No recent reservation found.')),       // 최근 예약이 없으면 알림 메시지 표시.
      );
    }
  }

  Future<void> _fetchCartItems() async {                              // 장바구니 항목을 가져오는 함수.
    if (reservationId.isNotEmpty) {
      try {
        final cartQuery = await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationId)
            .collection('cart')
            .get();                                                   // 예약 ID로 장바구니 항목들을 가져옴.

        setState(() {
          cartItems = cartQuery.docs
              .map((doc) =>
                  {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();                                              // 장바구니 항목들을 리스트에 저장.
        });
      } catch (e) {
        print('Error fetching cart items: $e');                       // 장바구니 항목을 가져오는 중 오류 발생 시 로그 출력.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching cart items: $e')),   // 오류 알림 메시지 표시.
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No reservation found to fetch cart items.')), // 예약이 없을 때 알림 메시지 표시.
      );
    }
  }

  Future<void> removeItem(int index) async {                          // 장바구니 항목을 제거하는 함수.
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .collection('cart')
          .doc(cartItems[index]['id'])
          .delete();                                                  // Firestore에서 해당 항목을 삭제.

      setState(() {
        cartItems.removeAt(index);                                    // 로컬 리스트에서도 해당 항목을 제거.
      });
    } catch (e) {
      print('Error removing cart item: $e');                          // 장바구니 항목 제거 중 오류 발생 시 로그 출력.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing cart item: $e')),      // 오류 알림 메시지 표시.
      );
    }
  }

  Future<void> updateQuantity(int index, int quantity) async {        // 장바구니 항목의 수량을 업데이트하는 함수.
    if (quantity > 0 && quantity <= 50) {                             // 수량이 1 이상 50 이하인 경우에만 업데이트.
      try {
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationId)
            .collection('cart')
            .doc(cartItems[index]['id'])
            .update({'quantity': quantity});                          // Firestore에서 수량 업데이트.

        setState(() {
          cartItems[index]['quantity'] = quantity;                    // 로컬 리스트에서도 수량 업데이트.
        });
      } catch (e) {
        print('Error updating cart item quantity: $e');               // 수량 업데이트 중 오류 발생 시 로그 출력.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating cart item quantity: $e')), // 오류 알림 메시지 표시.
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    int totalPrice = cartItems.fold(
        0,
        (sum, item) =>
            sum +
            ((item['menuItem']?['price'] ?? 0) as int) *
                ((item['quantity'] ?? 1) as int));                    // 총 금액 계산.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장바구니',                                                  // 앱바 제목 설정.
          style: TextStyle(
            color: Color(0xFF1C1C21),                                 // 텍스트 색상 설정.
            fontSize: 18,                                             // 텍스트 크기 설정.
            fontFamily: 'Epilogue',                                   // 폰트 설정.
            fontWeight: FontWeight.w700,                              // 텍스트 굵기 설정.
            height: 0.07,                                             // 텍스트 높이 설정.
            letterSpacing: -0.27,                                     // 자간 설정.
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),                          // 모든 방향에 16px 패딩 추가.
        child: Column(
          children: [
            SizedBox(height: 30),                                     // 상단에 30px 간격 추가.
            Expanded(
              child: cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: cartItems.length,                    // 장바구니 항목 수만큼 리스트뷰 생성.
                      itemBuilder: (context, index) {
                        final menuItem = cartItems[index]['menuItem']; // 현재 항목의 메뉴 아이템.
                        return CartItem(
                          name: menuItem != null
                              ? menuItem['menuName'] as String? ?? ''  // 메뉴 이름 설정.
                              : '',
                          price: menuItem != null
                              ? menuItem['price'] as int? ?? 0         // 메뉴 가격 설정.
                              : 0,
                          quantity: cartItems[index]['quantity'] as int? ?? 1, // 수량 설정.
                          photoUrl: menuItem != null
                              ? menuItem['photoUrl'] as String? ?? ''  // 메뉴 이미지 URL 설정.
                              : '',
                          onRemove: () => removeItem(index),           // 제거 버튼 클릭 시 호출되는 함수.
                          onQuantityChanged: (newQuantity) =>
                              updateQuantity(index, newQuantity),      // 수량 변경 시 호출되는 함수.
                        );
                      },
                    )
                  : Center(child: Text('장바구니에 아이템이 없습니다.')), // 장바구니가 비어 있을 때의 메시지.
            ),
            SizedBox(height: 16),                                     // 하단에 16px 간격 추가.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,       // 총 금액 표시와 함께 배치.
              children: [
                Text(
                  '총 금액',
                  style: TextStyle(
                    color: Color(0xFF1C1C21),                         // 텍스트 색상 설정.
                    fontSize: 18,                                     // 텍스트 크기 설정.
                    fontFamily: 'Epilogue',                           // 폰트 설정.
                    fontWeight: FontWeight.w700,                      // 텍스트 굵기 설정.
                    height: 0.07,                                     // 텍스트 높이 설정.
                    letterSpacing: -0.27,                             // 자간 설정.
                  ),
                ),
                Text('₩ $totalPrice', style: TextStyle(fontSize: 18)), // 총 금액 표시.
              ],
            ),
            SizedBox(height: 16),                                     // 하단에 16px 간격 추가.
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;                                                  // 메뉴 이름.
  final int price;                                                    // 메뉴 가격.
  final int quantity;                                                 // 수량.
  final String photoUrl;                                              // 메뉴 이미지 URL.
  final VoidCallback onRemove;                                        // 제거 버튼 클릭 시 호출되는 함수.
  final ValueChanged<int> onQuantityChanged;                          // 수량 변경 시 호출되는 함수.

  const CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.photoUrl,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),                   // 위아래로 10px 마진 추가.
      child: Padding(
        padding: const EdgeInsets.all(15.0),                          // 모든 방향에 15px 패딩 추가.
        child: Row(
          children: [
            Container(
              width: 50,                                              // 이미지 컨테이너 너비 설정.
              height: 50,                                             // 이미지 컨테이너 높이 설정.
              decoration: BoxDecoration(
                color: Colors.grey,                                   // 배경색 설정.
                image: photoUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(photoUrl),                // 이미지 URL이 있으면 네트워크 이미지로 설정.
                        fit: BoxFit.cover,                            // 이미지가 컨테이너를 덮도록 설정.
                      )
                    : null,
              ),
            ),
            SizedBox(width: 20),                                      // 이미지와 텍스트 사이에 20px 간격 추가.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,         // 텍스트를 왼쪽 정렬.
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 메뉴 이름 텍스트 스타일 설정.
                  Text('₩ $price',
                      style: TextStyle(fontSize: 14, color: Colors.grey)), // 메뉴 가격 텍스트 스타일 설정.
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),                           // 수량 감소 아이콘.
                  onPressed: () {
                    if (quantity > 1) {
                      onQuantityChanged(quantity - 1);                // 수량 감소 시 함수 호출.
                    }
                  },
                ),
                Text('$quantity', style: TextStyle(fontSize: 16)),    // 현재 수량 표시.
                IconButton(
                  icon: Icon(Icons.add),                              // 수량 증가 아이콘.
                  onPressed: quantity < 50
                      ? () {
                          onQuantityChanged(quantity + 1);            // 수량 증가 시 함수 호출.
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.close),                            // 제거 아이콘.
                  onPressed: onRemove,                                // 제거 버튼 클릭 시 함수 호출.
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
