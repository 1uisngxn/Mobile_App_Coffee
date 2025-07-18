import 'package:flutter/material.dart';
import 'package:project_mobile/utils/dimensions.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final double height;
  final FontWeight fontWeight;
  final TextAlign align;
  final TextOverflow overflow;
  final int maxLines;

  const SmallText({
    Key? key,
    required this.text,
    this.color = const Color(0xFFccc7c5),
    this.size = 0,
    this.height = 1.2,
    this.fontWeight = FontWeight.w400,
    this.align = TextAlign.left,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'RobotoCondensed',
        color: color,
        fontSize: size == 0 ? Dimensions.font12 : size,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}
