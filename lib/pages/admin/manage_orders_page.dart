import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageOrdersPage extends StatelessWidget {
  const ManageOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý đơn hàng')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Đơn hàng #${order.id}'),
                subtitle: Text('Người mua: ${order['userName']}\nTổng tiền: ${order['totalPrice']}đ'),
                trailing: DropdownButton<String>(
                  value: order['status'],
                  items: ['Chờ xử lý', 'Đang giao', 'Hoàn tất', 'Đã hủy']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (newStatus) {
                    FirebaseFirestore.instance.collection('orders').doc(order.id).update({
                      'status': newStatus,
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
