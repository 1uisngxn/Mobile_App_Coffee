import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_mobile/data/user/Customer/Customer_model.dart';
import 'package:project_mobile/pages/home/payment/discount_page.dart';
import 'package:project_mobile/pages/home/payment/payment_page_test.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double discountPercent = 0.0;
  bool discountApplied = false;
  int quantity = 2;
  User user = User(
    name: 'Đỗ Như Quỳnh',
    address: '34 Sư vạn hạnh, quận 10, HCM',
    phoneNumber: '0962471157',
  );

  String calculateTotalPrice() {
    double totalPrice = 40000.0; // Giá thành sản phẩm
    double deliveryFee = 15000.0; // Phí giao hàng

    if (discountApplied) {
      double discountAmount = (totalPrice * discountPercent / 100).toDouble();
      totalPrice -= discountAmount;
    }

    double totalAmount = totalPrice + deliveryFee;

    return totalAmount.toStringAsFixed(0) + 'đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/caphesuadua.jpeg',
                    width: Dimensions.pageViewTextContainers,
                    height: Dimensions.height200 - 140,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: Dimensions.width15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cà phê sữa dừa',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontSize: Dimensions.font18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Size M',
                          style: TextStyle(fontFamily: 'RobotoCondensed'),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiscountPage()),
                );
              },
              icon: Icon(Icons.local_offer),
              label: Text(
                'Thêm mã giảm giá',
                style: TextStyle(fontFamily: 'RobotoCondensed'),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.green),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Divider(),
            _buildCostDetail('Giá thành', '40,000đ'),
            _buildCostDetail('Phí giao hàng', '15,000đ'),
            if (discountApplied)
              _buildCostDetail('Giảm giá',
                  '${(40000 * discountPercent / 100).toStringAsFixed(0)}đ'),
            Divider(),
            Text('Tổng thành tiền: ${calculateTotalPrice()}'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentPage1(user: user, quantity: quantity),
                  ),
                );
              },
              child: Text(
                'Đặt hàng',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  color: AppColors.textColor_white,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veriPeri,
                minimumSize: Size(double.infinity, Dimensions.height45),
              ),
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }

  Widget _buildCostDetail(String title, String cost) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: Dimensions.font15)),
          Text(cost, style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: Dimensions.font15)),
        ],
      ),
    );
  }
}
