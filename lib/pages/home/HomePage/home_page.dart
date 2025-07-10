import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/account_page.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/message_page.dart';
import 'package:project_mobile/pages/home/HomePage/coffee_page_body.dart';
import 'package:project_mobile/pages/home/BottomNavigationBar/search.dart';
import 'package:project_mobile/pages/home/HomePage/coffee_page_header.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
import 'package:project_mobile/widgets/normal_text.dart';
import 'package:project_mobile/widgets/small_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
          children: [
            CoffeePageHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: CoffeePageBody(),),
            ),
          ]
      ),
    );
  }
}
