import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/map/favorite/favorite.dart';
import 'package:oneroom_ex/Info/info.dart';
import 'package:oneroom_ex/map/pos_provideer.dart';
import 'package:provider/provider.dart';

import '../community/communityScreen.dart';
import '../map/mapScreen.dart';

class RootTab extends StatefulWidget {
  RootTab({
    required this.latitude,
    required this.longitude,
    required this.location,
  });

  final double latitude;
  final double longitude;
  final String location;
  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  //vsync에 this를 만나면 작성
  late TabController controller; //late - 나중에 입력, 값을부를땐 이미 선언됐을것
  late double latitude;
  late double longitude;
  late String location;
  int index = 0;

  @override
  void initState() {
    latitude = widget.latitude;
    longitude = widget.longitude;
    location = widget.location;
    super.initState();

    controller = TabController(length: 4, vsync: this); //위젯개수, 스테이트
    controller.addListener(tabListener); //컨트롤러에서 변화생길때마다 실행
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    controller.dispose();
    super.dispose();
  }

  void tabListener() {
    //속성이 바뀔때마다 tabListener
    setState(() {
      if (index == 0) {
        latitude = Provider.of<POSProvider>(context, listen: false).posx;
        longitude = Provider.of<POSProvider>(context, listen: false).posy;
        location = '';
      }
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
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
      child: TabBarView(
        //탭바의 뷰
        physics: NeverScrollableScrollPhysics(), //스와이프로 스크롤 되는걸 막음
        controller: controller,
        children: [
          Center(
              child: Container(
            child: mapScreen(
              latitude: latitude,
              longitude: longitude,
              location: location,
            ),
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
    );
  }
}
