import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/data/product/item/product_model.dart';
import 'package:project_mobile/service/cart/cart_service.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/app_icons.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/expandable.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final ProductModel coffeeItem;

  const CoffeeDetailScreen({super.key, required this.coffeeItem});

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int quantity = 1;
  final CartService _cartService = CartService();

  void _addToCart() async {
    await _cartService.addToCart(widget.coffeeItem, quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã thêm vào giỏ hàng")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.red),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    AppIcons(
                      iconSize: Dimensions.iconSize24,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      icon: Icons.favorite,
                      onPressed: () {},
                    )
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(Dimensions.height20),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        top: Dimensions.height10, bottom: Dimensions.height10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.radius20),
                      ),
                    ),
                    child: BigText(
                      text: widget.coffeeItem.name,
                      size: Dimensions.font20,
                      color: AppColors.veriPeri,
                    ),
                  ),
                ),
                pinned: true,
                backgroundColor: AppColors.mainColor2,
                expandedHeight: Dimensions.height200 + 100,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    widget.coffeeItem.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Mô tả
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20, vertical: Dimensions.height10),
                  child: ExpandableTextWidgets(text: widget.coffeeItem.description),
                ),
              ),

              // Đánh giá
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text(
                        "Đánh giá sản phẩm",
                        style: TextStyle(
                          fontSize: Dimensions.font18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildReviews(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Nút thêm vào giỏ hàng
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: Dimensions.bottomHeightBar + 10,
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimensions.radius20 * 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tăng giảm số lượng
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: Dimensions.font18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),

                  // Thêm vào giỏ hàng
                  ElevatedButton.icon(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20, vertical: Dimensions.height10),
                    ),
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: const Text(
                      'Thêm vào giỏ hàng',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: widget.coffeeItem.id)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("Chưa có đánh giá nào.");
        }

        final reviews = snapshot.data!.docs;

        return Column(
          children: reviews.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (data['rating'] ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              subtitle: Text(data['reviewText'] ?? ''),
            );
          }).toList(),
        );
      },
    );
  }
}
