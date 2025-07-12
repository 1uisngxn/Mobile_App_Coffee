class OrderModel {
  final String itemName;
  final String itemSize;
  final int quantity;
  final double itemPrice;
  final double shippingFee;

  OrderModel({
    required this.itemName,
    required this.itemSize,
    required this.quantity,
    required this.itemPrice,
    required this.shippingFee,
  });

  double get totalPrice => (itemPrice * quantity) + shippingFee;

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemSize': itemSize,
      'quantity': quantity,
      'itemPrice': itemPrice,
      'shippingFee': shippingFee,
      'totalPrice': totalPrice,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      itemName: json['itemName'],
      itemSize: json['itemSize'],
      quantity: json['quantity'],
      itemPrice: (json['itemPrice'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
    );
  }
}
