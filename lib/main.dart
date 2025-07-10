import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/account_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/cart_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/search.dart';
import 'package:project_mobile/pages/home/HomePage/coffee_page_body.dart';
import 'package:project_mobile/pages/home/HomePage/home_page.dart';
import 'package:project_mobile/pages/home/MainPage/main_page.dart';
import 'pages/home/BottomNavigationBar/message_page.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  static  List<Widget> _pages = <Widget>[
    MessageScreen(),
    SearchPage(),
    CoffeePageBody(),
    CartPage(),
    AccountPage(),
  ];
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    /*// Lấy thông tin về màn hình
    var screenSize = MediaQuery.of(context).size;
    // Chiều cao của màn hình
    double screenHeight = screenSize.height;
      //Chiều rộng của màn hình
    double screenWidth = screenSize.width;
    // In ra chiều cao của màn hình vào console
    print('Screen Height: $screenHeight');
    print('Screen Width: $screenWidth');*/
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Mainpage(),

    );
  }
}
