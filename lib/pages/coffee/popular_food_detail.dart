/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/app_column.dart';
import 'package:project_mobile/widgets/app_icons.dart';
import 'package:project_mobile/widgets/expandable.dart';
import 'package:project_mobile/widgets/icon_and_text_widget.dart';
import 'package:project_mobile/widgets/normal_text.dart';
import 'package:project_mobile/widgets/small_text.dart';

import '../../widgets/big_text.dart';

class PopularFoodDetail extends StatelessWidget {

  const PopularFoodDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //background image
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                //height:double.maxFinite,
                width: double.maxFinite,
                height: Dimensions.popularCoffeeImgSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/caphecapuchino.jpeg"
                    )
                  )
                ),

          )),
          //icon wid
          Positioned(
              top: Dimensions.height45,
              left: Dimensions.width30,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcons(icon: Icons.arrow_back_ios),
                  AppIcons(icon: Icons.shopping_cart_checkout_outlined)
                ],
              )),
          //introduce of coffee
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimensions.popularCoffeeImgSize-20,
              child: Container(
              padding: EdgeInsets.only(left:Dimensions.width30, right: Dimensions.width20,top: Dimensions.height20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius20),
                      topLeft: Radius.circular(Dimensions.radius20),
                    ),
                color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppColumn(text: "Capuchino Kem Trứng Sữa"),
                    SizedBox(height: Dimensions.height20,),
                    BigText(text: "Mô tả"),
                    SizedBox(height: Dimensions.height10,),
                    Expanded(child: SingleChildScrollView(child: ExpandableTextWidgets(text: "Cà phê Cappuccino kem trứng sữa là sự kết hợp hoàn hảo giữa hương vị đậm đà của cà phê, độ béo ngậy của kem và sự ngọt ngào từ sữa. Mỗi tách Cappuccino kem trứng sữa mang đến trải nghiệm độc đáo, đánh thức mọi giác quan với hương thơm nồng nàn và vị ngon khó cưỡng. Hạt cà phê chất lượng cao được pha chế tỉ mỉ, kết hợp cùng lớp kem trứng mịn màng và sữa tươi nguyên chất, tạo nên một ly cà phê tinh tế và đẳng cấp.Cappuccino kem trứng sữa không chỉ là một thức uống giúp tỉnh táo mà còn mang lại cảm giác sảng khoái, thư giãn tuyệt vời. Lớp kem trứng mềm mịn phủ trên bề mặt kết hợp hoàn hảo với cà phê nóng hổi, tạo ra sự cân bằng hoàn hảo giữa các thành phần.Thưởng thức một tách Cappuccino kem trứng sữa vào buổi sáng không chỉ giúp bạn khởi đầu ngày mới với năng lượng dồi dào mà còn mang lại sự thư thái và hứng khởi. Cappuccino kem trứng sữa là lựa chọn lý tưởng cho những ai yêu thích sự kết hợp hài hòa giữa hương vị cà phê và sự ngọt ngào của sữa và kem trứng.Hãy để mỗi ngày của bạn trở nên đặc biệt và ý nghĩa hơn với Cappuccino kem trứng sữa – bí quyết của sự tỉnh táo và nguồn cảm hứng bất tận."))),
                  ],
                ),
          )),
          //expandable text
        ],
      ),
      bottomNavigationBar: Container(
        height: Dimensions.bottomHeightBar,
        padding: EdgeInsets.only(top: Dimensions.height30,bottom: Dimensions.height30,left: Dimensions.width20,right: Dimensions.width20),
        decoration: BoxDecoration(
          color: AppColors.buttonBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20*2),
            topRight: Radius.circular(Dimensions.radius20*2)
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: Dimensions.height10,
                bottom: Dimensions.height10,
                left: Dimensions.width30,
                right: Dimensions.width20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.remove, color: AppColors.signColor,),
                  SizedBox(width: Dimensions.width10/2,),
                  BigText(text:"0"),
                  SizedBox(width: Dimensions.width10/2,),
                  Icon(Icons.add,color: AppColors.signColor,),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: Dimensions.height10,
                bottom: Dimensions.height10,
                left: Dimensions.width30,
                right: Dimensions.width20,
              ),
              child: BigText(text: "\$10 | Thêm vào giỏ hàng", color: Colors.white,) ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: AppColors.mainColor
              ),
            )
          ],
        ),
      ) ,
    );
  }
}
*/
