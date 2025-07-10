import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/dimensions.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Message",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width10 + 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Trò chuyện', 0),
                _buildTabButton('Thông báo', 1),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                _buildChatPage(),
                _buildNotificationPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.height10, horizontal: Dimensions.width100),
        margin: EdgeInsets.only(left: Dimensions.width10),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? AppColors.veriPeri
              : AppColors.mainColor,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'RobotoCondensed',
            color: AppColors.textColor_white,
          ),
        ),
      ),
    );
  }

  Widget _buildChatPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/support_agent.png',
              height: Dimensions.height200),
          SizedBox(height: Dimensions.height20),
          Text(
            'Xem cuộc trò chuyện của bạn với nhân viên hỗ trợ tại đây!',
            style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: Dimensions.font18,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            'Bạn cũng có thể yêu cầu hỗ trợ thông qua Trung tâm trợ giúp.',
            style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: Dimensions.font15,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/notication.png',
              height: Dimensions.height200,
          width: Dimensions.pageView,),
          SizedBox(height: Dimensions.height10),
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
    );
  }
}
