import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sản phẩm')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product['name']),
                subtitle: Text('Giá: ${product['price']}đ\nTrạng thái: ${product['status']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    FirebaseFirestore.instance.collection('products').doc(product.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
