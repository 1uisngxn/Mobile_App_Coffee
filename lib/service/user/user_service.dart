import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/user/user_model.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Tạo user mới
  Future<void> createUser(UserModel user) async {
    await users.doc(user.uid).set(user.toMap());
  }

  // Lấy user theo uid
  Future<UserModel?> getUserById(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Cập nhật user
  Future<void> updateUser(UserModel user) async {
    await users.doc(user.uid).update(user.toMap());
  }

  // Xoá user
  Future<void> deleteUser(String uid) async {
    await users.doc(uid).delete();
  }

  // Lắng nghe user theo uid (realtime update)
  Stream<UserModel> getUserStream(String uid) {
    return users.doc(uid).snapshots().map(
      (doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>),
    );
  }
}