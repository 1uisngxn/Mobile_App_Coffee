import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_mobile/data/product/order_review/order_model.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  String selectedStatus = 'Tất cả';
  String searchKeyword = '';
  final int pageSize = 10;
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;
  bool hasMore = true;
  final List<OrderModel> orders = [];

  final List<String> statusOptions = [
    'Tất cả',
    'Chờ xử lý',
    'Đang giao',
    'Hoàn tất',
    'Đã hủy'
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchInitialOrders();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        fetchMoreOrders();
      }
    });
  }

  Future<void> fetchInitialOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .limit(pageSize)
        .get();

    final fetchedOrders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();

    setState(() {
      orders.clear();
      orders.addAll(fetchedOrders);
      lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      hasMore = snapshot.docs.length == pageSize;
    });
  }

  Future<void> fetchMoreOrders() async {
    if (isLoadingMore || !hasMore) return;
    setState(() => isLoadingMore = true);

    final query = FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDocument!)
        .limit(pageSize);

    final snapshot = await query.get();
    final fetchedOrders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();

    setState(() {
      orders.addAll(fetchedOrders);
      lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : lastDocument;
      hasMore = snapshot.docs.length == pageSize;
      isLoadingMore = false;
    });
  }

  String formatCurrency(num amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ';
  }

  String formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Chờ xử lý':
        return Colors.orange;
      case 'Đang giao':
        return Colors.blue;
      case 'Hoàn tất':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void sendOrderEmail(OrderModel order) {
    // TODO: Gửi email đơn hàng bằng Cloud Functions hoặc API backend.
    debugPrint("Gửi email xác nhận đơn hàng cho: ${order.name} - ${order.phoneNumber}");
  }

  void showOrderDetailDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết đơn hàng #${order.id}'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Người mua: ${order.name}'),
                Text('SĐT: ${order.phoneNumber}'),
                Text('Địa chỉ: ${order.address}'),
                Text('PTTT: ${order.paymentMethod}'),
                const Divider(),
                ...order.items.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(item.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                    ),
                    title: Text(item.name, overflow: TextOverflow.ellipsis),
                    subtitle: Text('SL: ${item.quantity} - ${formatCurrency(item.price)}'),
                  ),
                ),
                const Divider(),
                Text('Phí ship: ${formatCurrency(order.shippingFee)}'),
                Text('Tổng tiền: ${formatCurrency(order.totalPrice)}'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => sendOrderEmail(order),
            child: const Text('Gửi email'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = orders.where((order) {
      return (selectedStatus == 'Tất cả' || order.status == selectedStatus) &&
          order.name.toLowerCase().contains(searchKeyword);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý đơn hàng')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm theo tên người mua...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (value) => setState(() => searchKeyword = value.toLowerCase()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Trạng thái:', style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: selectedStatus,
                  onChanged: (value) => setState(() => selectedStatus = value!),
                  items: statusOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredOrders.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= filteredOrders.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final order = filteredOrders[index];
                final firstItem = order.items.isNotEmpty ? order.items.first : null;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 1,
                  child: ListTile(
                    onTap: () => showOrderDetailDialog(order),
                    leading: firstItem != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              firstItem.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(
                      'Đơn #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Người mua: ${order.name}'),
                        Text('Tổng tiền: ${formatCurrency(order.totalPrice)}'),
                      ],
                    ),
                    trailing: DropdownButton<String>(
                      value: order.status,
                      underline: const SizedBox(),
                      style: TextStyle(color: getStatusColor(order.status)),
                      dropdownColor: Colors.white,
                      items: statusOptions
                          .where((e) => e != 'Tất cả')
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          FirebaseFirestore.instance
                              .collection('orders')
                              .doc(order.id)
                              .update({'status': newStatus});
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

