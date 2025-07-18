import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';

class MoMoPaymentPage extends StatelessWidget {
  final int totalPrice;
  final VoidCallback onPaymentCompleted;

  const MoMoPaymentPage({
    super.key,
    required this.totalPrice,
    required this.onPaymentCompleted,
  });

  String formatCurrency(int amount) {
    return "${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final qrSize = screenWidth * 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán MoMo", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Quét mã QR để thanh toán",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Container(
                  width: qrSize,
                  height: qrSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 3),
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/momo_qr.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Số tiền: ${formatCurrency(totalPrice)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    onPaymentCompleted();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text("Hoàn tất thanh toán", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
