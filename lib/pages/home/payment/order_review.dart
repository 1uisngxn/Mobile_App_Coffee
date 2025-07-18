import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/MainPage/main_page.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class OrderReviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double shippingFee;
  final double totalPrice;

  const OrderReviewPage({
    super.key,
    required this.items,
    required this.shippingFee,
    required this.totalPrice,
  });

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  final Map<String, double> _ratings = {};
  final Map<String, TextEditingController> _reviewControllers = {};
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    for (var item in widget.items) {
      final productId = item['productId'];
      _ratings[productId] = 0;
      _reviewControllers[productId] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _reviewControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitAllReviews() async {
    if (_userId == null) return;

    bool allValid = true;
    for (var entry in _ratings.entries) {
      if (entry.value == 0 || _reviewControllers[entry.key]!.text.trim().isEmpty) {
        allValid = false;
        break;
      }
    }

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đánh giá & nhận xét đầy đủ tất cả sản phẩm.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (var item in widget.items) {
      final productId = item['productId'];
      final rating = _ratings[productId]!;
      final reviewText = _reviewControllers[productId]!.text.trim();

      await FirebaseFirestore.instance
          .collection('reviews')
          .doc('${_userId}_$productId')
          .set({
        'userId': _userId,
        'productId': productId,
        'rating': rating,
        'reviewText': reviewText,
        'timestamp': FieldValue.serverTimestamp(),
        'productName': item['name'],
        'imageUrl': item['imageUrl'],
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Gửi đánh giá thành công!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Mainpage()),
      (route) => false,
    );
  }

  Widget _buildStarRating(String productId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _ratings[productId]! ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              _ratings[productId] = index + 1.0;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá đơn hàng'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: widget.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  final item = widget.items[index];
                  final productId = item['productId'];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['imageUrl'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildStarRating(productId),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _reviewControllers[productId],
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Nhận xét của bạn về sản phẩm...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: Dimensions.height20),
            ElevatedButton.icon(
              onPressed: _submitAllReviews,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veriPeri,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.send),
              label: const Text(
                "Gửi đánh giá",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
