import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/icon_and_text_widget.dart';
import 'package:project_mobile/widgets/small_text.dart';


class AppIcons extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final VoidCallback onPressed;
  const AppIcons({Key? key,
    required this.icon,
    this.backgroundColor= const Color(0xFFfcf4e4),
    this.iconColor = const Color(0xFF756d54),
    this.size=40,
    this.iconSize=16,
    required this.onPressed,
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: size,

      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
        color: backgroundColor
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,

      ),
    );
  }
}
