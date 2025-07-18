import 'package:flutter/material.dart';
import 'package:project_mobile/pages/admin/manage_orders_page.dart';
import 'package:project_mobile/pages/admin/manage_products_page.dart';
import 'package:project_mobile/pages/admin/manage_users_page.dart';
import 'package:project_mobile/pages/admin/manage_voucher_page.dart';
import 'package:project_mobile/pages/home/login.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<void> _addMissingDescriptions() async {
    final firestore = FirebaseFirestore.instance;
    final productsSnapshot = await firestore.collection('products').get();

    for (var doc in productsSnapshot.docs) {
      final data = doc.data();
      if (!data.containsKey('description')) {
        await firestore.collection('products').doc(doc.id).update({
          'description': 'Chưa có mô tả sản phẩm',
        });
        debugPrint('✅ Đã thêm mô tả cho: ${doc.id}');
      } else {
        debugPrint('⏭️ Đã có mô tả cho: ${doc.id}');
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật mô tả cho sản phẩm thiếu')),
      );
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang Quản Trị", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.veriPeri,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Đăng xuất',
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: ListView(
          children: [
            _buildAdminCard(
              context,
              title: "Quản lý người dùng",
              subtitle: "Xem và cập nhật thông tin người dùng",
              icon: Icons.person,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageUsersPage()),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            _buildAdminCard(
              context,
              title: "Quản lý sản phẩm",
              subtitle: "Thêm, sửa và xóa sản phẩm",
              icon: Icons.coffee,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageProductsPage()),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            _buildAdminCard(
              context,
              title: "Quản lý đơn hàng",
              subtitle: "Theo dõi và cập nhật trạng thái đơn hàng",
              icon: Icons.receipt_long,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageOrdersPage()),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            _buildAdminCard(
              context,
              title: "Quản lý mã giảm giá",
              subtitle: "Tạo và kích hoạt mã voucher",
              icon: Icons.discount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageVouchersPage()),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            _buildAdminCard(
              context,
              title: "Cập nhật mô tả thiếu",
              subtitle: "Thêm mô tả cho sản phẩm chưa có",
              icon: Icons.update,
              onTap: _addMissingDescriptions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.width20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppColors.mainColor),
            SizedBox(width: Dimensions.width20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
