import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/payment/order_review.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;
  final int quantity;

  const OrderTrackingPage({required this.orderId, required this.quantity});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  Map<String, dynamic>? orderData;

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  Future<void> _loadOrderData() async {
    final doc = await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get();
    if (doc.exists) {
      setState(() {
        orderData = doc.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orderData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theo dõi đơn hàng'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStatus(),
            SizedBox(height: Dimensions.height20),
            Text('Thông tin sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
            SizedBox(height: Dimensions.height10),
            ...List.generate((orderData!['items'] as List).length, (index) {
              final item = orderData!['items'][index];
              return _buildProductCard(item);
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderReviewPage(
                      items: (orderData!['items'] as List).map((e) => Map<String, dynamic>.from(e)).toList(),
                      shippingFee: orderData!['shippingFee'].toDouble(),
                      totalPrice: orderData!['totalPrice'].toDouble(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veriPeri,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('ĐÃ NHẬN HÀNG'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Row(
      children: [
        _buildStatusCircle('Xuất phát', true),
        const Expanded(child: Divider(thickness: 2, color: Colors.grey)),
        _buildStatusCircle('Đang giao', true),
        const Expanded(child: Divider(thickness: 2, color: Colors.grey)),
        _buildStatusCircle('Đã tới', false),
      ],
    );
  }

  Widget _buildStatusCircle(String text, bool isActive) {
    return Column(
      children: [
        CircleAvatar(radius: 15, backgroundColor: isActive ? Colors.green : Colors.grey),
        const SizedBox(height: 8),
        Text(text),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15)),
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.height10),
        child: Row(
          children: [
            Image.network(item['imageUrl'], width: 60, height: 60, fit: BoxFit.cover),
            SizedBox(width: Dimensions.width10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold)),
                  Text('Số lượng: ${item['quantity']}'),
                  Text('Giá: ${item['price']} đ'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
