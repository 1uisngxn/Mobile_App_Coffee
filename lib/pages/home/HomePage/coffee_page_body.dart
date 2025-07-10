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


class CoffeePageBody extends StatefulWidget {
  const CoffeePageBody({Key? key}): super(key: key);

  @override
  State<CoffeePageBody> createState() => _CoffeePageBodyState();
}

class _CoffeePageBodyState extends State<CoffeePageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageView;
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
    return  Column(
        children: [
          //slider section-banner
        Container(
        // Cài đặt chiều cao của PageView
        height: Dimensions.pageViewContainers,
        child: PageView.builder(
          controller: pageController, // Điều khiển PageView
          itemCount: bannerList.length, // Số lượng trang con
          itemBuilder: (context, index) {
            return _buildPageItem(index); // Trả về nội dung của từng trang
          }
        ),
      ),
          //dots
          SizedBox(height: Dimensions.height10,),
          new DotsIndicator(
          dotsCount: 5,
          position: _currPageValue.toInt(),
          decorator: DotsDecorator(
            activeColor:AppColors.mainColor,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          ),
          SizedBox(height: Dimensions.height10,),
          Container(
            margin: EdgeInsets.only(left: Dimensions.width20,),
            padding: EdgeInsets.only(left:Dimensions.width20,right:Dimensions.width40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Căn lề về bên trái
              children: [
                BigText(
                  text: "Categories",
                  color: Color(0xFF6667AB), // Màu Very Peri
                  size: 30, // Kích thước lớn hơn
                  align: TextAlign.left,
                    fontWeight: FontWeight.w700// Căn lề về bên trái
                ),
                SizedBox(height: Dimensions.height5,),
                Container(
                  /*margin: EdgeInsets.only(left: Dimensions.width20,),
                  padding: EdgeInsets.only(left:Dimensions.width20,right:Dimensions.width40),*/
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor:AppColors.mainColor, // Màu chữ
                            ),
                            child: NormalText(text: "Tổng hợp",color: AppColors.textColor_white,),),
                            SizedBox(width: Dimensions.width30,),
                        ElevatedButton(
                            onPressed: (){},
                            child: NormalText(text:"Cà phê thơm",)),
                            SizedBox(width: Dimensions.width30,),
                        ElevatedButton(
                            onPressed: (){},
                            child: NormalText(text:"Thức uống dinh dưỡng",)),
                        SizedBox(width: Dimensions.width30,),
                        ElevatedButton(
                            onPressed: (){},
                            child: NormalText(text:"Capuchino",)),
                        SizedBox(width: Dimensions.width30,),
                        ElevatedButton(
                            onPressed: (){},
                            child: NormalText(text:"Đá xay",)),
                        SizedBox(width: Dimensions.width30,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height5,),
                BigText(
                    text: "Best Sales",
                    color: AppColors.veriPeri, // Màu Very Peri
                    size: 30,
                    align: TextAlign.left,
                    fontWeight: FontWeight.w700
                ),
              ],
            ),
          ),
          //gridofcoffee
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      children: [
                        SizedBox(height: Dimensions.height5),
                        BigText(text: coffeeList[index].name),
                        SizedBox(height: Dimensions.height5),
                        SmallText(text: coffeeList[index].short_description),
                        SizedBox(height: Dimensions.height5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconAndTextWidget(
                              text: coffeeList[index].status,
                              icon: Icons.circle_sharp,
                              iconColor: AppColors.iconColor1,
                            ),
                            IconAndTextWidget(
                              text: coffeeList[index].distance,
                              icon: Icons.location_on,
                              iconColor: AppColors.mainColor,
                            ),
                            IconAndTextWidget(
                              text: coffeeList[index].time,
                              icon: Icons.access_time_rounded,
                              iconColor: AppColors.iconColor2,
                            ),
                          ],
                        ),
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
                    ),
                  ],
                ),
              ),);
            },
          ),
          )
          ],
          );
        }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = new Matrix4.identity();
    if(index==_currPageValue.floor())
    {
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0  );
    }
    else if (index ==_currPageValue.floor()+1)
    {
      var currScale = _scaleFactor+(_currPageValue-index+1)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0  );

    }
    else if (index ==_currPageValue.floor()-1)
    {
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0  );

    }
    else {
      var currScale=0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2 , 1);
    }
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
      Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        color: index.isEven ? Color.fromARGB(102, 125, 98, 201) : Color(0xFF9294cc),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(bannerList[index].imageUrl),

        ),
      ),
    )
        ],
      ),
    );
  }
}
