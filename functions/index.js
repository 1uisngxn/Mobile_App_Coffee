const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

// Cấu hình tài khoản Gmail (bạn cần bật "Less secure apps" hoặc dùng App Password)
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'your_email@gmail.com',      // 📨 Gmail bạn dùng để gửi
    pass: 'your_app_password_or_pass'  // 🔐 App password (nếu bật 2FA)
  }
});

// Hàm gửi mail khi có đơn hàng mới
exports.sendOrderEmail = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const order = snap.data();

    const mailOptions = {
      from: 'Shop Coffee <your_email@gmail.com>',
      to: order.phoneNumber + '@mail.com', // hoặc email khách nếu có
      subject: `Xác nhận đơn hàng #${context.params.orderId}`,
      html: `
        <h2>Chào ${order.name},</h2>
        <p>Cảm ơn bạn đã đặt hàng tại Shop Coffee!</p>
        <p><strong>Tổng tiền:</strong> ${order.totalPrice.toLocaleString()}đ</p>
        <p><strong>Địa chỉ:</strong> ${order.address}</p>
        <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
        <p>Chúng tôi sẽ liên hệ với bạn sớm.</p>
        <hr />
        <p>Shop Coffee</p>
      `
    };

    try {
      await transporter.sendMail(mailOptions);
      console.log('✅ Đã gửi mail xác nhận đơn hàng.');
    } catch (error) {
      console.error('❌ Gửi mail thất bại:', error);
    }
  });
