import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/normal_text.dart';
import 'package:project_mobile/widgets/small_text.dart';

class CoffeePageHeader extends StatefulWidget {
  const CoffeePageHeader({super.key});

  @override
  State<CoffeePageHeader> createState() => _CoffeePageHeaderState();
}

class _CoffeePageHeaderState extends State<CoffeePageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.only(top: Dimensions.height45, bottom: Dimensions.height10,left:Dimensions.width20 ),
          padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  NormalText(text: "TP Hồ Chí Minh", color:AppColors.mainColor,),
                  SmallText(text: "Quận 10", color: Colors.black54,)
                ],
              ),
              Container(
                child: Icon(Icons.notifications, color: AppColors.mainColor,size:Dimensions.iconSize28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              )
            ],
          ),
    );
  }

}
