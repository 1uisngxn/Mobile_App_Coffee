import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String orderId;

  const OrderDetailPage({Key? key, required this.orderData, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createdAt = (orderData['createdAt'] as Timestamp).toDate();
    final dateStr = "${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}";

    final items = orderData['items'] as List<dynamic>;
    final address = orderData['address'] ?? 'Không có';
    final phone = orderData['phoneNumber'] ?? 'Không có';
    final payment = orderData['paymentMethod'] ?? 'Không rõ';
    final status = orderData['status'] ?? 'Đang xử lý';
    final shippingFee = orderData['shippingFee'] ?? 0;
    final discount = orderData['discount'] ?? 0;
    final total = orderData['totalPrice'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Mã đơn hàng: #${orderId.substring(0, 10)}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Ngày đặt: $dateStr"),
            Text("Trạng thái: $status"),
            Text("Phương thức thanh toán: $payment"),
            Text("Địa chỉ giao hàng: $address"),
            Text("Số điện thoại: $phone"),
            const SizedBox(height: 16),

            const Text("Danh sách sản phẩm:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            ...items.map((item) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Image.network(item['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']),
                  subtitle: Text("Số lượng: ${item['quantity']}"),
                  trailing: Text("${item['price']} VND"),
                ),
              );
            }).toList(),

            const Divider(height: 32),

            Text("Phí vận chuyển: $shippingFee VND"),
            Text("Giảm giá: $discount VND"),
            Text("Tổng tiền thanh toán: $total VND", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
