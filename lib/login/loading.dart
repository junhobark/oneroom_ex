import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/root_tab.dart';
import 'package:oneroom_ex/map/pos_provideer.dart';
import 'package:provider/provider.dart';

import 'my_location.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void initState() {
    super.initState();
    getLocation();
  }

  late double latitude3;
  late double longitude3;
  void getLocation() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude3 = myLocation.latitude2;
    longitude3 = myLocation.longitude2;
    print(latitude3);
    print(longitude3);
    Provider.of<POSProvider>(context, listen: false)
        .setpos(latitude3, longitude3);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RootTab(
        latitude: latitude3,
        longitude: longitude3,
        location: '',
      );
    }));
  }

  /*void fetchData() async {

      var myJson = parsingData['id'];
      print(myJson);
    }
    print(response.body);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //컨테이너 위젯
        //컨테이너를 디자인하는 클래스
        decoration: BoxDecoration(
          color: Colors.white, //색상
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/img/logo/login_logo.png',
                  width: 300,
                ),
                SizedBox(height: 16),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
