import 'package:flutter/material.dart';
import 'package:project_mobile/utils/dimensions.dart';

class NormalText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight fontWeight;
  final TextAlign align;
  final TextOverflow overflow;
  final int maxLines;

  const NormalText({
    Key? key,
    required this.text,
    this.color = const Color(0xFF332d2b),
    this.size = 0,
    this.fontWeight = FontWeight.w400,
    this.align = TextAlign.left,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
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
        fontSize: size == 0 ? Dimensions.font15 : size,
        fontWeight: fontWeight,
      ),
    );
  }
}
