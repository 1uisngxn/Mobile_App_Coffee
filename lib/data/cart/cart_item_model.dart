class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final DateTime addedAt;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
