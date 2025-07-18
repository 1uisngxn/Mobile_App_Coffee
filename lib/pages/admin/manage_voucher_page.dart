import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageVouchersPage extends StatefulWidget {
  const ManageVouchersPage({super.key});

  @override
  State<ManageVouchersPage> createState() => _ManageVouchersPageState();
}

class _ManageVouchersPageState extends State<ManageVouchersPage> {
  final _codeController = TextEditingController();
  final _discountController = TextEditingController();
  String _type = 'fixed';

  Future<void> _addVoucher() async {
    final code = _codeController.text.trim().toUpperCase();
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;

    if (code.isEmpty || discount <= 0) return;

    await FirebaseFirestore.instance.collection('vouchers').add({
      'code': code,
      'discount': discount,
      'type': _type,
      'isActive': true,
      'createdAt': Timestamp.now(),
    });

    _codeController.clear();
    _discountController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Mã giảm giá đã được thêm')),
    );
  }

  Future<void> _toggleVoucherActive(DocumentSnapshot doc) async {
    await doc.reference.update({'isActive': !(doc['isActive'] as bool)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý mã giảm giá')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Mã voucher'),
            ),
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(labelText: 'Số tiền / % giảm'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'fixed', child: Text('Giảm số tiền cố định')),
                DropdownMenuItem(value: 'percent', child: Text('Giảm theo %')),
              ],
              onChanged: (value) => setState(() => _type = value!),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addVoucher,
              child: const Text('Thêm mã giảm giá'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text('Danh sách mã giảm giá'),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vouchers')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return ListTile(
                        title: Text(doc['code']),
                        subtitle: Text('${doc['discount']} (${doc['type']})'),
                        trailing: Switch(
                          value: doc['isActive'],
                          onChanged: (_) => _toggleVoucherActive(doc),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
