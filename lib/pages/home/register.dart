import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/login.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/custom_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  bool _check = false;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpassController = TextEditingController();

  bool _isLoading = false;

  void _handleRegister() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmpassController.text;

    if (email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("Vui lòng điền đầy đủ thông tin");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("Mật khẩu xác nhận không khớp");
      return;
    }

    if (!_check) {
      _showSnackbar("Bạn phải đồng ý với điều khoản sử dụng");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu vào Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': username,
        'email': email,
        'address': '',
        'phoneNumber': '',
        'avatarUrl': null,
        'role': 'user', // mặc định
      });

      _showSnackbar("Đăng ký thành công. Vui lòng đăng nhập.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message ?? "Đăng ký thất bại");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width40),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height60),
            Image.asset(
              "assets/images/logocf.jpg",
              height: Dimensions.height200 + 50,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            SizedBox(height: Dimensions.height15),
            CustomTextField(controller: _emailController, hintText: 'Email', obscureText: false),
            SizedBox(height: Dimensions.height10),
            CustomTextField(controller: _usernameController, hintText: 'Tên đăng nhập', obscureText: false),
            SizedBox(height: Dimensions.height10),
            CustomTextField(controller: _passwordController, hintText: 'Mật khẩu', obscureText: true),
            SizedBox(height: Dimensions.height10),
            CustomTextField(controller: _confirmpassController, hintText: 'Xác nhận mật khẩu', obscureText: true),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                Checkbox(
                  value: _check,
                  onChanged: (value) {
                    setState(() {
                      _check = value!;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Tôi đã đọc và đồng ý với ',
                      style: const TextStyle(color: Colors.black, fontFamily: 'RobotoCondensed'),
                      children: [
                        TextSpan(
                          text: 'Điều khoản Dịch vụ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.veriPeri,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Chính Sách Bảo Mật',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.veriPeri,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' của MoonBook'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.veriPeri,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.height20,
                    vertical: Dimensions.width15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  minimumSize: Size(double.infinity, Dimensions.font26),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Đăng Ký',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đã có tài khoản?',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: Dimensions.font15,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      color: AppColors.veriPeri,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
