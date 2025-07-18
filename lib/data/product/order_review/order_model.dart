import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'price': price,
      };
}

class OrderModel {
  final String id;
  final String userId;
  final String name;
  final String address;
  final String phoneNumber;
  final List<OrderItemModel> items;
  final int shippingFee;
  final double discount;
  final int totalPrice;
  final String paymentMethod;
  final String status;
  final Timestamp createdAt;
  final String? voucherId;
  final String? voucherDescription;

  OrderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.items,
    required this.shippingFee,
    required this.discount,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.voucherId,
    this.voucherDescription,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw StateError("Không tìm thấy dữ liệu đơn hàng.");
    }

    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      shippingFee: data['shippingFee'] ?? 0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
      totalPrice: data['totalPrice'] ?? 0,
      paymentMethod: data['paymentMethod'] ?? 'COD',
      status: data['status'] ?? 'Chờ xử lý',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      voucherId: data['voucherId'],
      voucherDescription: data['voucherDescription'],
      items: (data['items'] as List<dynamic>? ?? []).map((item) {
        return OrderItemModel.fromJson(item as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
        'items': items.map((e) => e.toJson()).toList(),
        'shippingFee': shippingFee,
        'discount': discount,
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'status': status,
        'createdAt': createdAt,
        'voucherId': voucherId,
        'voucherDescription': voucherDescription,
      };
}
