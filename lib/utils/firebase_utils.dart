import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addMissingDescriptions() async {
  final firestore = FirebaseFirestore.instance;

  final productsSnapshot = await firestore.collection('products').get();

  for (var doc in productsSnapshot.docs) {
    final data = doc.data();

    // Nếu chưa có trường 'description'
    if (!data.containsKey('description')) {
      await firestore.collection('products').doc(doc.id).update({
        'description': 'Chưa có mô tả sản phẩm',
      });
      print('✅ Đã thêm mô tả cho: ${doc.id}');
    } else {
      print('⏭️ Đã có mô tả cho: ${doc.id}');
    }
  }

  print('🎉 Xong! Đã cập nhật các sản phẩm bị thiếu description.');
}
