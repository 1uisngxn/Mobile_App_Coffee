import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/payment/order_review.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/data/product/item/product_model.dart';
import 'package:project_mobile/data/product/item/product_data.dart';

class OrderTrackingPage extends StatefulWidget {
  final int quantity;

  OrderTrackingPage({required this.quantity});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theo dõi đơn hàng',style: TextStyle(fontFamily: 'RobotoCondensed',fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryTimeCard(),
            SizedBox(height: Dimensions.height15),
            _buildDriverInfoCard(),
            SizedBox(height: Dimensions.height15,),
            _buildOrderStatus(),
            SizedBox(height: Dimensions.height15),
            _buildOrderInfoCard(),
            Spacer(),
            _buildConfirmButton(),
            SizedBox(height: Dimensions.height45,)
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTimeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15)),
      child: Padding(
        padding:  EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời gian nhận hàng',
              style: TextStyle(fontSize: Dimensions.font15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.height10),
            Row(
              children: [
                Text('MOONSHOP', style: TextStyle(fontSize: Dimensions.font18,fontFamily: 'RobotoCondensed')),
                Spacer(),
                Text('ĐH Huflit', style: TextStyle(fontSize: Dimensions.font18,fontFamily: 'RobotoCondensed')),
              ],
            ),
            SizedBox(height: Dimensions.height10-2),
            Row(
              children: [
                Text('~ 2 phút', style: TextStyle(fontSize: Dimensions.font15,fontFamily: 'RobotoCondensed')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15-3)),
      child: Padding(
        padding:  EdgeInsets.all(Dimensions.height15),
        child: Row(
          children: [
            CircleAvatar(
              radius: Dimensions.radius30,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: Dimensions.font26, color: Colors.white),
            ),
            SizedBox(width: Dimensions.width15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên: Chí Nam', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18)),
                Text('Tuổi: 21', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18)),
                Text('SĐT: 024245025', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18)),
                Row(
                  children: [
                    Text('Đánh giá: 4.6', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18)),
                    Icon(Icons.star, color: Colors.amber),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container( width: Dimensions.pageView,
          child:Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height10),
                child:
                  _buildStatusCircle('Xuất phát', true),
              ),
              Flexible(
                flex: 1,
                child: Divider(thickness: 2.0, color: Colors.grey,),
              ),
              Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height10),
              child:_buildStatusCircle('Đang giao', true),),
              Flexible(
                flex: 1,
                child: Divider(thickness: 2.0, color: Colors.grey),
              ),
              Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height10),
              child:_buildStatusCircle('Đã tới', false),)
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildStatusCircle(String text, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: Dimensions.radius15,
          backgroundColor: isActive ? Colors.green : Colors.grey,
        ),
        SizedBox(height: Dimensions.height10),
        Text(text, style: TextStyle(fontSize: Dimensions.font18,fontFamily: 'RobotoCondensed')),
      ],
    );
  }

  Widget _buildOrderInfoCard() {
    return Card(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15-3)),
      child: Padding(
        padding:  EdgeInsets.all(Dimensions.height15),
        child: Column(
          children: [
            BigText(
                text: "Thông tin đơn hàng",
                color: Color(0xFF6667AB), // Màu Very Peri
                size: Dimensions.font26, // Kích thước lớn hơn
                align: TextAlign.left,
                fontWeight: FontWeight.w700// Căn lề về bên trái
            ),
            SizedBox(height: Dimensions.height10,),
            Row(
              children: [
                Image.asset(
                  'assets/images/caphesuadua.jpeg',
                  width: Dimensions.pageViewTextContainers,
                  height: Dimensions.height200 - 140,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: Dimensions.width15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cà phê sữa dừa', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18)),
                    Text('Size M', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18)),
                    Text('Số lượng: ${widget.quantity}', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderReviewPage(
                itemName: 'Cà phê sữa dừa', // Pass the item name
                itemSize: 'Size M',         // Pass the item size
                quantity: widget.quantity,  // Pass the quantity
                itemPrice: 40000,           // Pass the item price
                shippingFee: 0,             // Pass the shipping fee
                totalPrice: 40000,          // Pass the total price
              ),
            ),
          );
        },
        child: Text('ĐÃ NHẬN ĐƯỢC HÀNG', style: TextStyle(color: Colors.white, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold, fontSize: Dimensions.font18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.veriPeri,
          minimumSize: Size(double.infinity, 50),
        ),
      ));

  }
}
