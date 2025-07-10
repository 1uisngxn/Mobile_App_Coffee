import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});


  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  double selectedDiscountPercent = 0.0;
  double discountPercent = 0.0;
  bool discountApplied = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mã giảm giá',style: TextStyle(color: AppColors.textColor_white),),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle enter voucher code
                    },
                    icon: Icon(Icons.card_giftcard),
                    label: Text('Nhập mã voucher'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor:AppColors.mainColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle find more vouchers
                    },
                    icon: Icon(Icons.search),
                    label: Text('Tìm thêm voucher',style: TextStyle(fontFamily: 'RobotoCondensed',color: AppColors.textColor_white),),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor:AppColors.mainColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildVoucherItem('assets/images/discount_freeship.png', 'Miễn phí vận chuyển'),
                  _buildVoucherItem('assets/images/discount_freeship.png', 'Miễn phí vận chuyển'),
                  _buildVoucherItem('assets/images/discount_50.png', 'Giảm 50% tổng bill'),
                  _buildVoucherItem('assets/images/discount_20.png', 'Giảm 20% tổng bill'),
                  _buildVoucherItem('assets/images/discount_10.png', 'Giảm 10% tổng bill'),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle load more vouchers
                },
                child: Text('Xem thêm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherItem(String imagePath, String description) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical:Dimensions.height10),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15-3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: Dimensions.width100+20,
              height: Dimensions.height60,
              fit: BoxFit.cover,
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: Dimensions.font15,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedDiscountPercent = 0.5; // Cập nhật giá trị voucher đã chọn vào đây
                });
              },
              child: Text('Dùng Ngay'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
