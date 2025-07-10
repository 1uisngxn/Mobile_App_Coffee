import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/icon_and_text_widget.dart';
import 'package:project_mobile/widgets/small_text.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  final TextAlign align;
  final FontWeight fontWeight;

  BigText({Key? key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 0,
  this.overflow = TextOverflow.ellipsis,
     this.align = TextAlign.left,
    this.fontWeight = FontWeight.bold
  }): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'RobotoCondensed',
        color: color,
        fontSize:size==0?Dimensions.font18:size,
          fontWeight: fontWeight
      ),
    );
  }
}
