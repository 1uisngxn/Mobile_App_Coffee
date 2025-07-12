class UserModel {
  final String uid;
  final String name;
  final String email;
  final String address;
  final String phoneNumber;
  final String? avatarUrl;
  final String role; // Mặc định: 'user' (có thể là 'admin')

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    this.avatarUrl,
    this.role = 'user',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      avatarUrl: map['avatarUrl'],
      role: map['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }
}
