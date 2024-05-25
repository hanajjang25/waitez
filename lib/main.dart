import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:waitez/MenuRegList.dart';
import 'package:waitez/UserReservation.dart';
import 'firebase_options.dart';
import 'linkPage.dart';
import 'MemberLogin.dart';
import 'UserSignUp.dart';
import 'MemberInfo.dart';
import 'MemberFindPwd.dart';
import 'MemberFindPwdEmail.dart';
import 'RestaurantReg.dart';
import 'RestaurantInfo.dart';
import 'UserwaitingNumber.dart';
import 'UserSearch.dart';
import 'UserHome.dart';
import 'StaffHome.dart';
import 'MemberFavorite.dart';
import 'MemberFavoriteSearch.dart';
import 'RestaurantEdit.dart';
import 'MenuRegOne.dart';
import 'MenuRegList.dart';
import 'UserCart.dart';
import 'UserReservation.dart';
import 'UserReservationMenu.dart';
import 'MemberCommunity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => login(),
        '/signup': (context) => SignUp(),
        '/memberInfo': (context) => memberInfo(),
        '/findPassword': (context) => findPassword(),
        '/findPassword_email': (context) => findPassword_email(),
        '/regRestaurant': (context) => regRestaurant(),
        '/waitingNumber': (context) => waitingNumber(),
        '/restaurantInfo': (context) => RestaurantInfo(),
        '/search': (context) => search(),
        '/home': (context) => home(),
        '/homeStaff': (context) => homeStaff(),
        '/favorite': (context) => favorite(),
        '/favoriteSearch': (context) => favoriteSearch(),
        '/editRestaurant': (context) => editregRestaurant(),
        '/MenuRegList': (context) => MenuRegList(),
        '/cart': (context) => Cart(),
        '/reservation': (context) => Reservation(),
        '/reservationMenu': (context) => ReservationMenu(),
        '/community': (context) => CommunityMainPage(),
      },
    );
  }
}
