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
      'id': id,
      'name': name,
      'short_description': shortDescription,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'status': status,
      'distance': distance,
      'time': time,
    };
  }
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      shortDescription: json['short_description'],
      description: json['description'],
      imageUrl: json['image_url'],
      price: json['price'],
      status: json['status'],
      distance: json['distance'],
      time: json['time'],
    );
  }
}
