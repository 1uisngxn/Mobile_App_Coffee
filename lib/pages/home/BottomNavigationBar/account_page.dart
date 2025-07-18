import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/edit_profile_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/order_history_page.dart';
import 'package:project_mobile/pages/home/login.dart';
import 'package:project_mobile/utils/colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      }
    } else {
      setState(() {
        userData = null;
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        backgroundColor: AppColors.veriPeri,
        foregroundColor: Colors.white,
      ),
      body: userData == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/meme.jpg'), // meme của bạn
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bạn chưa đăng nhập',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _goToLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.veriPeri,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text("Đăng nhập", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Avatar + tên
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData!['avatarUrl'] != null
                            ? NetworkImage(userData!['avatarUrl'])
                            : const AssetImage('assets/images/default_avatar.jpg')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData!['name'] ?? '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(userData!['email'] ?? '',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Thông tin
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text("Số điện thoại"),
                  subtitle: Text(userData!['phoneNumber'] ?? 'Chưa cập nhật'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Địa chỉ"),
                  subtitle: Text(userData!['address'] ?? 'Chưa cập nhật'),
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Chỉnh sửa thông tin cá nhân"),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(userData: userData!),
                      ),
                    );

                    if (result == true) {
                      fetchUserData();
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Lịch sử đơn hàng"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Đăng xuất"),
                  onTap: _logout,
                ),
              ],
            ),
    );
  }
}
