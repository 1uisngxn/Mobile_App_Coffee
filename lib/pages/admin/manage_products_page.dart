import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _statusController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _searchKeyword = '';
  String _selectedStatus = 'Tất cả';
  double? _minPrice;
  double? _maxPrice;

  int _currentPage = 0;
  static const int _itemsPerPage = 5;

  String formatCurrency(num price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(price);
  }

  void _showProductDialog({DocumentSnapshot? product}) {
    final isEdit = product != null;

    if (isEdit) {
      _nameController.text = product!['name'];
      _priceController.text = product['price'].toString();
      _statusController.text = product['status'];
      _imageUrlController.text = product['imageUrl'];
      _descriptionController.text = product['description'];
    } else {
      _nameController.clear();
      _priceController.clear();
      _statusController.clear();
      _imageUrlController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
              TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Giá'), keyboardType: TextInputType.number),
              TextField(controller: _statusController, decoration: const InputDecoration(labelText: 'Trạng thái')),
              TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Mô tả'), maxLines: 3),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Link ảnh (URL)'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              if (_imageUrlController.text.isNotEmpty && _imageUrlController.text.startsWith('http'))
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _imageUrlController.text,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Text('Không hiển thị được ảnh'),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              final price = double.tryParse(_priceController.text.trim()) ?? 0;
              final status = _statusController.text.trim();
              final imageUrl = _imageUrlController.text.trim();
              final description = _descriptionController.text.trim();

              if (name.isEmpty || status.isEmpty) return;

              if (isEdit) {
                await FirebaseFirestore.instance.collection('products').doc(product!.id).update({
                  'name': name,
                  'price': price,
                  'status': status,
                  'imageUrl': imageUrl,
                  'description': description,
                });
              } else {
                await FirebaseFirestore.instance.collection('products').add({
                  'name': name,
                  'price': price,
                  'status': status,
                  'imageUrl': imageUrl,
                  'description': description,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              }

              if (mounted) Navigator.pop(context);
            },
            child: Text(isEdit ? 'Lưu' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(String id) {
    FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  void _nextPage(int totalItems) {
    final maxPage = (totalItems / _itemsPerPage).ceil();
    if (_currentPage < maxPage - 1) {
      setState(() => _currentPage++);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() {
                      _searchKeyword = value.toLowerCase();
                      _currentPage = 0;
                    }),
                    decoration: const InputDecoration(hintText: 'Tìm kiếm sản phẩm...'),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: ['Tất cả', 'Còn hàng', 'Hết hàng']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedStatus = value!;
                    _currentPage = 0;
                  }),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Giá từ'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _minPrice = double.tryParse(value);
                      setState(() => _currentPage = 0);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Giá đến'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _maxPrice = double.tryParse(value);
                      setState(() => _currentPage = 0);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  List<QueryDocumentSnapshot> products = snapshot.data!.docs;

                  products = products.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final status = doc['status'].toString();
                    final price = doc['price'] is int
                        ? (doc['price'] as int).toDouble()
                        : doc['price'] as double;

                    final matchesName = name.contains(_searchKeyword);
                    final matchesStatus = _selectedStatus == 'Tất cả' || status == _selectedStatus;
                    final matchesMin = _minPrice == null || price >= _minPrice!;
                    final matchesMax = _maxPrice == null || price <= _maxPrice!;

                    return matchesName && matchesStatus && matchesMin && matchesMax;
                  }).toList();

                  final totalItems = products.length;
                  final paginated = products.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: paginated.length,
                          itemBuilder: (_, index) {
                            final product = paginated[index];

                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: (product['imageUrl'] != null &&
                                          product['imageUrl'].toString().startsWith('http'))
                                      ? Image.network(
                                          product['imageUrl'],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                        )
                                      : Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_not_supported),
                                        ),
                                ),
                                title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  'Giá: ${formatCurrency(product['price'])}'
                                  'Trạng thái: ${product['status']}',
                                  style: const TextStyle(height: 1.4),
                                ),
                                onTap: () => _showProductDialog(product: product),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteProduct(product.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _currentPage == 0 ? null : _prevPage,
                            icon: const Icon(Icons.arrow_back),
                          ),
                          Text('Trang ${_currentPage + 1} / ${(totalItems / _itemsPerPage).ceil()}'),
                          IconButton(
                            onPressed: (_currentPage + 1) * _itemsPerPage >= totalItems ? null : () => _nextPage(totalItems),
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
