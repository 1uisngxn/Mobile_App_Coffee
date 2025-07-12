import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/data/user/user_model.dart';
import 'package:project_mobile/pages/home/payment/payment_page.dart';
import 'package:project_mobile/service/cart/cart_service.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/big_text.dart';

class CartPage extends StatelessWidget {
  final CartService _cartService = CartService();

  CartPage({super.key});

  double _calculateTotal(QuerySnapshot snapshot) {
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final price = double.tryParse(data['price'].toString()) ?? 0.0;
      final quantity = data['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  Future<UserModel?> _getCurrentUserModel() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: AppColors.mainColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _cartService.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Giỏ hàng trống."));
          }

          final cartItems = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final data = item.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Image.network(data['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(data['name']),
                      subtitle: Text("Số lượng: ${data['quantity']}"),
                      trailing: Text("${data['price']} đ"),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Tổng: ${_calculateTotal(snapshot.data!).toStringAsFixed(0)} đ",
                      color: AppColors.veriPeri,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final user = await _getCurrentUserModel();
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Không tìm thấy người dùng.")),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(user: user),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                      ),
                      child: const Text("Thanh toán"),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
