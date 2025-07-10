import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/icon_and_text_widget.dart';
import 'package:project_mobile/widgets/small_text.dart';


class AppColumn extends StatelessWidget {
  final String text;

  const AppColumn({Key? key,
    required this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start ,
      children: [
        BigText(text: text, size: Dimensions.font26,),
        SizedBox(height: Dimensions.height10,),
        Row(
          children: [
            Wrap(
              children: List.generate(5, (index) { return Icon(Icons.star,color:AppColors.mainColor,size: 15,);}),
            ),
            SizedBox(width: 15, ),
            SmallText(text: "4.5"),
            SizedBox(width: 15,),
            SmallText(text: "1287"),
            SizedBox(width: 15,),
            SmallText(text: "Comments"),
          ],
        ),
        SizedBox(height: Dimensions.height10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(
                text: "Normal",
                icon: Icons.circle_sharp,
                iconColor: AppColors.iconColor1),
            //SizedBox(width: 25,),
            IconAndTextWidget(
                text: "1.7km",
                icon: Icons.location_on,
                iconColor: AppColors.mainColor),
            //SizedBox(width: 25,),
            IconAndTextWidget(
                text: "10min",
                icon: Icons.access_time_rounded,
                iconColor: AppColors.iconColor2),
          ],
        )
      ],
    );
  }
}
