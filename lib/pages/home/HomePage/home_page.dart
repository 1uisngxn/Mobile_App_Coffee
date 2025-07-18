import 'package:flutter/material.dart';
import 'package:project_mobile/pages/home/HomePage/coffee_page_body.dart';
import 'package:project_mobile/pages/home/HomePage/coffee_page_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            CoffeePageHeader(),
            CoffeePageBody(),
          ],
        ),
      ),
    );
  }
}
