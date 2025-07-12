import 'package:flutter/material.dart';
import 'package:project_mobile/data/product/item/product_model.dart';
import 'package:project_mobile/pages/coffee/detail_coffee.dart';
import 'package:project_mobile/service/product/product_service.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/small_text.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductService _productService = ProductService();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query) ||
              product.shortDescription.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> fetchProducts() async {
    try {
      List<ProductModel> products = await _productService.getAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy sản phẩm: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tìm kiếm", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(
              text: 'Tìm Kiếm',
              color: AppColors.veriPeri,
              size: 30,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: Dimensions.height10),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                hintText: 'Tìm món ngon ở đây...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius5),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_filteredProducts.isEmpty)
              Center(child: Text("Không tìm thấy sản phẩm nào."))
            else
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(top: Dimensions.height10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Dimensions.width10,
                    mainAxisSpacing: Dimensions.height10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
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
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: Dimensions.listViewImgSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radius15),
                                image: DecorationImage(
                                  image: NetworkImage(product.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            BigText(text: product.name, size: Dimensions.font16),
                            SmallText(text: product.shortDescription),
                            SizedBox(height: Dimensions.height10),
                            Text(
                              '${product.price} đ',
                              style: TextStyle(
                                color: AppColors.veriPeri,
                                fontSize: Dimensions.font15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
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
