// import giữ nguyên không đổi
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/pages/forgot_password.dart';
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

  Future<String?> _getEmailByUsername(String username) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data()['email'];
  }

  Future<void> _signInWithUsernamePassword() async {
    setState(() => _isLoading = true);
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final email = await _getEmailByUsername(username);
      if (email == null) {
        _showSnackbar("Tên đăng nhập không tồn tại.");
        return;
      }

      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        _showSnackbarWithAction("Email chưa được xác thực.", userCredential.user!);
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Mainpage()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnackbar("Lỗi: ${e.message}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showSnackbarWithAction(String msg, User user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Gửi lại',
          onPressed: () async {
            await user.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đã gửi lại email xác thực.")),
            );
          },
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

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
      _showSnackbar("Đăng nhập bằng Google thất bại.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Dimensions.height40),
                // Logo
                SizedBox(
                  height: Dimensions.height200+40,
                  child: Image.asset("assets/images/logocf.jpg", fit: BoxFit.cover),
                ),

                SizedBox(height: Dimensions.height20),

                // Social login
                SocialButton(
                  icon: Icons.facebook,
                  text: 'Đăng nhập bằng Facebook',
                  color: const Color.fromRGBO(60, 90, 153, 1),
                  onPressed: () {
                    _showSnackbar("Facebook chưa được hỗ trợ.");
                  },
                ),
                SizedBox(height: Dimensions.height10),
                SocialButton(
                  icon: Icons.email,
                  text: 'Đăng nhập bằng Google',
                  color: Colors.red,
                  onPressed: _isLoading ? null : _signInWithGoogle,
                ),
                SizedBox(height: Dimensions.height10),
                SocialButton(
                  icon: Icons.apple,
                  text: 'Đăng nhập bằng Apple',
                  color: Colors.black,
                  onPressed: () {
                    _showSnackbar("Apple chưa được hỗ trợ.");
                  },
                ),

                SizedBox(height: Dimensions.height20),

                // Divider "hoặc"
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                      child: const Text("hoặc", style: TextStyle(color: Colors.grey)),
                    ),
                    const Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),

                SizedBox(height: Dimensions.height15),

                // Username and password
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Tên đăng nhập',
                  obscureText: false,
                ),
                SizedBox(height: Dimensions.height10),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Mật khẩu',
                  obscureText: true,
                ),

                SizedBox(height: Dimensions.height10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: AppColors.veriPeri,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.font15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.height10),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signInWithUsernamePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.veriPeri,
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Đăng Nhập', style: TextStyle(color: Colors.white)),
                  ),
                ),

                SizedBox(height: Dimensions.height20),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản?"),
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
                          color: AppColors.veriPeri,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: Dimensions.height20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
