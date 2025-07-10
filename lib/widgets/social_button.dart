import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/dimensions.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  SocialButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text,style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: Dimensions.font18),),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.height20, vertical: Dimensions.width15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius5),
        ),
      ),
    );
  }
}