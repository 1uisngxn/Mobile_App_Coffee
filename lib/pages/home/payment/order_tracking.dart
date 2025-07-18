import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_mobile/pages/home/HomePage/home_page.dart';
import 'package:project_mobile/pages/home/MainPage/main_page.dart';

class OrderTrackingPage extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String orderId;

  const OrderTrackingPage({
    Key? key,
    required this.orderData,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Xử lý ngày đặt
    final createdAtRaw = orderData['createdAt'];
    DateTime? createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    }

    // Format ngày đặt
    String formattedDate = createdAt != null
        ? DateFormat('dd/MM/yyyy – HH:mm').format(createdAt)
        : 'Đang cập nhật...';

    final status = orderData['status'] ?? 'Đang xử lý';
    final totalPrice = (orderData['totalPrice'] ?? 0).toDouble();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Theo dõi đơn hàng'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              '🎉 Đặt hàng thành công!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.receipt_long, 'Mã đơn hàng', orderId),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, 'Ngày đặt', formattedDate),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.local_shipping_outlined, 'Trạng thái', status),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.attach_money,
              'Tổng tiền',
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Mainpage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Quay lại trang chủ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.brown),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
