import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/data/product/item/product_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> addToCart(ProductModel product, int quantity) async {
    final cartRef = _firestore.collection('users').doc(_uid).collection('cart');

    final existing = await cartRef.doc(product.id).get();

    if (existing.exists) {
      final currentQty = existing.data()!['quantity'] ?? 1;
      await cartRef.doc(product.id).update({
        'quantity': currentQty + quantity,
      });
    } else {
      await cartRef.doc(product.id).set({
        'id': product.id,
        'name': product.name,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'quantity': quantity,
      });
    }
  }

  Future<void> removeCartItem(String productId) async {
    await _firestore.collection('users').doc(_uid).collection('cart').doc(productId).delete();
  }

  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    await _firestore.collection('users').doc(_uid).collection('cart').doc(productId).update({
      'quantity': quantity,
    });
  }

  Future<void> clearCart() async {
    final cartRef = _firestore.collection('users').doc(_uid).collection('cart');
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<QuerySnapshot> getCartItems() {
    return _firestore.collection('users').doc(_uid).collection('cart').snapshots();
  }
}
