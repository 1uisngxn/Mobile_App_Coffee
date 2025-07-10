import 'package:flutter/material.dart';
import 'package:project_mobile/data/user/Customer/Customer_model.dart';
import 'package:project_mobile/pages/home/payment/order_tracking.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class PaymentPage1 extends StatefulWidget {
  final User user;
  final int quantity;

  PaymentPage1({required this.user, required this.quantity});

  @override
  _PaymentPageState1 createState() => _PaymentPageState1();
}

class _PaymentPageState1 extends State<PaymentPage1> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    addressController = TextEditingController(text: widget.user.address);
    phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _editInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa thông tin',),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên người nhận'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.user.name = nameController.text;
                  widget.user.address = addressController.text;
                  widget.user.phoneNumber = phoneNumberController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán',style: TextStyle(color: AppColors.textColor_white),),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/caphesuadua.jpeg',
                  width: Dimensions.pageViewTextContainers,
                  height: Dimensions.height200 - 140,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cà phê sữa dừa',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 18,
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Số lượng ${widget.quantity}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Địa chỉ nhận hàng',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tên người nhận',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Địa chỉ',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.user.address,
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Số điện thoại',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.user.phoneNumber,
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _editInfo,
                      child: Text('Chỉnh sửa'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle add note
                      },
                      child: Text('Ghi chú'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
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
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderTrackingPage(quantity: widget.quantity)),
                );
              },
              child: Text('Xác nhận', style: TextStyle(color: Colors.white, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold, fontSize: Dimensions.font18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veriPeri,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: Dimensions.height30),
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
