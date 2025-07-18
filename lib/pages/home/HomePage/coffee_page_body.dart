import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/data/product/item/product_model.dart';
import 'package:project_mobile/service/product/product_service.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/normal_text.dart';
import 'package:project_mobile/widgets/small_text.dart';
import '../../coffee/detail_coffee.dart';
import 'package:project_mobile/data/banner/banner_data.dart';

class CoffeePageBody extends StatefulWidget {
  const CoffeePageBody({Key? key}) : super(key: key);

  @override
  State<CoffeePageBody> createState() => _CoffeePageBodyState();
}

class _CoffeePageBodyState extends State<CoffeePageBody> {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  bool _loading = true;

  PageController pageController = PageController(viewportFraction: 0.85);
  int _currPageIndex = 0;
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageView;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    pageController.addListener(() {
      int newIndex = pageController.page?.round() ?? 0;
      if (_currPageIndex != newIndex) {
        setState(() {
          _currPageIndex = newIndex;
        });
      }
    });
  }

  Future<void> fetchProducts() async {
    try {
      final list = await _productService.getAllProducts();
      setState(() {
        _products = list;
        _loading = false;
      });
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner slider
          Container(
            height: Dimensions.pageViewContainers,
            child: PageView.builder(
              controller: pageController,
              itemCount: bannerList.length,
              itemBuilder: (_, index) => _buildPageItem(index),
            ),
          ),
          SizedBox(height: Dimensions.height10),

          DotsIndicator(
            dotsCount: bannerList.isEmpty ? 1 : bannerList.length,
            position: _currPageIndex,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10),

          // Best Sales title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BigText(
                  text: "Best Sales",
                  color: AppColors.veriPeri,
                  size: 30,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: Dimensions.height10),
              ],
            ),
          ),

          // Product list
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _products.isEmpty
                  ? const Center(child: Text("Không có sản phẩm nào."))
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Dimensions.width10,
                          mainAxisSpacing: Dimensions.height10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                           print("Image URL: ${product.imageUrl}"); // Thêm dòng này
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CoffeeDetailScreen(coffeeItem: product),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.width10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radius15),
                              child: product.imageUrl.isNotEmpty
                                  ? Image.network(
                                      product.imageUrl,
                                      height: Dimensions.listViewImgSize,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: Dimensions.listViewImgSize,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: Dimensions.listViewImgSize,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                    ),
                            ),

                                  SizedBox(height: Dimensions.height10),

                                  // Name
                                  BigText(
                                    text: product.name,
                                    size: Dimensions.font16,
                                  ),

                                  // Short description
                                  SmallText(
                                    text: product.shortDescription,
                                  ),

                                  SizedBox(height: Dimensions.height10),

                                  // Status, distance, time
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      NormalText(text: product.status),
                                      NormalText(text: product.distance),
                                      NormalText(text: product.time),
                                    ],
                                  ),

                                  SizedBox(height: Dimensions.height5),

                                  // Price
                                  Text(
                                    product.price,
                                    style: TextStyle(
                                      color: AppColors.veriPeri,
                                      fontSize: Dimensions.font15,
                                      fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildPageItem(int index) {
    double scale;
    double translation;

    if (index == _currPageIndex) {
      scale = 1.0;
      translation = 0.0;
    } else {
      scale = _scaleFactor;
      translation = _height * (1 - scale) / 2;
    }

    Matrix4 matrix = Matrix4.identity()
      ..scale(1.0, scale)
      ..translate(0.0, translation);

    return Transform(
      transform: matrix,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(bannerList[index].imageUrl),
          ),
        ),
      ),
    );
  }
}
