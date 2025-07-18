import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscountPage extends StatefulWidget {
  final double subtotal;

  const DiscountPage({Key? key, required this.subtotal}) : super(key: key);

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _applyVoucher() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() => _error = 'Vui lòng nhập mã giảm giá');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('vouchers')
          .where('code', isEqualTo: code)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _error = 'Mã không tồn tại hoặc đã hết hạn';
          _isLoading = false;
        });
        return;
      }

      final data = snapshot.docs.first.data();
      final type = data['type'];
      final discountValue = data['discount'] ?? 0;

      double discountAmount = 0.0;

      if (type == 'fixed') {
        discountAmount = discountValue.toDouble();
      } else if (type == 'percentage') {
        discountAmount = widget.subtotal * (discountValue / 100);
      }

      Navigator.pop(context, {
        'discountAmount': discountAmount,
        'voucherId': snapshot.docs.first.id,
        'description': code,
      });
    } catch (e) {
      setState(() => _error = 'Đã xảy ra lỗi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập mã giảm giá')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Mã giảm giá',
              ),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _applyVoucher,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Áp dụng'),
            ),
          ],
        ),
      ),
    );
  }
}
