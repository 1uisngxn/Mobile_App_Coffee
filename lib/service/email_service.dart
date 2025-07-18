import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<void> sendOrderConfirmationEmail({
    required String customerEmail,
    required String customerName,
    required String orderId,
    required double totalPrice,
  }) async {
    final smtpServer = gmail(
      'minhlui185@gmail.com', // Thay bằng Gmail bạn dùng để gửi
      'eyci vour kgzq napt',    // Mật khẩu ứng dụng tạo ở bước trước
    );

    final message = Message()
      ..from = Address('minhlui185@gmail.com', 'Amazing Coffee')
      ..recipients.add(customerEmail)
      ..subject = 'Xác nhận đơn hàng #$orderId'
      ..text = 'Xin chào $customerName,\n\n'
          'Cảm ơn bạn đã đặt hàng tại Amazing Coffee!\n'
          'Mã đơn hàng: $orderId\n'
          'Tổng tiền: ${totalPrice.toStringAsFixed(0)}đ\n\n'
          'Chúng tôi sẽ sớm giao hàng đến bạn.\n\nTrân trọng!';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Gửi email thất bại: $e');
    }
  }
}
