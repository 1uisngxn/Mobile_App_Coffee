import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherModel {
  final String id;
  final String code;
  final double discount;
  final String type; // 'fixed' or 'percent'
  final bool isActive;
  final DateTime createdAt;

  VoucherModel({
    required this.id,
    required this.code,
    required this.discount,
    required this.type,
    required this.isActive,
    required this.createdAt,
  });

  factory VoucherModel.fromMap(Map<String, dynamic> data, String docId) {
    return VoucherModel(
      id: docId,
      code: data['code'] ?? '',
      discount: (data['discount'] ?? 0).toDouble(),
      type: data['type'] ?? 'fixed',
      isActive: data['isActive'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'discount': discount,
      'type': type,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
