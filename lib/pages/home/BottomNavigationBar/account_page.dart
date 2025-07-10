import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/message_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/search.dart';
import 'package:project_mobile/pages/home/HomePage/coffee_page_body.dart';
import 'package:project_mobile/pages/home/HomePage/home_page.dart';
import 'package:project_mobile/pages/home/MainPage/main_page.dart';
import 'package:project_mobile/pages/home/login.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/menu_option.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text('Cài đặt chung',style: TextStyle(color: AppColors.textColor_white),),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Info button action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15-5),
              ),
              margin: EdgeInsets.all(Dimensions.width15),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: Dimensions.radius30,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: Dimensions.font26, color: Colors.white),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    'NHƯ QUỲNH',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font26,
                    ),
                  ),
                  Text(
                    'Khách hàng',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      color: Colors.orange,
                      fontSize: Dimensions.font15,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Số dư tài khoản: 103,000đ',style: TextStyle(fontFamily: 'RobotoCondensed'),),
                          Text('Điểm tích lũy: 1200 điểm',style: TextStyle(fontFamily: 'RobotoCondensed'),),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.store),
                        onPressed: () {
                          // Store button action
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  ElevatedButton(
                    onPressed: () {
                      // Upgrade button action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                    ),
                    child: Text(
                      'Xếp hạng Vàng',
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed',color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            MenuOption(onPressed: (){},text: 'Đánh giá đơn hàng'),
            MenuOption(onPressed: (){},text: 'Lịch sử đặt hàng'),
            MenuOption(onPressed: (){},text: 'Đơn hàng đang giao'),
            MenuOption(
              text: 'ĐĂNG XUẤT',
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  );
                  },
            ),
          ],
        ),
      ),
     /* bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Product',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 11, 7, 233),
        onTap: _onItemTapped,
      ),*/
    );
  }
}

