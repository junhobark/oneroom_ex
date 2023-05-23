import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/community/communityScreen.dart';
import 'package:oneroom_ex/favorite.dart';
import 'package:oneroom_ex/Info/myInfo/info.dart';
import 'package:oneroom_ex/map/mapScreen.dart';

class RootTab extends StatefulWidget {
  RootTab({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  //vsync에 this를 만나면 작성
  late TabController controller; //late - 나중에 입력, 값을부를땐 이미 선언됐을것
  late double latitude1;
  late double longitude1;

  int index = 0;

  @override
  void initState() {
    latitude1 = widget.latitude;
    longitude1 = widget.longitude;

    super.initState();

    controller = TabController(length: 4, vsync: this); //위젯개수, 스테이트

    controller.addListener(tabListener); //컨트롤러에서 변화생길때마다 실행
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    //속성이 바뀔때마다 tabListener
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: TabBarView(
        //탭바의 뷰
        physics: NeverScrollableScrollPhysics(), //스와이프로 스크롤 되는걸 막음
        controller: controller,
        children: [
          Center(
              child: Container(
            child: mapScreen(latitude: latitude1, longitude: longitude1),
          )),
          Center(
              child: Container(
            child: communityScreen(),
          )),
          Center(
              child: Container(
            child: favoriteScreen(),
          )),
          Center(
              child: Container(
            child: informationScreen(),
          )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        //선택됐을때 색깔
        unselectedItemColor: BODY_TEXT_COLOR,
        //비선택 색깔
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        //네비게이션바 상시 글자
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '리뷰맵'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '관심건물'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: '내정보'),
        ],
      ),
    );
  }
}
