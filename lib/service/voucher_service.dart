import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/data/voucher_model.dart';


class VoucherService {
  final CollectionReference _voucherRef =
      FirebaseFirestore.instance.collection('vouchers');

  Future<List<VoucherModel>> getActiveVouchers() async {
    final snapshot = await _voucherRef.where('isActive', isEqualTo: true).get();
    return snapshot.docs.map((doc) => VoucherModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<VoucherModel?> getVoucherByCode(String code) async {
    final snapshot = await _voucherRef
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return VoucherModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
