import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/pages/admin/admin_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/account_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/cart_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/message_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/search.dart';
import 'package:project_mobile/pages/home/HomePage/home_page.dart';
import 'package:project_mobile/utils/colors.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  bool _isLoading = true;
  String? _userRole;
  int _selectedIndex = 2;

  final List<Widget> _userWidgets = [
    MessageScreen(),
    SearchPage(),
    const HomePage(),
    CartPage(),
    const AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = snapshot.data()?['role'] ?? 'user';

      setState(() {
        _userRole = role;
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi lấy vai trò người dùng: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Nếu là admin thì trả về admin page
    if (_userRole == 'admin') {
      return const AdminPage();
    }

    // Nếu là user thì dùng giao diện với BottomNavigationBar
    return Scaffold(
      body: _userWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.veriPeri,
        unselectedItemColor: Colors.black26,
        showUnselectedLabels: true,
        items: const [
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
      ),
    );
  }
}
