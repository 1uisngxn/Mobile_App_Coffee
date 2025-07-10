import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/small_text.dart';


class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const IconAndTextWidget({Key? key,
    required this.text,
    required this.icon,
    required this.iconColor
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color: iconColor,size:Dimensions.iconSize16-6),
        SizedBox(width:2,),
        SmallText(text: text,),
      ],
    );
  }
}
