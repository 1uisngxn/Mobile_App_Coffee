import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/HomePage/home_page.dart';
import 'package:project_mobile/pages/home/MainPage/main_page.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class OrderReviewPage extends StatelessWidget {
  final String itemName;
  final String itemSize;
  final int quantity;
  final double itemPrice;
  final double shippingFee;
  final double totalPrice;

  OrderReviewPage({
    required this.itemName,
    required this.itemSize,
    required this.quantity,
    required this.itemPrice,
    required this.shippingFee,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá đơn hàng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfoCard(),
            SizedBox(height: Dimensions.height15),
            _buildPaymentDetailsBox(), // Add the payment details box here
            SizedBox(height: Dimensions.height15),
            _buildOrderStatus(),
            SizedBox(height: Dimensions.height15),
            _buildReviewSection(),
            Spacer(),
            _buildReturnButton(context),
            SizedBox(height: Dimensions.height45),

          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15 - 3)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
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
                  Text(itemName, style: TextStyle(fontSize: Dimensions.font18, fontFamily: 'RobotoCondensed')),
                  Text('Size $itemSize', style: TextStyle(fontSize: Dimensions.font18, fontFamily: 'RobotoCondensed')),
                  Text('Số lượng: $quantity', style: TextStyle(fontSize: Dimensions.font18, fontFamily: 'RobotoCondensed')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPaymentDetailsBox() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15 - 3)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết thanh toán',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: Dimensions.font15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            _buildCostDetail('Giá thành', '40,000đ'),
            _buildCostDetail('Phí giao hàng (voucher)', '15,000đ'),
            _buildCostDetail('Tổng thành tiền', '55,000'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
          child: _buildStatusCircle('Xuất phát', true),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Divider(thickness: 2.0, color: Colors.grey),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
          child: _buildStatusCircle('Đang giao', true),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Divider(thickness: 2.0, color: Colors.grey),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
          child: _buildStatusCircle('Đã tới', true),
        ),
      ],
    );
  }

  Widget _buildStatusCircle(String text, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: isActive ? Colors.green : Colors.grey,
        ),
        SizedBox(height: 8.0),
        Text(text, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Đừng quên đánh giá bạn nhé', style: TextStyle(fontSize: Dimensions.font18, fontFamily: 'RobotoCondensed')),
        SizedBox(height: Dimensions.height10),
        TextField(
          style: TextStyle(fontFamily: 'RobotoCondensed'),
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Nhận xét ...',
          ),
        ),
        SizedBox(height: Dimensions.height30),
        Center(
          child: Image.asset(
            'assets/images/rating.png', // replace with your rating image asset
            width: Dimensions.listViewImgSize,
            height: Dimensions.height200 - 140,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return Center(
      child:ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Mainpage()),
          );
        },
        child: Text('Xác nhận', style: TextStyle(color: Colors.white, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold, fontSize: Dimensions.font18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.veriPeri,
          minimumSize: Size(double.infinity, 50),
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
