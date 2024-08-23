// menu_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// MenuItem 클래스 정의
class MenuItem {
  final String id;                                        // 메뉴 아이템의 고유 ID
  final String name;                                      // 메뉴 이름
  final int price;                                        // 메뉴 가격
  final String description;                               // 메뉴 설명
  final String origin;                                    // 메뉴 원산지
  final String photoUrl;                                  // 메뉴 사진 URL

  // MenuItem 클래스의 생성자
  MenuItem({
    required this.id,                                     // id 파라미터는 필수
    required this.name,                                   // name 파라미터는 필수
    required this.price,                                  // price 파라미터는 필수
    required this.description,                            // description 파라미터는 필수
    required this.origin,                                 // origin 파라미터는 필수
    required this.photoUrl,                               // photoUrl 파라미터는 필수
  });

  // Firestore 문서를 MenuItem 객체로 변환하는 팩토리 생성자
  factory MenuItem.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>; // 문서 데이터를 Map 형태로 변환
    return MenuItem(
      id: document.id,                                    // 문서의 ID를 MenuItem의 id로 설정
      name: data['menuName'] ?? '',                       // menuName 필드 값이 없으면 빈 문자열 사용
      price: data['price'] ?? 0,                          // price 필드 값이 없으면 0 사용
      description: data['description'] ?? '',             // description 필드 값이 없으면 빈 문자열 사용
      origin: data['origin'] ?? '',                       // origin 필드 값이 없으면 빈 문자열 사용
      photoUrl: data['photoUrl'] ?? '',                   // photoUrl 필드 값이 없으면 빈 문자열 사용
    );
  }

  // MenuItem 객체를 Map 형태로 변환하는 메서드 (Firestore에 저장할 때 사용)
  Map<String, dynamic> toMap() {
    return {
      'menuName': name,                                   // name 필드를 'menuName' 키로 매핑
      'price': price,                                     // price 필드를 'price' 키로 매핑
      'description': description,                         // description 필드를 'description' 키로 매핑
      'origin': origin,                                   // origin 필드를 'origin' 키로 매핑
      'photoUrl': photoUrl,                               // photoUrl 필드를 'photoUrl' 키로 매핑
    };
  }
}
