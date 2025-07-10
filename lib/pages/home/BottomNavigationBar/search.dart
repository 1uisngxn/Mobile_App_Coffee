import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/data/banner/banner_data.dart';
import 'package:project_mobile/data/product/item/product_data.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';
//import 'package:project_mobile/widgets/app_column.dart';
import 'package:project_mobile/widgets/big_text.dart';
import 'package:project_mobile/widgets/icon_and_text_widget.dart';
import 'package:project_mobile/widgets/normal_text.dart';
import 'package:project_mobile/widgets/small_text.dart';

import '../../coffee/detail_coffee.dart';
class SearchPage extends StatefulWidget {

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }
  @override
  void dispose() {
    //TODO: implement dispose
    pageController.dispose();
    //super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Tìm kiếm",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.mainColor,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BigText(text:
                'Tìm Kiếm',
                  color: Color(0xFF6667AB), // Màu Very Peri
                  size: 30, // Kích thước lớn hơn
                  align: TextAlign.left,
                  fontWeight: FontWeight.w700
                ),
              SizedBox(height: Dimensions.height10),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: 'Tìm món ngon ở đây.....',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius5),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Được Đề Xuất',
                style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 24, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: Dimensions.height20),
              Container(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Dimensions.width10,
                    mainAxisSpacing: Dimensions.height10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: coffeeList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to detail screen when image is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoffeeDetailScreen(coffeeItem: coffeeList[index]),
                          ),
                        );
                      },
                      child:Container(
                        margin: EdgeInsets.only(left:Dimensions.width20,right:Dimensions.width20),
                        padding: EdgeInsets.all(Dimensions.width20),
                        height: Dimensions.pageViewContainers,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: Dimensions.listViewImgSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.radius20),
                                  topRight: Radius.circular(Dimensions.radius20),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(coffeeList[index].imageUrl),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: Dimensions.height5),
                                BigText(text: coffeeList[index].name),
                                SizedBox(height: Dimensions.height5),
                                SmallText(text: coffeeList[index].short_description),
                                SizedBox(height: Dimensions.height5),
                                SizedBox(height: Dimensions.height5),
                                Text(
                                  coffeeList[index].price ?? 'N/A',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Dimensions.font15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.veriPeri,
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
