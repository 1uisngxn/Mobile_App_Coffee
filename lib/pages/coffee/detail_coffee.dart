import 'package:flutter/material.dart';
import 'package:project_mobile/data/product/item/product_model.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/app_icons.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/expandable.dart';
import 'package:project_mobile/widgets/icon_and_text_widget.dart';
import 'package:project_mobile/widgets/normal_text.dart';


class CoffeeDetailScreen extends StatefulWidget {
  final Coffee coffeeItem;

  CoffeeDetailScreen({required this.coffeeItem});

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                AppIcons(
                  iconSize: Dimensions.iconSize24,
                  iconColor:Colors.white,
                  backgroundColor:AppColors.mainColor,
                  icon: Icons.favorite,
                  onPressed: (){},
                )
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height20),
              child: Container(
                margin: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width20),
                alignment: Alignment.center,
                child: BigText(text:widget.coffeeItem.name,size:Dimensions.font20,color: AppColors.veriPeri,),
                width: double.maxFinite,
                padding: EdgeInsets.only(top:Dimensions.height10,bottom: Dimensions.height10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius20),
                      topLeft: Radius.circular(Dimensions.radius20),
                    )
                ),
              ),
            ),
            pinned: true ,
            backgroundColor: AppColors.mainColor2,
            expandedHeight: Dimensions.height200+100,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(widget.coffeeItem.imageUrl,
                width:double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: Dimensions.height10,),
                  Container(

                      child: ExpandableTextWidgets(text:widget.coffeeItem.description),
                      margin: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width20)
                  )
                ],
              )
          )
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: Dimensions.width30*2.5,
              right: Dimensions.width30*2.5,
              top: Dimensions.height10,
              bottom: Dimensions.height10,
            ),
          ),
          Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(top: Dimensions.height10,bottom: Dimensions.height10,left: Dimensions.width20,right: Dimensions.width40),
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
                  child:Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Define the action when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: AppColors.mainColor, // Text and icon color
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart),
                          SizedBox(width: Dimensions.width10), // Add spacing between the icon and the text
                          NormalText(text: 'Thêm vào giỏ hàng',color: AppColors.textColor_white,),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.height10,
                    bottom: Dimensions.height10,
                    left: Dimensions.width30,
                    right: Dimensions.width30,
                  ),
                  child: BigText(text: 'Giá: ${widget.coffeeItem.price}', color: Colors.white,) ,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: AppColors.mainColor
                  ),
                )
              ],
            ),
          ) ,
        ],
      ),
    );
  }
}