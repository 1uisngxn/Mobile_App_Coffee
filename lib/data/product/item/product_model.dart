class ProductModel {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final String imageUrl;
  final String price;
  final String status;
  final String distance;
  final String time;

  ProductModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.status,
    required this.distance,
    required this.time,
  });

 Map<String, dynamic> toJson() {
  return {
    'name': name,
    'shortDescription': shortDescription,
    'description': description,
    'imageUrl': imageUrl,
    'price': price,
    'status': status,
    'distance': distance,
    'time': time,
  };
}

 factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
  return ProductModel(
    id: id,
    name: json['name'] ?? '',
    shortDescription: json['shortDescription'] ?? '',
    description: json.containsKey('description') ? json['description'] : '',
    imageUrl: json.containsKey('imageUrl') ? json['imageUrl'] : '',
    price: json['price']?.toString() ?? '0',
    status: json['status'] ?? '',
    distance: json['distance'] ?? '',
    time: json['time'] ?? '',
  );
}
}
