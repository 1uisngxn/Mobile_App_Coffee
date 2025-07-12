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
    Key? key,
    required this.items,
    required this.shippingFee,
    required this.totalPrice,
  }) : super(key: key);

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

    bool allFilled = true;
    for (var entry in _ratings.entries) {
      if (entry.value == 0 || _reviewControllers[entry.key]!.text.isEmpty) {
        allFilled = false;
        break;
      }
    }

    if (!allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đánh giá và nhận xét đầy đủ tất cả sản phẩm.')),
      );
      return;
    }

    for (var item in widget.items) {
      final productId = item['productId'];
      final rating = _ratings[productId]!;
      final reviewText = _reviewControllers[productId]!.text;

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
      const SnackBar(content: Text('Đã gửi đánh giá thành công.')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Mainpage()),
      (route) => false,
    );
  }

  Widget _buildStarRating(String productId) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _ratings[productId]! ? Icons.star : Icons.star_border,
            color: Colors.amber,
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
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (_, index) {
                  final item = widget.items[index];
                  final productId = item['productId'];
                  return Card(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.height15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                item['imageUrl'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.height10),
                          _buildStarRating(productId),
                          TextField(
                            controller: _reviewControllers[productId],
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Viết nhận xét ở đây...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: Dimensions.height15),
            ElevatedButton(
              onPressed: _submitAllReviews,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veriPeri,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Gửi đánh giá",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}
