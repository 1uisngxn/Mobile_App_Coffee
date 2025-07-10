import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/login.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/custom_text_field.dart';
import 'package:project_mobile/widgets/social_button.dart';
import 'package:flutter/src/services/asset_manifest.dart' as flutter_asset;

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
                width: double.maxFinite,
                height: Dimensions.height200-80, // Adjust height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    image: AssetImage("assets/images/logo.png"),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Đăng ký để nhận được những khuyến mãi và ưu đãi hấp dẫn từ chúng tôi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: Dimensions.font15, color: Colors.grey[700],fontFamily: 'RobotoCondensed'),
                ),
              //SizedBox(height: Dimensions.height10),
              SizedBox(
                width: Dimensions.pageView,
                child: SocialButton(
                  icon: Icons.facebook,
                  text: 'Đăng ký bằng Facebook',
                  color: Color.fromRGBO(60, 90, 153, 1),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: Dimensions.height5),
              SizedBox(
                width: Dimensions.pageView,
                child: SocialButton(
                  icon: Icons.email,
                  text: 'Đăng ký bằng Google',
                  color: Colors.red,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: Dimensions.height5),
              SizedBox(
                width: Dimensions.pageView,
                child: SocialButton(
                  icon: Icons.apple,
                  text: 'Đăng ký bằng Apple',
                  color: Colors.black,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Container( width: Dimensions.pageView,
                child:Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Divider(thickness: 1.0, color: Colors.grey,),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.height10),
                    child: Text(
                      'hoặc',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Divider(thickness: 1.0, color: Colors.grey),
                  ),
                ],
              ),
              ),

              Container(
                width: Dimensions.pageView,
                child: Column(

                  children: [
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    //Divider(thickness: 1.0, color: Colors.grey),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Tên đăng nhập',
                      obscureText: false,
                    ),
                    //Divider(thickness: 1.0, color: Colors.grey),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Mật khẩu',
                      obscureText: true,
                    ),
                    //Divider(thickness: 1.0, color: Colors.grey),
                    CustomTextField(
                      controller: _confirmpassController,
                      hintText: 'Xác nhận mật khẩu',
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              //Divider(thickness: 1.0, color: Colors.grey),
              //SizedBox(height: Dimensions.height10),
              Row(
                children: [
                  Checkbox(
                    value: _check,
                    onChanged: (value){
                      setState(() {
                        _check = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Tôi đã đọc và đồng ý với ',
                        style:  TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed',/*fontSize: Dimensions.font18*/),
                        children: [
                          TextSpan(
                            text: 'Điều khoản Dịch vụ',
                            style:TextStyle(
                              fontFamily: 'RobotoCondensed',
                                decoration: TextDecoration.underline,
                                color: AppColors.veriPeri, // Thay AppColors.veriPeri thành màu sắc tương ứng
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          TextSpan(text: ' & '),
                          TextSpan(
                            text: 'Chính Sách Bảo Mật',
                            style:TextStyle(
                              fontFamily: 'RobotoCondensed',
                                decoration: TextDecoration.underline,
                                color: AppColors.veriPeri, // Thay AppColors.veriPeri thành màu sắc tương ứng
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          TextSpan(
                            text: ' của MoonBook',
                            style: TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed',),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //SizedBox(height: Dimensions.height10),
              SizedBox(
                width:  Dimensions.pageView,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.veriPeri,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.height20, vertical: Dimensions.width15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    minimumSize: Size(double.infinity, Dimensions.font26),
                  ),
                  child: Text(
                    'Đăng Ký',
                    style: TextStyle(fontSize: Dimensions.font20,fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'RobotoCondensed'),
                  ),
                ),
              ),
              //SizedBox(height: Dimensions.height5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Đã có tài khoản?',style: TextStyle(fontFamily:'RobotoCondensed',fontSize: Dimensions.font15 ),),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text('Đăng nhập',
                    style: TextStyle(fontFamily: 'RobotoCondensed',
                      color: AppColors.veriPeri,
                      fontWeight: FontWeight.bold,fontSize: Dimensions.font15,decoration: TextDecoration.underline,),),
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
