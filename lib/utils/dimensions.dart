import 'package:get/get.dart';
class Dimensions{
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;


  static double pageView= screenHeight/2.64;
  //852/220
  static double pageViewContainers = screenHeight/3.873;
  //852/120
  static double pageViewTextContainers = screenHeight/7.08;
  //static double pageViewContainers_ = screenHeight/2.64 + screenHeight/3.84;
//Screen Height: 852.0
//Screen Width: 393.0
//size of height 852.0
  static double height10 = screenHeight/85.2;
  static double height5 = screenHeight/170.4;
  static double height15 = screenHeight/56.8;
  static double height20 = screenHeight/42.6;
  static double height30 = screenHeight/28.24;
  static double height45 = screenHeight/18.93;
  static double height60 = screenHeight/14.2;
  static double height200 = screenHeight/4.26;


//Size of width
  static double width10 = screenWidth/84.4;
  static double width15 = screenWidth/56.27;
  static double width20 = screenWidth/42.2;
  static double width30 = screenWidth/28.13;
  static double width40 = screenWidth/21.1;
  static double width100 = screenWidth/8.44;
//font size
  static double font20 = screenHeight/42.6;
  static double font18 = screenHeight/47.33;
  static double font15 = screenHeight/56.8;
  static double font26 = screenHeight/32.769;
  static const double font14 = 14.0;
  static double font16 = screenHeight / 52.75; // hoặc bất kỳ tỉ lệ phù hợp
//Radius
  static double radius5 = screenHeight/170.4;
  static double radius15 = screenHeight/56.8;
  static double radius20 = screenHeight/42.6;
  static double radius30 = screenHeight/28.4;

//iconSize
  static double iconSize24 = screenHeight/35.5;
  static double iconSize28 = screenHeight/30.429;
  static double iconSize16 = screenHeight/53.25;


//list view
  static double listViewImgSize =  screenWidth/3.25;
  static double listViewTextContSize =  screenWidth/3.9;
//popular food
  static double popularCoffeeImgSize = screenHeight/2.43;

//bottom height
  static double bottomHeightBar = screenHeight/8;
}