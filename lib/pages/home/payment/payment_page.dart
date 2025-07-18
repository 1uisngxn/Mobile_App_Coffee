// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/data/user/user_model.dart';
import 'package:project_mobile/pages/home/payment/order_tracking.dart';
import 'package:project_mobile/pages/home/payment/discount_page.dart';
import 'package:project_mobile/pages/home/payment/momo_payment_page.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/service/email_service.dart';

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
  int _shippingFee = 15000;
  double _discount = 0;
  String _paymentMethod = 'COD';
  String? _voucherId;
  String? _voucherDescription;

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
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    setState(() {
      cartItems = snapshot.docs.map((doc) => doc.data()).toList();
      _loading = false;
    });
  }

  int _parsePrice(dynamic rawPrice) {
    if (rawPrice == null) return 0;
    if (rawPrice is int) return rawPrice;
    if (rawPrice is double) return rawPrice.toInt();
    if (rawPrice is String) {
      final replaced = rawPrice.replaceAll(',', '');
      final price = double.tryParse(replaced);
      return price != null ? (price * 1).round() : 0;
    }
    return 0;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String formatCurrency(int amount) {
    return "${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ";
  }

  int _calculateSubtotal() {
    int total = 0;
    for (var item in cartItems) {
      final price = _parsePrice(item['price']);
      final quantity = _toInt(item['quantity']);
      total += price * quantity;
    }
    return total;
  }

  int _calculateTotal() {
    int subtotal = _calculateSubtotal();
    int total = subtotal + _shippingFee - _discount.toInt();
    return total < 0 ? 0 : total;
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
      'shippingFee': _shippingFee,
      'discount': _discount.toInt(),
      'voucherId': _voucherId,
      'voucherDescription': _voucherDescription,
      'totalPrice': _calculateTotal(),
      'paymentMethod': _paymentMethod,
      'createdAt':  DateTime.now(),
      'status': 'Chờ xử lý',
    };

    try {
      final docRef =
          await FirebaseFirestore.instance.collection('orders').add(orderData);

      await EmailService.sendOrderConfirmationEmail(
        customerEmail:
            FirebaseAuth.instance.currentUser?.email ?? 'guest@example.com',
        customerName: nameController.text,
        orderId: docRef.id,
        totalPrice: _calculateTotal().toDouble(),
      );

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart');

      final items = await cartRef.get();
      for (var doc in items.docs) {
        await doc.reference.delete();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderTrackingPage(
            orderData: orderData,
            orderId: docRef.id, 
          ),
        ),
      );
    } catch (e) {
      print("❌ Lỗi khi tạo đơn hàng: $e");
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
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Tên")),
            TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Địa chỉ")),
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Số điện thoại")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy")),
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

  void _selectVoucher() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DiscountPage(subtotal: _calculateSubtotal().toDouble()),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final amountRaw = result['discountAmount'];
      final double amount =
          amountRaw is num ? amountRaw.toDouble() : 0.0;

      final String? voucherId = result['voucherId']?.toString();
      final String? description = result['description']?.toString();

      print('✅ Voucher nhận được: $amount - $voucherId - $description');

      if (amount > 0) {
        setState(() {
          _discount = amount;
          _voucherId = voucherId;
          _voucherDescription = description;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã áp dụng mã: $description'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _discount = 0;
          _voucherId = null;
          _voucherDescription = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không áp dụng được mã giảm giá'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sản phẩm",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
            const SizedBox(height: 10),
            ...cartItems.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.network(item['imageUrl'],
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']),
                  subtitle: Text("Số lượng: ${item['quantity']}"),
                  trailing:
                      Text(formatCurrency(_parsePrice(item['price']))),
                )),
            const Divider(height: 30),
            Text("Thông tin nhận hàng",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
            Text("Tên: ${nameController.text}"),
            Text("Địa chỉ: ${addressController.text}"),
            Text("SĐT: ${phoneController.text}"),
            TextButton(onPressed: _editUserInfo, child: const Text("Chỉnh sửa")),
            const Divider(height: 30),
            Text("Chi tiết thanh toán",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
            _buildCostRow("Tạm tính", formatCurrency(_calculateSubtotal())),
            _buildCostRow("Phí giao hàng", formatCurrency(_shippingFee)),
            _buildCostRow("Giảm giá", "-${formatCurrency(_discount.toInt())}"),
            _buildCostRow("Tổng cộng", formatCurrency(_calculateTotal())),
            const Divider(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _selectVoucher,
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16)),
                    child: Text(
                      _voucherDescription != null
                          ? "Mã: $_voucherDescription"
                          : "Chọn mã giảm giá",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Phương thức thanh toán",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _paymentMethod,
                  items: const [
                    DropdownMenuItem(
                        value: 'COD',
                        child: Text('Thanh toán khi nhận hàng')),
                    DropdownMenuItem(
                        value: 'MoMo', child: Text('Thanh toán qua MoMo')),
                  ],
                  onChanged: (value) =>
                      setState(() => _paymentMethod = value ?? 'COD'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_paymentMethod == 'MoMo') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoMoPaymentPage(
                        totalPrice: _calculateTotal(),
                        onPaymentCompleted: _submitOrder,
                      ),
                    ),
                  );
                } else {
                  _submitOrder();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veriPeri,
                foregroundColor: AppColors.textColor_white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Xác nhận thanh toán"),
            ),
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
