import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          child: Text(
            "Thông báo",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/notification.jpg',
                height: Dimensions.height200),
            SizedBox(height: Dimensions.height20),
            Text(
              'Xem thông báo tại đây!',
              style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: Dimensions.font18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      )
    );
  }
}
