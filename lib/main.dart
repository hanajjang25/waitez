import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'MemberProfile.dart';
import 'MenuEdit.dart';

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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/restaurantInfo':
            if (settings.arguments is String) {
              final String restaurantId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) =>
                    RestaurantInfo(restaurantId: restaurantId),
              );
            }
            return _errorRoute();
          //case '/menuEditDetail':
          //  if (settings.arguments is MenuEditDetailArguments) {
          //    final MenuEditDetailArguments args =
          //        settings.arguments as MenuEditDetailArguments;
          //    return MaterialPageRoute(
          //      builder: (context) =>
          //         MenuEditDetail(menuItemId: args.menuItemId),
          //    );
          //  }
          //  return _errorRoute();
          default:
            return null;
        }
      },
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => login(),
        '/signup': (context) => SignUp(),
        '/memberInfo': (context) => memberInfo(),
        '/findPassword': (context) => findPassword(),
        '/findPassword_email': (context) => findPasswordEmail(),
        '/regRestaurant': (context) => regRestaurant(),
        '/waitingNumber': (context) => waitingNumber(),
        '/search': (context) => search(),
        '/home': (context) => home(),
        '/homeStaff': (context) => homeStaff(),
        '/favorite': (context) => favorite(),
        '/favoriteSearch': (context) => favoriteSearch(),
        '/editRestaurant': (context) => editregRestaurant(),
        '/MenuRegList': (context) => MenuRegList(),
        '/cart': (context) => Cart(),
        '/reservation': (context) => Reservation(),
        '/community': (context) => CommunityMainPage(),
        '/profile': (context) => Profile(),
        '/reservationMenu': (context) => UserReservationMenu(),
        '/menuEdit': (context) => MenuEdit(),
      },
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Page not found or invalid arguments.'),
        ),
      ),
    );
  }
}

class MenuEditDetailArguments {
  final String menuItemId;

  MenuEditDetailArguments(this.menuItemId);
}
