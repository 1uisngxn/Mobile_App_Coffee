import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.veriPeri,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Lỗi tải người dùng"));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: EdgeInsets.all(Dimensions.width15),
            itemCount: docs.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(data['name'] ?? 'Không tên'),
                subtitle: Text(data['email'] ?? 'Không email'),
                trailing: Text(
                  data['role'] ?? 'user',
                  style: TextStyle(
                    color: data['role'] == 'admin' ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
