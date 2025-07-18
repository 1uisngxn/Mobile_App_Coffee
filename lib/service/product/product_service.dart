import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/data/product/item/product_model.dart';
import '../../data/product/item/product_model.dart';

class ProductService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  // Thêm sản phẩm mới
  Future<void> addProduct(ProductModel product) async {
    try {
      await productsCollection.doc(product.id).set(product.toJson());
    } catch (e) {
      throw Exception('Lỗi khi thêm sản phẩm: $e');
    }
  }

  // Lấy tất cả sản phẩm
  Future<List<ProductModel>> getAllProducts() async {
  try {
    QuerySnapshot snapshot = await productsCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ProductModel.fromJson(data, doc.id); // ✅ truyền id
    }).toList();
  } catch (e) {
    throw Exception('Lỗi khi lấy danh sách sản phẩm: $e');
  }
}



  // Cập nhật sản phẩm
  Future<void> updateProduct(ProductModel product) async {
    try {
      await productsCollection.doc(product.id).update(product.toJson());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật sản phẩm: $e');
    }
  }

  // Xóa sản phẩm
  Future<void> deleteProduct(String id) async {
    try {
      await productsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa sản phẩm: $e');
    }
  }

  // Lấy 1 sản phẩm theo ID
 Future<ProductModel?> getProductById(String id) async {
  try {
    DocumentSnapshot doc = await productsCollection.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return ProductModel.fromJson(data, doc.id); // ✅ truyền id
    }
    return null;
  } catch (e) {
    throw Exception('Lỗi khi lấy sản phẩm theo ID: $e');
  }
 }
}
