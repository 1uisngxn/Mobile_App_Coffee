import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/data/user/user_model.dart';
import 'package:project_mobile/pages/home/payment/order_tracking.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatefulWidget {
  final UserModel user;

  const PaymentPage({super.key, required this.user});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;

  List<Map<String, dynamic>> cartItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    addressController = TextEditingController(text: widget.user.address);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(uid)
        .collection('items')
        .get();

    setState(() {
      cartItems = snapshot.docs.map((doc) => doc.data()).toList();
      _loading = false;
    });
  }

  int _calculateTotal() {
    int total = 0;
    for (var item in cartItems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }
    return total + 15000; // Phí ship cố định
  }

  Future<void> _submitOrder() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final orderData = {
      'userId': uid,
      'name': nameController.text,
      'address': addressController.text,
      'phoneNumber': phoneController.text,
      'items': cartItems,
      'shippingFee': 15000,
      'totalPrice': _calculateTotal(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('orders')
          .add(orderData);

      // Xóa giỏ hàng
      final cartRef = FirebaseFirestore.instance
          .collection('carts')
          .doc(uid)
          .collection('items');
      final items = await cartRef.get();
      for (var doc in items.docs) {
        await doc.reference.delete();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderTrackingPage(
            orderId: docRef.id,
            quantity: cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int)),
          ),
        ),
      );
    } catch (e) {
      print("Lỗi khi tạo đơn hàng: $e");
    }
  }

  void _editUserInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chỉnh sửa thông tin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Tên")),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Địa chỉ")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Số điện thoại")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Lưu")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sản phẩm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
            const SizedBox(height: 10),
            ...cartItems.map((item) => ListTile(
                  leading: Image.network(item['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']),
                  subtitle: Text("Số lượng: ${item['quantity']}"),
                  trailing: Text("${(item['price'] as int).toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ"),
                )),
            const Divider(height: 30),
            Text("Thông tin nhận hàng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
            Text("Tên: ${nameController.text}"),
            Text("Địa chỉ: ${addressController.text}"),
            Text("SĐT: ${phoneController.text}"),
            TextButton(onPressed: _editUserInfo, child: const Text("Chỉnh sửa")),
            const Divider(height: 30),
            Text("Chi tiết thanh toán", style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
            _buildCostRow("Tạm tính", "${_calculateTotal() - 15000}đ"),
            _buildCostRow("Phí giao hàng", "15,000đ"),
            _buildCostRow("Tổng cộng", "${_calculateTotal()}đ"),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veriPeri,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Xác nhận thanh toán"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
