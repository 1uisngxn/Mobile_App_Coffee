import 'package:flutter/cupertino.dart';
import 'package:project_mobile/utils/dimensions.dart';

class NormalText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  //TextOverflow overflow;
  NormalText({super.key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 0,
    //this.overflow = TextOverflow.ellipsis
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      //overflow: overflow,
      style: TextStyle(
          fontFamily: 'RobotoCondensed',
          color: color,
          fontSize:size==0?Dimensions.font15:size,
          fontWeight: FontWeight.w400
      ),
    );
  }
}
