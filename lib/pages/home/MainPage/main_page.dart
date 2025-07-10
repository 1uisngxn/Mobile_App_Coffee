import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/account_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/cart_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/message_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/search.dart';
import 'package:project_mobile/pages/home/HomePage/home_page.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/cart_page.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    MessageScreen(),
    SearchPage(),
    HomePage(),
    CartPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            child:
            _widgetOptions.elementAt(_selectedIndex),
          ),
            bottomNavigationBar:BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Message',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor:  AppColors.veriPeri,
              onTap: _onItemTapped,
              unselectedItemColor: Colors.black26,
              showUnselectedLabels: true,
            )
        ));
  }
}
