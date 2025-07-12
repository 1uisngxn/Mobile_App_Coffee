import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/pages/home/MainPage/main_page.dart';
import 'package:project_mobile/pages/home/register.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/custom_text_field.dart';
import 'package:project_mobile/widgets/social_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'email': userCredential.user!.email,
            'name': userCredential.user!.displayName ?? "",
            'role': 'user',
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Mainpage()),
        );
      }
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập bằng Google thất bại.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.height60),
              Container(
                width: double.infinity,
                height: Dimensions.height200 + 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logocf.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),             
              SizedBox(height: Dimensions.height10),

              // Facebook button
              SocialButton(
                icon: Icons.facebook,
                text: 'Đăng nhập bằng Facebook',
                color: const Color.fromRGBO(60, 90, 153, 1),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng Facebook chưa hỗ trợ.')),
                  );
                },
              ),
              SizedBox(height: Dimensions.height5),

              // Google button
              SocialButton(
                icon: Icons.email,
                text: 'Đăng nhập bằng Google',
                color: Colors.red,
                onPressed: _isLoading ? null : () => _signInWithGoogle(),
              ),
              SizedBox(height: Dimensions.height5),

              // Apple button
              SocialButton(
                icon: Icons.apple,
                text: 'Đăng nhập bằng Apple',
                color: Colors.black,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng Apple chưa hỗ trợ.')),
                  );
                },
              ),
              SizedBox(height: Dimensions.height5),

              // Divider "hoặc"
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.height10),
                    child: const Text("hoặc", style: TextStyle(color: Colors.grey)),
                  ),
                  const Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              SizedBox(height: Dimensions.height10),

              // Input fields
              CustomTextField(
                controller: _usernameController,
                hintText: 'Tên đăng nhập',
                obscureText: false,
              ),
              const Divider(color: Colors.grey),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Mật khẩu',
                obscureText: true,
              ),
              const Divider(color: Colors.grey),
              SizedBox(height: Dimensions.height10),

              // Quên mật khẩu
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: AppColors.veriPeri,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font15,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ),
              ),

              // Đăng nhập button (tạm chưa xử lý)
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng sử dụng Google để đăng nhập.")),
                  );
                },
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
                child: Text(
                  'Đăng Nhập',
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ),

              // Đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chưa có tài khoản?',
                    style: TextStyle(
                      fontSize: Dimensions.font15,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Register()),
                      );
                    },
                    child: Text(
                      'Đăng Ký',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.veriPeri,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
