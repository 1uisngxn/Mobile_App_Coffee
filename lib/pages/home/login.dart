import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/HomePage/home_page.dart';
import 'package:project_mobile/pages/home/MainPage/main_page.dart';
import 'package:project_mobile/pages/home/register.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/custom_text_field.dart';
import 'package:project_mobile/widgets/social_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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
                'Đăng nhập để nhận được những khuyến mãi và ưu đãi hấp dẫn từ chúng tôi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: Dimensions.font15, color: Colors.grey[700],fontFamily: 'RobotoCondensed'),
              ),
              SizedBox(height: Dimensions.height5),
              SizedBox(
                width: Dimensions.pageView,
                child: SocialButton(
                  icon: Icons.facebook,
                  text: 'Đăng nhập bằng Facebook',
                  color: Color.fromRGBO(60, 90, 153, 1),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: Dimensions.height5),
              SizedBox(
                width: Dimensions.pageView,
                child: SocialButton(
                  icon: Icons.email,
                  text: 'Đăng nhập bằng Google',
                  color: Colors.red,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: Dimensions.height5),
              SizedBox(
                width: Dimensions.pageView,
                child: SocialButton(
                  icon: Icons.apple,
                  text: 'Đăng nhập bằng Apple',
                  color: Colors.black,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Container( width: Dimensions.pageView
                ,child:Row(
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
                ),),

              Container(
                width: Dimensions.pageView,
                child: Column(

                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Tên đăng nhập',
                      obscureText: false,
                    ),
                    Divider(thickness: 1.0, color: Colors.grey),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Mật khẩu',
                      obscureText: true,
                    ),
                    Divider(thickness: 1.0, color: Colors.grey),
                  ],
                ),
              ),
              //Divider(thickness: 1.0, color: Colors.grey),
              //SizedBox(height: Dimensions.height10),
              SizedBox(height: Dimensions.height10),
              TextButton(
                onPressed: () {
                },
                child: Text('Quên mật khẩu?',
                  style: TextStyle(fontFamily: 'RobotoCondensed',
                    color: AppColors.veriPeri,
                    fontWeight: FontWeight.bold,fontSize: Dimensions.font15,decoration: TextDecoration.underline,),),
              ),
              SizedBox(
                width:  Dimensions.pageView,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Mainpage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.veriPeri,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.height20, vertical: Dimensions.width15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    minimumSize: Size(double.infinity, Dimensions.font26),
                  ),
                  child: Text(
                    'Đăng Nhập',
                    style: TextStyle(fontSize: Dimensions.font20,fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'RobotoCondensed'),
                  ),
                ),
              ),
              //SizedBox(height: Dimensions.height5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chưa có tài khoản?',style: TextStyle(fontFamily:'RobotoCondensed',fontSize: Dimensions.font15 ),),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text('Đăng Ký',
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
